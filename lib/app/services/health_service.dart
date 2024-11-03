import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zone2/app/models/food.dart';
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
  static HealthService to = Get.find();
  final logger = Get.find<Logger>();
  final isAuthorized = false.obs;
  final status = HealthConnectSdkStatus.sdkUnavailable.obs;
  final hasPermissions = RxnBool(false);

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

  final List<HealthDataType> dataTypesZone2 = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.WATER,
    HealthDataType.WORKOUT,
    HealthDataType.NUTRITION,
    HealthDataType.TOTAL_CALORIES_BURNED,
  ];

  double convertDataTypeToDouble(MealType type) {
    switch (type) {
      case MealType.BREAKFAST:
        return 1.0;
      case MealType.LUNCH:
        return 2.0;
      case MealType.DINNER:
        return 3.0;
      case MealType.SNACK:
        return 4.0;
      default:
        return 0.0;
    }
  }

  MealType convertDoubleToMealType(double value) {
    switch (value) {
      case 1.0:
        return MealType.BREAKFAST;
      case 2.0:
        return MealType.LUNCH;
      case 3.0:
        return MealType.DINNER;
      case 4.0:
        return MealType.SNACK;
      default:
        return MealType.UNKNOWN;
    }
  }

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
      {TimeFrame timeFrame = TimeFrame.today, DateTime? endTime}) async {
    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));
    DateTime startTime;

    switch (timeFrame) {
      case TimeFrame.today:
        startTime =
            DateTime(nowPlus.year, nowPlus.month, nowPlus.day, 0, 1, 0); // Midnight of today
        break;
      case TimeFrame.thisWeek:
        final lastweek =
            nowPlus.subtract(Duration(days: nowPlus.weekday - 1)); // Monday of the current week
        startTime = DateTime(lastweek.year, lastweek.month, lastweek.day, 0, 1, 0);

        break;
      case TimeFrame.thisMonth:
        startTime = DateTime(nowPlus.year, nowPlus.month, 1, 0, 1, 0); // 1st of the current month
        break;
      case TimeFrame.lastSixMonths:
        startTime = nowPlus.isBefore(DateTime(nowPlus.year, nowPlus.month - 6, nowPlus.day))
            ? DateTime(nowPlus.year, nowPlus.month - 6, nowPlus.day, 0, 1, 0)
            : DateTime(
                nowPlus.year, nowPlus.month - 6, 1, 0, 1, 0); // Adjust based on the current date
        break;
      case TimeFrame.thisYear:
        startTime = DateTime(nowPlus.year, 1, 1, 0, 1, 0); // Start of the current year
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
  }

  Future<bool> authorize() async {
    List<HealthDataType> types = dataTypesZone2;
    List<HealthDataAccess> permissions = [];

    // Determine permissions based on requested data types
    permissions.addAll(types.map((type) => _writePermissionTypes.contains(type)
        ? HealthDataAccess.READ_WRITE
        : HealthDataAccess.READ));

    await Permission.activityRecognition.request();
    await Permission.location.request();

    final status = await Health().getHealthConnectSdkStatus();
    logger.i('Health Connect SDK Status: $status');

    hasPermissions.value = await Health().hasPermissions(types, permissions: permissions);

    bool authorized = false;
    if (hasPermissions.value != null && !hasPermissions.value!) {
      try {
        authorized = await Health().requestAuthorization(types, permissions: permissions);
        isAuthorized.value = authorized;
        hasPermissions.value = await Health().hasPermissions(types, permissions: permissions);
      } catch (error) {
        logger.e("Exception in authorize: $error");
      }
    }
    return authorized;
  }

  Future<List<HealthDataPoint>> getWaterData(
      {required TimeFrame timeFrame, DateTime? endTime}) async {
    final types = [HealthDataType.WATER];
    DateTime startTime = await getStartTimeForTimeFrame(timeFrame: timeFrame, endTime: endTime);

    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: nowPlus);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getStepData(
      {required TimeFrame timeFrame, DateTime? endTime}) async {
    final types = [HealthDataType.STEPS];
    DateTime startTime = await getStartTimeForTimeFrame(timeFrame: timeFrame, endTime: endTime);
    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: nowPlus);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getWeightData(
      {required TimeFrame timeFrame, DateTime? endTime}) async {
    final types = [HealthDataType.WEIGHT];
    DateTime startTime = await getStartTimeForTimeFrame(timeFrame: timeFrame, endTime: endTime);
    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));
    final healthData =
        await Health().getHealthDataFromTypes(types: types, startTime: startTime, endTime: nowPlus);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getMealData(
      {required TimeFrame timeFrame, DateTime? endTime}) async {
    final types = [HealthDataType.NUTRITION];
    DateTime calculatedStartTime =
        await getStartTimeForTimeFrame(timeFrame: timeFrame, endTime: endTime);

    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));

    final healthData = await Health()
        .getHealthDataFromTypes(types: types, startTime: calculatedStartTime, endTime: nowPlus);
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getActivityData(
      {required TimeFrame timeFrame, DateTime? endTime}) async {
    final types = [
      HealthDataType.TOTAL_CALORIES_BURNED,
      HealthDataType.HEART_RATE,
      // HealthDataType.WORKOUT,
      HealthDataType.STEPS
    ];

    DateTime calculatedStartTime =
        await getStartTimeForTimeFrame(timeFrame: timeFrame, endTime: endTime);

    final nowPlus = endTime ?? DateTime.now().add(const Duration(hours: 1));

    final healthData = await Health()
        .getHealthDataFromTypes(types: types, startTime: calculatedStartTime, endTime: nowPlus);

    return healthData;
  }

  Future<HealthConnectSdkStatus> getHealthConnectSdkStatus() async {
    try {
      final hcStatus = await Health().getHealthConnectSdkStatus();
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
      await Health().writeHealthData(
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
      await Health().writeHealthData(
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

  Future<bool> saveMealToHealth(MealType mealtype, Zone2Food meal) async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 1));
    final qty = meal.servingQuantity;

    try {
      final result = await Health().writeMeal(
          mealType: MealType.BREAKFAST,
          startTime: earlier,
          endTime: now,
          caloriesConsumed: meal.totalCaloriesValue * qty,
          carbohydrates: meal.totalCarbsValue * qty,
          protein: meal.proteinValue * qty,
          fatTotal: meal.totalFatValue * qty,
          name: '${meal.name} | ${meal.brand} | ${qty.toStringAsFixed(1)} | ${meal.servingLabel}',
          sodium: meal.sodiumValue * qty,
          cholesterol: meal.cholesterolValue * qty,
          fiber: meal.fiberValue * qty,
          fatUnsaturated: (meal.totalFatValue - meal.saturatedValue) * qty,
          fatSaturated: meal.saturatedValue * qty,
          sugar: meal.sugarValue * qty,
          zinc: meal.mealTypeValue,
          manganese: qty, // using this to store the serving quantity
          recordingMethod: RecordingMethod.manual);

      return result;
    } catch (e) {
      logger.e('Error saving meal to Health: $e');
      return false;
    }
  }

  Future<void> deleteData(HealthDataType type, DateTime startTime, DateTime endTime) async {
    final result = await Health().delete(
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
