import 'package:health/health.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'dart:math' as math;

enum WeightUnit { kilogram, pound }

enum WaterUnit { ounce, liter }

enum TimeFrame {
  day,
  week,
  month,
  sixMonths,
  year,
}

class TimeFrameResult {
  final DateTime startDateTime;
  final DateTime endDateTime;

  TimeFrameResult({required this.startDateTime, required this.endDateTime});
}

class HealthService extends GetxService {
  static HealthService to = Get.find();
  final logger = Get.find<Logger>();
  final isAuthorized = false.obs;
  final status = HealthConnectSdkStatus.sdkUnavailable.obs;
  final hasPermissions = RxnBool(false);
  final memoryCache = MemoryCache();

  @override
  Future<void> onInit() async {
    super.onInit();
    await Health().configure();
    await Health().getHealthConnectSdkStatus();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  /// List of data types that require write permissions
  final List<HealthDataType> _writePermissionTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.WATER,
    HealthDataType.NUTRITION,
  ];

  /// List of data types we need to request permissions for to support Zone2.
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

  /// Convert a MealType to a double value
  /// Breakfast = 1.0, Lunch = 2.0, Dinner = 3.0, Snack = 4.0
  double convertMealthTypeToDouble(MealType type) {
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
        logger.e('Unsupported meal type: $type');
        return 1.0;
    }
  }

  /// Convert a double value to a MealType
  /// Breakfast = 1.0, Lunch = 2.0, Dinner = 3.0, Snack = 4.0
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
        logger.e('Unsupported meal type: $value');
        return MealType.BREAKFAST;
    }
  }

  /// Convert a weight value to a different unit
  /// Pound = 2.20462, Kilogram = 1/2.20462
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

  /// Convert a water value to a different unit
  /// Ounce = 33.814, Liter = 1/33.814
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

  /// Get the date range for a given time frame
  /// Day = Today, Week = Last Monday, Month = First of the current month, SixMonths = First of the month six months ago, Year = First of the year
  Future<TimeFrameResult> getDateRangeForTimeFrame(
      {required DateTime seedDate, TimeFrame timeFrame = TimeFrame.day}) async {
    final sameDay = seedDate.year == DateTime.now().year &&
        seedDate.month == DateTime.now().month &&
        seedDate.day == DateTime.now().day;
    final endTime = sameDay && timeFrame == TimeFrame.day
        ? DateTime.now().add(const Duration(minutes: 5)) // Use seedDate instead of endTime
        : DateTime(seedDate.year, seedDate.month, seedDate.day, 23, 59, 49);

    DateTime startTime;

    switch (timeFrame) {
      case TimeFrame.day:
        startTime =
            DateTime(seedDate.year, seedDate.month, seedDate.day, 0, 1, 0); // Midnight of today
        break;
      case TimeFrame.week:
        final lastweek =
            seedDate.subtract(Duration(days: seedDate.weekday - 1)); // Monday of the current week
        startTime = DateTime(lastweek.year, lastweek.month, lastweek.day, 0, 1, 0);
        break;
      case TimeFrame.month:
        startTime = DateTime(seedDate.year, seedDate.month, 1, 0, 1, 0); // 1st of the current month
        break;
      case TimeFrame.sixMonths:
        startTime = seedDate.isBefore(DateTime(seedDate.year, seedDate.month - 6, seedDate.day))
            ? DateTime(seedDate.year, seedDate.month - 6, seedDate.day, 0, 1, 0)
            : DateTime(
                seedDate.year, seedDate.month - 6, 1, 0, 1, 0); // Adjust based on the current date
        break;
      case TimeFrame.year:
        startTime = DateTime(seedDate.year, 1, 1, 0, 1, 0); // Start of the current year
        break;
      default:
        return TimeFrameResult(
            startDateTime: DateTime.now(),
            endDateTime: DateTime.now()); // Return current time for unhandled cases
    }
    return TimeFrameResult(startDateTime: startTime, endDateTime: endTime);
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
    if (hasPermissions.value == null || !hasPermissions.value!) {
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
      {required TimeFrame timeFrame, required DateTime seedDate, bool? forceRefresh}) async {
    final types = [HealthDataType.WATER];
    final key =
        'water_${DateTime(seedDate.year, seedDate.month, seedDate.day).toIso8601String()}_${timeFrame.name}';
    TimeFrameResult result =
        await getDateRangeForTimeFrame(seedDate: seedDate, timeFrame: timeFrame);

    // Check for cached data
    final cachedData = memoryCache.read<List<HealthDataPoint>>(key);
    if (cachedData != null && !forceRefresh!) {
      return cachedData; // Return cached data if available
    }

    final healthData = await Health().getHealthDataFromTypes(
        types: types, startTime: result.startDateTime, endTime: result.endDateTime);

    // Store fetched data in cache
    memoryCache.create(key, healthData, expiry: const Duration(minutes: 10));
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getStepData(
      {required TimeFrame timeFrame, required DateTime seedDate, bool? forceRefresh}) async {
    final types = [HealthDataType.STEPS];
    final key =
        'steps_${DateTime(seedDate.year, seedDate.month, seedDate.day).toIso8601String()}_${timeFrame.name}';
    TimeFrameResult result =
        await getDateRangeForTimeFrame(seedDate: seedDate, timeFrame: timeFrame);

    // Check for cached data
    final cachedData = memoryCache.read<List<HealthDataPoint>>(key);
    if (cachedData != null && !forceRefresh!) {
      return cachedData; // Return cached data if available
    }

    final healthData = await Health().getHealthDataFromTypes(
        types: types, startTime: result.startDateTime, endTime: result.endDateTime);

    // Store fetched data in cache
    memoryCache.create(key, healthData, expiry: const Duration(minutes: 10));
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getWeightData(
      {required TimeFrame timeFrame, required DateTime seedDate, bool? forceRefresh}) async {
    final types = [HealthDataType.WEIGHT];
    final key =
        'weight_${DateTime(seedDate.year, seedDate.month, seedDate.day).toIso8601String()}_${timeFrame.name}';
    TimeFrameResult result =
        await getDateRangeForTimeFrame(seedDate: seedDate, timeFrame: timeFrame);

    // Check for cached data
    final cachedData = memoryCache.read<List<HealthDataPoint>>(key);
    if (cachedData != null && !forceRefresh!) {
      return cachedData; // Return cached data if available
    }

    final healthData = await Health().getHealthDataFromTypes(
        types: types, startTime: result.startDateTime, endTime: result.endDateTime);

    // Store fetched data in cache
    memoryCache.create(key, healthData, expiry: const Duration(minutes: 10));
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getMealData(
      {required TimeFrame timeFrame, required DateTime seedDate, bool? forceRefresh}) async {
    final types = [HealthDataType.NUTRITION];
    final key =
        'meal_${DateTime(seedDate.year, seedDate.month, seedDate.day).toIso8601String()}_${timeFrame.name}';
    TimeFrameResult result =
        await getDateRangeForTimeFrame(seedDate: seedDate, timeFrame: timeFrame);

    // Check for cached data
    final cachedData = memoryCache.read<List<HealthDataPoint>>(key);
    if (cachedData != null && !forceRefresh!) {
      return cachedData; // Return cached data if available
    }

    final healthData = await Health().getHealthDataFromTypes(
        types: types, startTime: result.startDateTime, endTime: result.endDateTime);

    // Store fetched data in cache
    memoryCache.create(key, healthData, expiry: const Duration(minutes: 10));
    return Health().removeDuplicates(healthData);
  }

  Future<List<HealthDataPoint>> getActivityData(
      {required TimeFrame timeFrame, required DateTime seedDate, bool? forceRefresh}) async {
    final types = [
      HealthDataType.TOTAL_CALORIES_BURNED,
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
      HealthDataType.STEPS
    ];
    final key =
        'activity_${DateTime(seedDate.year, seedDate.month, seedDate.day).toIso8601String()}_${timeFrame.name}';

    TimeFrameResult result =
        await getDateRangeForTimeFrame(seedDate: seedDate, timeFrame: timeFrame);

    // Check for cached data
    final cachedData = memoryCache.read<List<HealthDataPoint>>(key);
    if (cachedData != null && !forceRefresh!) {
      return cachedData; // Return cached data if available
    }

    final healthData = await Health().getHealthDataFromTypes(
        types: types, startTime: result.startDateTime, endTime: result.endDateTime);

    // Store fetched data in cache
    memoryCache.create(key, healthData, expiry: const Duration(minutes: 10));
    return Health().removeDuplicates(healthData);
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
          sodium: math.min(meal.sodiumValue * qty, 100),
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
