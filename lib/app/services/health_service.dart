import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/notification_service.dart';

enum WeightUnit { kilogram, pound }

enum WaterUnit { ounce, liter }

enum TimeFrame {
  today,
  thisWeek,
  thisMonth,
  lastSixMonths,
  thisYear,
}

class HealthService extends GetxService {
  final logger = Get.find<Logger>();
  final isAuthorized = false.obs;
  final status = HealthConnectSdkStatus.sdkUnavailable.obs;
  final health = Rxn<Health>();

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
      convertedWater = water * 33.814;
    } else if (toUnit == WaterUnit.liter) {
      convertedWater = water / 33.814;
    } else {
      throw Exception('Unsupported water unit conversion');
    }
    return convertedWater; // Ensure a return statement is present
  }

  Future<DateTime> getStartTimeForTimeFrame(
      [DateTime? endTime, TimeFrame timeFrame = TimeFrame.today]) async {
    endTime ??= DateTime.now(); // Use now if endTime is not specified
    DateTime startTime;

    switch (timeFrame) {
      case TimeFrame.today:
        startTime = DateTime(endTime.year, endTime.month, endTime.day); // Midnight of today
        break;
      case TimeFrame.thisWeek:
        startTime =
            endTime.subtract(Duration(days: endTime.weekday - 1)); // Monday of the current week
        break;
      case TimeFrame.thisMonth:
        startTime = DateTime(endTime.year, endTime.month, 1); // 1st of the current month
        break;
      case TimeFrame.lastSixMonths:
        startTime = endTime.isBefore(DateTime(endTime.year, endTime.month - 6, endTime.day))
            ? DateTime(endTime.year, endTime.month - 6, endTime.day)
            : DateTime(endTime.year, endTime.month - 6, 1); // Adjust based on the current date
        break;
      case TimeFrame.thisYear:
        startTime = DateTime(endTime.year, 1, 1); // Start of the current year
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
    health.value = Health();
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

    final status = await health.value!.getHealthConnectSdkStatus();
    logger.i('Health Connect SDK Status: $status');
    logger.i('Types count: ${types.length}');
    logger.i('Permissions count: ${permissions.length}');

    final hasPermissions = await health.value!.hasPermissions(types, permissions: permissions);

    bool authorized = false;
    if (hasPermissions != null && !hasPermissions) {
      try {
        authorized = await health.value!.requestAuthorization(types, permissions: permissions);
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
      final healthData = await health.value!
          .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);

      return health.value!.removeDuplicates(healthData);
    } catch (e) {
      logger.e('Error loading health data: $e');
      return [];
    }
  }

  Future<List<HealthDataPoint>> getWaterData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.WATER];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    logger.i('Start Time: ${startTime.toString()}');
    final healthData = await health.value!
        .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    logger.i('Water Health data: $healthData');
    return health.value!.removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getStepData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.STEPS];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    final healthData = await health.value!
        .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    return health.value!.removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getWeightData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.WEIGHT];
    DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);
    final healthData = await health.value!
        .getHealthDataFromTypes(types: types, startTime: startTime, endTime: endTime);
    return health.value!.removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getMealData(
      {required DateTime endTime, required TimeFrame timeFrame}) async {
    final types = [HealthDataType.NUTRITION];
    // DateTime startTime = await getStartTimeForTimeFrame(endTime, timeFrame);

    final now = DateTime.now().add(const Duration(minutes: 10));
    final earlier = DateTime.now().subtract(const Duration(minutes: 30));

    final healthData =
        await health.value!.getHealthDataFromTypes(types: types, startTime: earlier, endTime: now);
    return health.value!.removeDuplicates(healthData);
  }

  Future<void> writeHealthData(HealthDataType type, double value, HealthDataUnit unit,
      DateTime startTime, DateTime endTime) async {
    try {
      await health.value!.writeHealthData(
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
      final hcStatus = await health.value!.getHealthConnectSdkStatus();
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
      final earlier = now.subtract(const Duration(minutes: 1));
      // Save the weight data point to Health
      await health.value!.writeHealthData(
          unit: HealthDataUnit.KILOGRAM,
          value: weight,
          type: HealthDataType.WEIGHT,
          recordingMethod: RecordingMethod.manual,
          startTime: earlier,
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
      final earlier = now.subtract(const Duration(minutes: 1));
      // Save the weight data point to Health
      await health.value!.writeHealthData(
          value: water,
          type: HealthDataType.WATER,
          recordingMethod: RecordingMethod.manual,
          startTime: earlier,
          endTime: now);

      // Optionally return success or handle success notification here
    } catch (e) {
      // Handle error
      logger.e('Error saving water to Health: $e');
    }
  }

  Future<bool> saveMealToHealth(MealType mealtype, PlatformHealthMeal meal, double qty) async {
    final now = DateTime.now();
    final earlier = DateTime.now().subtract(const Duration(minutes: 1));

    try {
      final result = await health.value!.writeMeal(
          mealType: mealtype,
          startTime: earlier,
          endTime: now,
          caloriesConsumed: meal.totalCaloriesValue * qty,
          carbohydrates: meal.totalCarbsValue * qty,
          protein: meal.proteinValue * qty,
          fatTotal: meal.totalFatValue * qty,
          name: meal.name,
          sodium: meal.sodiumValue * qty,
          cholesterol: meal.cholesterolValue * qty,
          fiber: meal.fiberValue * qty,
          fatUnsaturated: (meal.totalFatValue - meal.saturatedValue) * qty,
          fatSaturated: meal.saturatedValue * qty,
          sugar: meal.sugarValue * qty,
          recordingMethod: RecordingMethod.manual);
      return result;
    } catch (e) {
      logger.e('Error saving meal to Health: $e');
      return false;
    }
  }

  Future<void> deleteData(HealthDataType type, DateTime startTime, DateTime endTime) async {
    final result = await health.value!.delete(
      type: HealthDataType.NUTRITION,
      startTime: startTime,
      endTime: endTime,
    );

    if (result) {
      logger.i('Data deleted: $result');
      NotificationService.to.showSuccess('Data Deleted', 'Data has been successfully deleted.');
    } else {
      logger.e('Error deleting data: $result');
      NotificationService.to.showError('Error Deleting Data', 'Data has not been deleted.');
    }
  }
}
