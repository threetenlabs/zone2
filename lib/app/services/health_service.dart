import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/modules/track/timeframe.dart';

class HealthService extends GetxService {
  final logger = Get.find<Logger>();
  final isAuthorized = false.obs;
  final status = HealthConnectSdkStatus.sdkUnavailable.obs;

  // Mapping of HealthDataType to permissions
  final Map<HealthDataType, List<HealthDataAccess>> _permissionsMap = {
    HealthDataType.HEART_RATE: [HealthDataAccess.READ],
    HealthDataType.ACTIVE_ENERGY_BURNED: [HealthDataAccess.READ],
    HealthDataType.BLOOD_GLUCOSE: [HealthDataAccess.READ],
    HealthDataType.WEIGHT: [HealthDataAccess.READ, HealthDataAccess.WRITE],
    HealthDataType.STEPS: [HealthDataAccess.READ],
    HealthDataType.HEIGHT: [HealthDataAccess.READ, HealthDataAccess.WRITE],
    HealthDataType.BODY_TEMPERATURE: [HealthDataAccess.READ],
    HealthDataType.SLEEP_AWAKE: [HealthDataAccess.READ],
    HealthDataType.SLEEP_ASLEEP: [HealthDataAccess.READ],
    // Add more mappings as needed
  };

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
    // HealthDataType.BODY_MASS_INDEX,
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

  @override
  Future<void> onInit() async {
    super.onInit();
    isAuthorized.value = await authorize();
  }

  Future<bool> authorize() async {
    List<HealthDataType> types = GetPlatform.isIOS ? dataTypesIOS : dataTypesAndroid;
    List<HealthDataAccess> permissions = [];

    // Determine permissions based on requested data types
    for (var type in types) {
      if (_permissionsMap.containsKey(type)) {
        permissions.addAll(_permissionsMap[type]!); // Add the corresponding permissions
      }
    }

    const hasPermissions = false; // Replace with actual permission check

    bool authorized = false;
    if (!hasPermissions) {
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
      {required DateTime startTime, required DateTime endTime}) async {
    final types = GetPlatform.isIOS ? dataTypesIOS : dataTypesAndroid;
    try {
      final healthData = await Health()
          .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
      return Health().removeDuplicates(healthData);
    } catch (e) {
      logger.e('Error loading health data: $e');
      return [];
    }
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
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    logger.i('Weight data: $healthData');
    return Health().removeDuplicates(healthData); // Return unique weight data
  }
}
