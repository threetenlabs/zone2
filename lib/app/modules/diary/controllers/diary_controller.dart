import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';

import 'package:zone2/app/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart'; // Added for date formatting

class DiaryController extends GetxController {
  final logger = Get.find<Logger>();
  final healthService = Get.find<HealthService>();
  final foodService = Get.find<FoodService>();
  final count = 0.obs;
  final weightWhole = 70.obs;
  final weightDecimal = 0.obs;
  final healthData = RxList<HealthDataPoint>();
  final isWeightLogged = false.obs; // Track if weight is logged
  final diaryDate = tz.TZDateTime.now(tz.local).obs;
  final diaryDateLabel = ''.obs; // Observable for date label
  final waterIntake = 0.0.obs; // Track total water intake
  final waterGoal = 120.0.obs; // Set water goal
  final isWaterLogged = false.obs; // Track if water is logged
  final customWaterWhole = 1.obs;
  final customWaterDecimal = 0.obs;
  final foodSearchResults = Rxn<FoodSearchResponse>();
  @override
  void onInit() async {
    logger.i('DiaryController onInit');
    super.onInit();
    ever(healthService.isAuthorized, (isAuthorized) => authorizedChanged(isAuthorized));
    ever(diaryDate, (date) => updateDateLabel());
    updateDateLabel();
  }

  Future<void> authorizedChanged(dynamic isAuthorized) async {
    try {
      if (!isAuthorized) {
        logger.e('Health Connect Authorization not granted');
        return;
      }

      await healthService.deleteData(HealthDataType.WEIGHT, diaryDate.value, TimeFrame.today);

      await getHealthDataForSelectedDay();
      // logger.i('Health data: $healthData');
    } catch (e) {
      logger.e('Error loading health data: $e');
    }
  }

  Future<void> getHealthDataForSelectedDay() async {
    // Retrieve weight data
    final weightData =
        await healthService.getWeightData(timeFrame: TimeFrame.thisMonth, endTime: diaryDate.value);
    logger.i('Weight data length: ${weightData.length}');
    weightData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

    if (weightData.isNotEmpty) {
      logger.i('Weight data: ${weightData.first}');
      final weight = weightData.first.value as NumericHealthValue;
      final weightInKilograms = weight.numericValue.toDouble();
      final weightInPounds =
          await healthService.convertWeightUnit(weightInKilograms, WeightUnit.pound);

      weightWhole.value = weightInPounds.toInt(); // Ensure weightWhole is an int
      weightDecimal.value =
          ((weightInPounds - weightWhole.value) * 10).round(); // Update to single digit
      isWeightLogged.value = true;
    }

    // Retrieve water data
    final waterData =
        await healthService.getWaterData(timeFrame: TimeFrame.today, endTime: diaryDate.value);
    logger.i('Water data length: ${waterData.length}');

    // Process water data as needed
    if (waterData.isNotEmpty) {
      // Example: Sum total water intake from the retrieved data
      double waterIntakeInLiters = waterData.fold(
          0, (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toDouble());
      double waterIntakeInOunces =
          await healthService.convertWaterUnit(waterIntakeInLiters, WaterUnit.ounce);
      waterIntake.value = waterIntakeInOunces; // Update the water intake observable
      logger.i('Total water intake: $waterIntakeInLiters oz');
      isWaterLogged.value = waterIntake.value > waterGoal.value;
      logger.i('Water logged: $isWaterLogged.value');
    }
  }

  Future<void> saveWeightToHealth() async {
    try {
      final weightInPounds =
          weightWhole.value + (weightDecimal.value / 100); // Combine whole and decimal parts

      final weightInKilograms =
          await healthService.convertWeightUnit(weightInPounds, WeightUnit.kilogram);

      // Call the HealthService to save the weight
      await healthService.saveWeightToHealth(weightInKilograms);

      // Send success notification
      NotificationService.to
          .showSuccess('Weight Saved', 'Your weight has been successfully saved to health data.');

      // Update the weight logged state
      isWeightLogged.value = true;
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }

  bool isToday(tz.TZDateTime date) {
    final now = tz.TZDateTime.now(tz.local);
    logger.i('date: ${date.year} ${date.month} ${date.day}');
    logger.i('now: ${now.year} ${now.month} ${now.day}');
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool isYesterday(tz.TZDateTime date) {
    final yesterday = tz.TZDateTime.now(tz.local).subtract(const Duration(days: 1));
    logger.i('date: ${date.year} ${date.month} ${date.day}');
    logger.i('yesterday: ${yesterday.year} ${yesterday.month} ${yesterday.day}');
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  void updateDateLabel() {
    logger.i('Updating date label: ${diaryDate.value}');
    if (isToday(diaryDate.value)) {
      logger.i('Updating date label to today: ${diaryDate.value}');
      diaryDateLabel.value = 'Today';
    } else if (isYesterday(diaryDate.value)) {
      logger.i('Updating date label to yesterday: ${diaryDate.value}');
      diaryDateLabel.value = 'Yesterday';
    } else {
      logger.i('Updating date label to full date: ${diaryDate.value}');
      String dateLabel =
          DateFormat('MM/dd/yyyy').format(diaryDate.value); // Show full date for other days
      diaryDateLabel.value = dateLabel;
    }
  }

  void navigateToNextDay() {
    if (!isToday(diaryDate.value) && diaryDate.value.isBefore(DateTime.now())) {
      diaryDate.value = diaryDate.value.add(const Duration(days: 1));
    }
  }

  void navigateToPreviousDay() {
    diaryDate.value = diaryDate.value.subtract(const Duration(days: 1));
  }

  Future<void> addWater(double ounces) async {
    double waterIntakeInOunces = ounces;
    double waterIntakeInLiters =
        await healthService.convertWaterUnit(waterIntakeInOunces, WaterUnit.liter);
    logger.i('Added $ounces oz of water. Total water intake: ${waterIntake.value} oz');

    try {
      // Call the HealthService to save the weight
      await healthService.saveWaterToHealth(waterIntakeInLiters);

      // Send success notification
      NotificationService.to
          .showSuccess('Weight Saved', 'Your weight has been successfully saved to health data.');
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }

  Future<void> searchFood(String query) async {
    foodSearchResults.value = await foodService.searchFood(query);
  }
}
