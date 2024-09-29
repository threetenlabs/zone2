import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

enum WeightUnit { kilogram, pound }

enum WaterUnit { ounce, liter }

enum TimeFrame {
  lastDay,
  lastWeek,
  lastThreeMonths,
  lastSixMonths,
  all,
}

class HealthService extends GetxService {
  final logger = Get.find<Logger>();
  final isAuthorized = false.obs;
  final status = HealthConnectSdkStatus.sdkUnavailable.obs;

  final List<HealthDataType> _writePermissionTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.WATER,
    HealthDataType.NUTRITION,
  ];

  /// List of data types available on iOS
  final List<HealthDataType> dataTypesIOS = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.AUDIOGRAM,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_CAFFEINE,
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.ELECTRODERMAL_ACTIVITY,
    HealthDataType.FORCED_EXPIRATORY_VOLUME,
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.HEIGHT,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.PERIPHERAL_PERFUSION_INDEX,
    HealthDataType.STEPS,
    HealthDataType.WAIST_CIRCUMFERENCE,
    HealthDataType.WEIGHT,
    HealthDataType.FLIGHTS_CLIMBED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.MINDFULNESS,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.WATER,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.WORKOUT,
    HealthDataType.HEADACHE_NOT_PRESENT,
    HealthDataType.HEADACHE_MILD,
    HealthDataType.HEADACHE_MODERATE,
    HealthDataType.HEADACHE_SEVERE,
    HealthDataType.HEADACHE_UNSPECIFIED,

    // note that a phone cannot write these ECG-based types - only read them
    HealthDataType.ELECTROCARDIOGRAM,
    HealthDataType.HIGH_HEART_RATE_EVENT,
    HealthDataType.IRREGULAR_HEART_RATE_EVENT,
    HealthDataType.LOW_HEART_RATE_EVENT,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WALKING_HEART_RATE,
    HealthDataType.ATRIAL_FIBRILLATION_BURDEN,

    HealthDataType.NUTRITION,
    HealthDataType.GENDER,
    HealthDataType.BLOOD_TYPE,
    HealthDataType.BIRTH_DATE,
    HealthDataType.MENSTRUATION_FLOW,
  ];

  /// List of data types available on Android.
  ///
  /// Note that these are only the ones supported on Android's Health Connect API.
  /// Android's Health Connect has more types that we support in the [HealthDataType]
  /// enumeration.
  final List<HealthDataType> dataTypesAndroid = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE_IN_BED,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_UNKNOWN,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WATER,
    HealthDataType.WORKOUT,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.FLIGHTS_CLIMBED,
    HealthDataType.NUTRITION,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.MENSTRUATION_FLOW,
  ];

  Future<double> convertWeightUnit(dynamic weight, WeightUnit toUnit) async {
    double convertedWeight;
    if (toUnit == WeightUnit.pound) {
      convertedWeight = weight * 2.20462;
    } else if (toUnit == WeightUnit.kilogram) {
      convertedWeight = weight / 2.20462;
    } else {
      throw Exception('Unsupported weight unit conversion');
    }
    return convertedWeight;
  }

  Future<double> convertWaterUnit(dynamic water, WaterUnit toUnit) async {
    double convertedWater;
    if (toUnit == WaterUnit.ounce) {
      convertedWater = water * 16;
    } else if (toUnit == WaterUnit.liter) {
      convertedWater = water / 16;
    } else {
      throw Exception('Unsupported water unit conversion');
    }
    return convertedWater; // Ensure a return statement is present
  }

  Future<DateTime> getStartTimeForTimeFrame(DateTime endTime, TimeFrame timeFrame) async {
    DateTime startTime;
    switch (timeFrame) {
      case TimeFrame.lastDay:
        startTime = endTime.subtract(const Duration(days: 1));
        break;
      case TimeFrame.lastWeek:
        startTime = endTime.subtract(const Duration(days: 7));
        break;
      case TimeFrame.lastThreeMonths:
        startTime = endTime.subtract(const Duration(days: 90));
        break;
      case TimeFrame.lastSixMonths:
        startTime = endTime.subtract(const Duration(days: 180));
        break;
      case TimeFrame.all:
        startTime = DateTime(0); // Start from the epoch for all data
        break;
      default:
        return DateTime.now(); // Return current time for unhandled cases
    }
    return startTime;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    Health().configure();
    Health().getHealthConnectSdkStatus();
    isAuthorized.value = await authorize();
  }

  Future<bool> authorize() async {
    List<HealthDataType> types = GetPlatform.isIOS ? dataTypesIOS : dataTypesAndroid;
    List<HealthDataAccess> permissions = [];

    // Determine permissions based on requested data types
    permissions.addAll(types.map((type) => _writePermissionTypes.contains(type)
        ? HealthDataAccess.READ_WRITE
        : HealthDataAccess.READ));

    await Permission.activityRecognition.request();
    await Permission.location.request();

    final status = await Health().getHealthConnectSdkStatus();
    logger.i('Health Connect SDK Status: $status');
    logger.i('Types count: ${types.length}');
    logger.i('Permissions count: ${permissions.length}');

    final hasPermissions = await Health().hasPermissions(types, permissions: permissions);

    bool authorized = false;
    if (hasPermissions != null && !hasPermissions) {
      try {
        authorized = await Health().requestAuthorization(types, permissions: permissions);
      } catch (error) {
        logger.e("Exception in authorize: $error");
      }
    }

    logger.i('Authorized: $authorized');
    return authorized;
  }

  Future<List<HealthDataPoint>> getHealthData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = GetPlatform.isIOS ? dataTypesIOS : dataTypesAndroid;
    try {
      DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame); // Use the new method
      final healthData = await Health()
          .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
      return Health().removeDuplicates(healthData);
    } catch (e) {
      logger.e('Error loading health data: $e');
      return [];
    }
  }

  Future<List<HealthDataPoint>> getWaterData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.WATER];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getStepData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.STEPS];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getWeightData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.WEIGHT];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    return Health().removeDuplicates(healthData);
  }

  Future<void> writeHealthData(HealthDataType type, double value, HealthDataUnit unit,
      DateTime startTime, DateTime endTime) async {
    try {
      await Health().writeHealthData(
        unit: unit,
        value: value,
        type: type,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }

  Future<HealthConnectSdkStatus> getHealthConnectSdkStatus() async {
    try {
      final hcStatus = await Health().getHealthConnectSdkStatus();
      logger.i('Health Connect SDK Status: $hcStatus');
      status.value = hcStatus!; // Use null assertion operator to ensure non-null value
      return hcStatus; // Add this return statement
    } catch (e) {
      logger.e('Error getting Health Connect SDK status: $e');
      return HealthConnectSdkStatus.sdkUnavailable; // Return a default value on error
    }
  }

  Future<void> saveWeightToHealth(double weight) async {
    try {
      final now = DateTime.now();
      // Save the weight data point to Health
      await Health().writeHealthData(
          unit: HealthDataUnit.POUND,
          value: weight,
          type: HealthDataType.WEIGHT,
          startTime: now,
          endTime: now);

      // Optionally return success or handle success notification here
    } catch (e) {
      // Handle error
      logger.e('Error saving weight to Health: $e');
    }
  }

  Future<void> saveWaterToHealth(double water) async {
    try {
      final now = DateTime.now();
      // Save the weight data point to Health
      await Health().writeHealthData(
          value: water,
          type: HealthDataType.WATER,
          startTime: now,
          endTime: now.add(const Duration(minutes: 1)));

      // Optionally return success or handle success notification here
    } catch (e) {
      // Handle error
      logger.e('Error saving water to Health: $e');
    }
  }

  // Method to get weight data by specified time frame
  Future<List<HealthDataPoint>> getWeightDataByTimeFrame(TimeFrame timeFrame) async {
    DateTime now = DateTime.now();
    DateTime startTime;
    DateTime endTime = now;

    switch (timeFrame) {
      case TimeFrame.lastWeek:
        startTime = now.subtract(const Duration(days: 7));
        break;
      case TimeFrame.lastThreeMonths:
        startTime = now.subtract(const Duration(days: 90));
        break;
      case TimeFrame.lastSixMonths:
        startTime = now.subtract(const Duration(days: 180));
        break;
      case TimeFrame.all:
        startTime = DateTime(0); // Start from the epoch for all data
        break;
      default:
        return []; // Ensure a return value for unhandled cases
    }

    // Fetch weight data using the Health() method
    final types = [HealthDataType.WEIGHT];

    logger.i('Fetching weight data from $startTime to $endTime');
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    logger.i('Weight data: $healthData');
    return Health().removeDuplicates(healthData); // Return unique weight data
  }

  Future<void> deleteData(HealthDataType type, DateTime endTime, TimeFrame timeFrame) async {
    // DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    // logger.i('Deleting data for type: $type, startTime: $startTime, endTime: $endTime');

    // await Health().delete(
    //     type: HealthDataType.WEIGHT,
    //     startTime: DateTime(2024, 9, 28, 16),
    //     endTime: DateTime(2024, 9, 28, 23));
    // logger.w('Data deleted');

    final now = DateTime.now();
    final earlier = now.subtract(const Duration(hours: 24));

    final result = await Health().delete(
      type: HealthDataType.WEIGHT,
      startTime: earlier,
      endTime: now,
    );
    logger.i('Data deleted: $result');
  }
}
