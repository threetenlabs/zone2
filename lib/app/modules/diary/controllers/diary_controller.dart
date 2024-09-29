import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';
import 'package:zone2/app/services/health_service.dart';

import 'package:zone2/app/services/notification_service.dart'; // Ensure you have the health package imported

class DiaryController extends GetxController {
  final logger = Get.find<Logger>();
  final healthService = Get.find<HealthService>();

  // // Define the types to get
  var types = [
    HealthDataType.STEPS,
  ];

  final count = 0.obs;
  final weightWhole = 70.obs;
  final weightDecimal = 0.obs;
  final healthData = RxList<HealthDataPoint>();
  final isWeightLogged = false.obs; // Track if weight is logged

  List<HealthDataAccess> get permissions => types
      .map((type) =>
          // can only request READ permissions to the following list of types on iOS
          [
            HealthDataType.WALKING_HEART_RATE,
            HealthDataType.ELECTROCARDIOGRAM,
            HealthDataType.HIGH_HEART_RATE_EVENT,
            HealthDataType.LOW_HEART_RATE_EVENT,
            HealthDataType.IRREGULAR_HEART_RATE_EVENT,
            HealthDataType.EXERCISE_TIME,
          ].contains(type)
              ? HealthDataAccess.READ
              : HealthDataAccess.READ)
      .toList();
  @override
  void onInit() async {
    super.onInit();
    await loadHealthData();
  }

  Future<void> loadHealthData() async {
    try {
      final authorized = await healthService.authorize(); // Example types
      if (!authorized) {
        logger.e('Authorization not granted');
        return;
      }

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 1));

      // Log types and permissions for debugging
      logger.i('Types: $types');
      logger.i('Permissions: $permissions');
      logger.i('Authorized: $authorized');
      logger.i('Now: $now');
      logger.i('Yesterday: $yesterday');

      final healthConnectStatus = await healthService.getHealthConnectSdkStatus();
      logger.i('Health Connect SDK Status: $healthConnectStatus');
      // Fetch health data
      final healthData = await healthService.getHealthData(startTime: yesterday, endTime: now);

      final dedupedHealthData = Health().removeDuplicates(healthData);

      healthData.assignAll(dedupedHealthData); // Use assignAll to update the RxList

      logger.i('Health data: $healthData');
    } catch (e) {
      logger.e('Error loading health data: $e');
    }
  }

  Future<void> saveWeightToHealth() async {
    try {
      final weight =
          weightWhole.value + (weightDecimal.value / 100); // Combine whole and decimal parts

      // Call the HealthService to save the weight
      await healthService.saveWeightToHealth(weight);

      // Send success notification
      NotificationService.to
          .showSuccess('Weight Saved', 'Your weight has been successfully saved to health data.');

      // Update the weight logged state
      isWeightLogged.value = true;
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }
}
