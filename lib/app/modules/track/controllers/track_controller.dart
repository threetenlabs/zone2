import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/modules/diary/controllers/activity_manager.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

class TrackController extends GetxController {
  final count = 0.obs;
  final healthService = Get.find<HealthService>();
  final logger = Get.find<Logger>();
  final zone2User = Rxn<Zone2User>();
  final userAge = Rxn<int>();
  final userWeightData = Rx<List<WeightData>>([]);
  final weightDataLoading = RxBool(false);

  // Activity tracking
  final activityManager = HealthActivityManager().obs;

  @override
  void onInit() async {
    super.onInit();
    zone2User.value = AuthService.to.appUser.value;

    // Parse the birthdate using the correct format
    final birthDate = DateFormat('MM-dd-yyyy')
        .parse(zone2User.value?.zoneSettings?.birthDate ?? DateTime.now().toString());

    userAge.value = (DateTime.now().year - birthDate.year).toInt();
    AuthService.to.appUser.stream.listen((user) async {
      logger.i('zone2User: $user');
      zone2User.value = user;
    });

    retrieveHealthData();
  }

  Future<void> retrieveHealthData() async {
    retrieveActivityData();
    getWeightData(TimeFrame.allTime);
  }

  // Method to get weight data based on time frame
  Future<void> getWeightData(TimeFrame timeFrame) async {
    weightDataLoading.value = true;
    final startDate = zone2User.value!.zoneSettings?.journeyStartDate.toDate();
    logger.i('startDate: $startDate');
    final weightData = await healthService.getWeightData(
        timeFrame: timeFrame, seedDate: DateTime.now(), startDate: startDate);

    // Group by date and take the last entry for each date
    Map<String, HealthDataPoint> latestEntries = {};
    for (var dataPoint in weightData) {
      String dateKey = DateFormat('M/d/yy').format(dataPoint.dateFrom);
      if (!latestEntries.containsKey(dateKey) ||
          latestEntries[dateKey]!.dateFrom.isBefore(dataPoint.dateFrom)) {
        latestEntries[dateKey] = dataPoint;
      }
    }

    // Convert the latest entries to WeightData, converting kg to lbs
    final weightEntries = await Future.wait(latestEntries.values.map((dataPoint) async =>
        WeightData(
            DateFormat('M/d/yy').format(dataPoint.dateFrom),
            // Await the conversion to ensure we get a double value
            await healthService.convertWeightUnit(
                (dataPoint.value as NumericHealthValue).numericValue.toDouble(),
                WeightUnit.pound))));
    userWeightData.value = weightEntries;
    weightDataLoading.value = false;
  }

  Future<void> retrieveActivityData({bool? forceRefresh = false}) async {
    final types = [HealthDataType.HEART_RATE, HealthDataType.WORKOUT, HealthDataType.STEPS];
    final startDate = zone2User.value!.zoneSettings?.journeyStartDate.toDate();
    final allActivityData = await healthService.getActivityData(
        timeFrame: TimeFrame.allTime,
        seedDate: DateTime.now(),
        types: types,
        forceRefresh: forceRefresh,
        startDate: startDate);
    activityManager.value
        .processAggregatedActivityData(activityData: allActivityData, userAge: userAge.value ?? 30);
  }
}
