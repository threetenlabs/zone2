import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/modules/diary/controllers/activity_manager.dart';

void main() {
  late HealthActivityManager activityManager;
  late Logger logger;

  setUp(() {
    // Initialize the logger and activity manager
    logger = Logger();
    Get.put(logger);
    activityManager = HealthActivityManager();
  });

  tearDown(() {
    Get.reset();
  });

  group('HealthActivityManager', () {
    test('should initialize with empty records', () {
      expect(activityManager.heartRateRecords, isEmpty);
      expect(activityManager.stepRecords, isEmpty);
      expect(activityManager.workoutRecords, isEmpty);
    });

    test('should process activity data correctly', () {
      final activityData = [
        HealthDataPoint(
          uuid: 'test1',
          value: NumericHealthValue(numericValue: 80),
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          dateFrom: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'TestSourceDeviceId',
          dateTo: DateTime.now(),
          sourceName: 'TestSource',
          sourceId: 'TestSourceId',
        ),
        HealthDataPoint(
          uuid: 'test2',
          value: NumericHealthValue(numericValue: 200),
          type: HealthDataType.TOTAL_CALORIES_BURNED,
          unit: HealthDataUnit.KILOCALORIE,
          dateFrom: DateTime.now(),
          dateTo: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'TestSourceDeviceId',
          sourceName: 'TestSource',
          sourceId: 'TestSourceId',
        ),
        HealthDataPoint(
          uuid: 'test3',
          value: NumericHealthValue(numericValue: 1000),
          type: HealthDataType.STEPS,
          unit: HealthDataUnit.COUNT,
          dateFrom: DateTime.now(),
          dateTo: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'TestSourceDeviceId',
          sourceName: 'TestSource',
          sourceId: 'TestSourceId',
        ),
      ];

      activityManager.processDailyActivityData(activityData: activityData, userAge: 30);

      expect(activityManager.heartRateRecords.length, 1);
      expect(activityManager.stepRecords.length, 1);
      expect(activityManager.totalSteps.value, 1000);
      expect(activityManager.totalCaloriesBurned.value, 200.0);
    });

    test('should calculate heart rate zones correctly', () {
      final heartRateData = [
        HealthDataPoint(
          uuid: 'test4',
          value: NumericHealthValue(numericValue: 150),
          type: HealthDataType.HEART_RATE,
          unit: HealthDataUnit.BEATS_PER_MINUTE,
          dateFrom: DateTime.now(),
          dateTo: DateTime.now(),
          sourcePlatform: HealthPlatformType.googleHealthConnect,
          sourceDeviceId: 'TestSourceDeviceId',
          sourceName: 'TestSource',
          sourceId: 'TestSourceId',
        ),
      ];

      activityManager.processDailyActivityData(activityData: heartRateData, userAge: 30);

      expect(activityManager.zoneMinutes[3], greaterThan(0)); // Assuming 150 BPM falls in Zone 3
    });

    // Add more tests for other methods and edge cases
  });
}
