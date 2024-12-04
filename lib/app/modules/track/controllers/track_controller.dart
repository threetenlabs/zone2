import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/activity.dart';
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
  final filteredWeightData = Rx<List<WeightData>>([]);
  final weightDataLoading = false.obs;
  final activityDataLoading = false.obs;
  final selectedTimeFrame = TimeFrame.week.obs;

  // Activity tracking
  final activityManager = HealthActivityManager().obs;

  final filteredStepData = Rx<List<StepRecord>>([]);
  final filteredZonePointData = Rx<List<ZonePointRecord>>([]);

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
    getWeightData();
  }

  // Method to get weight data based on time frame
  Future<void> getWeightData() async {
    weightDataLoading.value = true;
    final startDate = zone2User.value!.zoneSettings?.journeyStartDate.toDate();
    logger.i('startDate: $startDate');
    final weightData = await healthService.getWeightData(
        timeFrame: TimeFrame.allTime, seedDate: DateTime.now(), startDate: startDate);

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
    getFilteredWeightData();
    update();
  }

  Future<void> retrieveActivityData({bool? forceRefresh = false}) async {
    activityDataLoading.value = true;
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
    activityDataLoading.value = false;
    getFilteredStepData();
    getFilteredZonePointData();
    update();
  }

  void getFilteredWeightData() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedTimeFrame.value) {
      case TimeFrame.week:
        startDate = now.subtract(Duration(days: 7));
        filteredWeightData.value = userWeightData.value.where((data) {
          DateTime date = DateFormat('M/d/yy').parse(data.date);
          return date.isAfter(startDate);
        }).toList();
        break;
      case TimeFrame.month:
        startDate = now.subtract(Duration(days: 30));
        filteredWeightData.value = userWeightData.value.where((data) {
          DateTime date = DateFormat('M/d/yy').parse(data.date);
          return date.isAfter(startDate);
        }).toList();
        break;
      case TimeFrame.sixMonths:
        startDate = now.subtract(Duration(days: 180));
        filteredWeightData.value = userWeightData.value.where((data) {
          DateTime date = DateFormat('M/d/yy').parse(data.date);
          return date.isAfter(startDate);
        }).toList();
        break;
      case TimeFrame.allTime:
      default:
        filteredWeightData.value = userWeightData.value;
    }
    update();
  }

  void getFilteredStepData() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedTimeFrame.value) {
      case TimeFrame.week:
        startDate = now.subtract(Duration(days: 7));
        break;
      case TimeFrame.month:
        startDate = now.subtract(Duration(days: 30));
        break;
      case TimeFrame.sixMonths:
        startDate = now.subtract(Duration(days: 180));
        break;
      case TimeFrame.allTime:
      default:
        startDate = DateTime(2000); // Arbitrary early date for all-time data
    }

    filteredStepData.value = activityManager.value.dailyStepRecords.where((record) {
      return record.dateFrom.isAfter(startDate);
    }).toList();
    update();
  }

  void getFilteredZonePointData() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedTimeFrame.value) {
      case TimeFrame.week:
        startDate = now.subtract(Duration(days: 7));
        break;
      case TimeFrame.month:
        startDate = now.subtract(Duration(days: 30));
        break;
      case TimeFrame.sixMonths:
        startDate = now.subtract(Duration(days: 180));
        break;
      case TimeFrame.allTime:
      default:
        startDate = DateTime(2000); // Arbitrary early date for all-time data
    }

    filteredZonePointData.value = activityManager.value.dailyZonePointRecords.where((record) {
      return record.dateFrom.isAfter(startDate);
    }).toList();
    update();
  }

  List<WeightData> getTrendLineData() {
    if (userWeightData.value.isEmpty) return [];
    final journeyStartDate = zone2User.value!.zoneSettings?.journeyStartDate.toDate().toString();
    DateTime startDate = DateTime.parse(journeyStartDate ?? DateTime.now().toString());
    DateTime weightStartDate = DateFormat('M/d/yy').parse(userWeightData.value.first.date);
    DateTime endDate = DateFormat('M/d/yy').parse(userWeightData.value.last.date);

    DateTime trendStartDate = startDate.isBefore(weightStartDate) ? weightStartDate : startDate;
    double startWeight = userWeightData.value.first.weight;
    double targetWeight = 190.0;

    return [
      WeightData(DateFormat('M/d/yy').format(trendStartDate), startWeight),
      WeightData(DateFormat('M/d/yy').format(endDate), targetWeight),
    ];
  }
}
