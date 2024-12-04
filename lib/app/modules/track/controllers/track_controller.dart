import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/modules/diary/controllers/activity_manager.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart';

class TrackController extends GetxController {
  final count = 0.obs;
  final healthService = Get.find<HealthService>();
  final logger = Get.find<Logger>();
  final zone2User = Rxn<Zone2User>();

  final selectedTimeFrame = TimeFrame.week.obs;

  // Activity tracking
  final activityManager = Get.find<HealthActivityManager>().obs;

  @override
  void onInit() async {
    super.onInit();
    zone2User.value = AuthService.to.appUser.value;

    activityManager.value.journeyWeightDataLoading.listen((loading) {
      if (!loading) {
        applyFilter();
      }
    });

    activityManager.value.journeyActivityDataLoading.listen((loading) {
      if (!loading) {
        applyFilter();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    applyFilter();
  }

  void applyFilter() {
    activityManager.value.applyJourneyWeightFilter(selectedTimeFrame.value);
    activityManager.value.applyJourneyStepFilter(selectedTimeFrame.value);
    activityManager.value.applyJourneyZonePointFilter(selectedTimeFrame.value);
    update();
  }

  List<WeightDataRecord> getTrendLineData() {
    if (activityManager.value.filteredJourneyWeightData.isEmpty) return [];
    final journeyStartDate = zone2User.value!.zoneSettings?.journeyStartDate.toDate().toString();
    DateTime startDate = DateTime.parse(journeyStartDate ?? DateTime.now().toString());
    DateTime weightStartDate =
        DateFormat('M/d/yy').parse(activityManager.value.filteredJourneyWeightData.first.date);
    DateTime endDate =
        DateFormat('M/d/yy').parse(activityManager.value.filteredJourneyWeightData.last.date);

    DateTime trendStartDate = startDate.isBefore(weightStartDate) ? weightStartDate : startDate;
    double startWeight = activityManager.value.filteredJourneyWeightData.first.weight;
    double targetWeight = 190.0;

    return [
      WeightDataRecord(DateFormat('M/d/yy').format(trendStartDate), startWeight),
      WeightDataRecord(DateFormat('M/d/yy').format(endDate), targetWeight),
    ];
  }
}
