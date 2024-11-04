import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:zone2/app/models/activity_manager.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart'; // Added for date formatting
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/services/openai_service.dart';

class DiaryController extends GetxController {
  final logger = Get.find<Logger>();
  final healthService = Get.find<HealthService>();
  final foodService = Get.find<FoodService>();
  final weightWhole = 70.obs;
  final weightDecimal = 0.obs;
  final healthData = RxList<HealthDataPoint>();
  final isWeightLogged = false.obs; // Track if weight is logged
  final diaryDate = DateTime.now().obs;
  final diaryDateLabel = ''.obs; // Observable for date label
  final waterIntake = 0.0.obs; // Track total water intake
  final waterGoal = 120.0.obs; // Set water goal
  final isWaterLogged = false.obs; // Track if water is logged
  final customWaterWhole = 1.obs;
  final customWaterDecimal = 0.obs;
  final foodSearchResults = Rxn<FoodSearchResponse>();
  final searchPerformed = false.obs;

  final selectedMealType = Rx<MealType>(MealType.BREAKFAST);
  // Holds the selected food from the open food facts search result list
  final selectedOpenFoodFactsFood = Rxn<OpenFoodFactsFood>();
  // Holds the current zone2 food
  final selectedZone2Food = Rxn<Zone2Food>();
  // Holds the selected food from the platform specific health data point
  final selectedPlatformHealthFood = Rxn<HealthDataPoint>();
  // Holds the serving quantity of the selected meal
  final foodServingQty = Rxn<double>();
  final foodServingController = TextEditingController(text: '');

  // Filtered meals with zinc values of 1.0
  final breakfastData = RxList<HealthDataPoint>();
  // Filtered meals with zinc values of 2.0
  final lunchData = RxList<HealthDataPoint>();
  // Filtered meals with zinc values of 3.0
  final dinnerData = RxList<HealthDataPoint>();
  // Filtered meals with zinc values of 4.0
  final snackData = RxList<HealthDataPoint>();

  final activityManager = HealthActivityManager().obs;

  // AI Funzies
  final isProcessing = false.obs;
  final matchedFoods = RxList<String>();
  final speech = SpeechToText();
  final isAvailable = false.obs;
  final isListening = false.obs;
  final currentLocaleId = ''.obs;
  final locales = <LocaleName>[].obs;
  final hasError = false.obs;
  final lastError = Rxn<SpeechRecognitionError>();
  final recognizedWords = ''.obs;
  final systemLocale = Rxn<LocaleName>();

  @override
  void onInit() async {
    super.onInit();
    final now = DateTime.now();
    diaryDate.value = DateTime(now.year, now.month, now.day, 11, 58, 0);

    ever(healthService.isAuthorized, (isAuthorized) => authorizedChanged(isAuthorized));
    ever(diaryDate, (date) => updateDateLabel());
    updateDateLabel();
    await initSpeechState();
  }

  Future<void> initSpeechState() async {
    try {
      isAvailable.value = await speech.initialize(
        onError: (error) => _onSpeechError(error),
        onStatus: (status) => _onSpeechStatus(status),
      );

      if (isAvailable.value) {
        locales.value = await speech.locales();
        systemLocale.value = await speech.systemLocale();
        currentLocaleId.value = systemLocale.value?.localeId ?? '';
      }
    } catch (e) {
      logger.e('Error initializing speech: $e');
      isAvailable.value = false;
    }
  }

  Future<void> startListening() async {
    if (!isAvailable.value || isListening.value) return;

    try {
      isListening.value = await speech.listen(
        onResult: _onSpeechResult,
        listenOptions: SpeechListenOptions(partialResults: true),
        localeId: currentLocaleId.value,
      );
    } catch (e) {
      logger.e('Error starting speech recognition: $e');
      isListening.value = false;
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;

    try {
      await speech.stop();
      isListening.value = false;
      extractFoodItemsOpenAI(recognizedWords.value);
    } catch (e) {
      logger.e('Error stopping speech recognition: $e');
    }
  }

  Future<void> cancelListening() async {
    if (!isListening.value) return;

    try {
      await speech.cancel();
      isListening.value = false;
    } catch (e) {
      logger.e('Error canceling speech recognition: $e');
    }
  }

  void switchLanguage(String newLocaleId) {
    currentLocaleId.value = newLocaleId;
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedWords.value = result.recognizedWords;
  }

  void _onSpeechError(SpeechRecognitionError error) {
    hasError.value = true;
    lastError.value = error;
    logger.e('Speech recognition error: ${error.errorMsg}');
  }

  void _onSpeechStatus(String status) {
    logger.i('Speech recognition status: $status');
    if (status == 'done') {
      isListening.value = false;
      extractFoodItemsOpenAI(recognizedWords.value);
    }
  }

  Future<void> authorizedChanged(dynamic isAuthorized) async {
    try {
      if (!isAuthorized) {
        logger.e('Health Connect Authorization not granted');
        return;
      }

      // await healthService.deleteData(HealthDataType.WEIGHT, diaryDate.value, TimeFrame.today);

      await getHealthDataForSelectedDay();
      // logger.i('Health data: $healthData');
    } catch (e) {
      logger.e('Error loading health data: $e');
    }
  }

  Future<void> getHealthDataForSelectedDay() async {
    // Retrieve weight data
    final sameDay = diaryDate.value.year == DateTime.now().year &&
        diaryDate.value.month == DateTime.now().month &&
        diaryDate.value.day == DateTime.now().day;
    final endTime = sameDay
        ? null
        : DateTime(diaryDate.value.year, diaryDate.value.month, diaryDate.value.day, 23, 59, 49);
    final weightData =
        await healthService.getWeightData(timeFrame: TimeFrame.today, endTime: endTime);
    weightData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

    if (weightData.isNotEmpty) {
      // logger.i('Weight data: ${weightData.first}');
      final weight = weightData.first.value as NumericHealthValue;
      final weightInKilograms = weight.numericValue.toDouble();
      final weightInPounds =
          await healthService.convertWeightUnit(weightInKilograms, WeightUnit.pound);

      weightWhole.value = weightInPounds.toInt(); // Ensure weightWhole is an int
      weightDecimal.value =
          ((weightInPounds - weightWhole.value) * 10).round(); // Update to single digit
      isWeightLogged.value = true;
    } else {
      logger.w('No weight data found');
      isWeightLogged.value = false;
    }

    // Retrieve water data
    final waterData =
        await healthService.getWaterData(timeFrame: TimeFrame.today, endTime: endTime);
    // Process water data as needed
    if (waterData.isNotEmpty) {
      // Example: Sum total water intake from the retrieved data
      double waterIntakeInLiters = waterData.fold(
          0, (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toDouble());
      double waterIntakeInOunces =
          await healthService.convertWaterUnit(waterIntakeInLiters, WaterUnit.ounce);
      waterIntake.value = waterIntakeInOunces; // Update the water intake observable
      // logger.i('Total water intake: $waterIntake oz');
      isWaterLogged.value = waterIntake.value > waterGoal.value;
      logger.i('Water logged: $isWaterLogged.value');
    } else {
      logger.w('No water data found');
      isWaterLogged.value = false;
    }

    final allMeals = await healthService.getMealData(timeFrame: TimeFrame.today, endTime: endTime);
    breakfastData.value =
        allMeals.where((meal) => (meal.value as NutritionHealthValue).zinc == 1.0).toList();
    lunchData.value =
        allMeals.where((meal) => (meal.value as NutritionHealthValue).zinc == 2.0).toList();
    dinnerData.value =
        allMeals.where((meal) => (meal.value as NutritionHealthValue).zinc == 3.0).toList();
    snackData.value =
        allMeals.where((meal) => (meal.value as NutritionHealthValue).zinc == 4.0).toList();
    // if (breakfastData.isNotEmpty) {
    //   logger.i('Meal data: ${breakfastData.first}');
    // } else {
    //   logger.w('No meal data found');
    // }

    final allActivityData =
        await healthService.getActivityData(timeFrame: TimeFrame.today, endTime: endTime);

    activityManager.value.processActivityData(activityData: allActivityData, userAge: 48);
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

  Future<void> saveMealToHealth() async {
    try {
      final servingQty = double.tryParse(foodServingController.text) ?? 0.0;
      selectedZone2Food.value!.servingQuantity = servingQty;
      final success =
          await healthService.saveMealToHealth(selectedMealType.value, selectedZone2Food.value!);
      if (success) {
        // Send success notification
        NotificationService.to
            .showSuccess('Meal Saved', 'Your meal has been successfully saved to health data.');
        await getHealthDataForSelectedDay();
      } else {
        NotificationService.to
            .showError('Meal Not Saved', 'Your meal was not saved to health data.');
      }
      foodServingController.text = '';
    } catch (e) {
      logger.e('Error saving meal to Health: $e');
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  void updateDateLabel() {
    if (isToday(diaryDate.value)) {
      diaryDateLabel.value = 'Today';
    } else if (isYesterday(diaryDate.value)) {
      diaryDateLabel.value = 'Yesterday';
    } else {
      String dateLabel = DateFormat('MM/dd/yyyy').format(diaryDate.value);
      diaryDateLabel.value = dateLabel;
    }
  }

  Future<void> resetTracking() async {
    isWeightLogged.value = false;
    isWaterLogged.value = false;
  }

  Future<void> navigateToNextDay() async {
    if (!isToday(diaryDate.value) && diaryDate.value.isBefore(DateTime.now())) {
      diaryDate.value = diaryDate.value.add(const Duration(days: 1));
      await resetTracking();
    }
    await getHealthDataForSelectedDay();
  }

  Future<void> navigateToPreviousDay() async {
    diaryDate.value = diaryDate.value.subtract(const Duration(days: 1));
    await resetTracking();
    await getHealthDataForSelectedDay();
  }

  Future<void> addWater(double ounces) async {
    double waterIntakeInOunces = ounces;
    double waterIntakeInLiters =
        await healthService.convertWaterUnit(waterIntakeInOunces, WaterUnit.liter);
    try {
      // Call the HealthService to save the weight
      await healthService.saveWaterToHealth(waterIntakeInLiters);

      // Send success notification
      NotificationService.to.showSuccess(
          'Water Saved', 'Your water intake has been successfully saved to health data.');

      await getHealthDataForSelectedDay();
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }

  Future<void> searchFood(String query) async {
    searchPerformed.value = true;
    foodSearchResults.value = await foodService.searchFood(query);
  }

  Future<void> deleteFood() async {
    await healthService.deleteData(HealthDataType.NUTRITION, selectedZone2Food.value!.startTime!,
        selectedZone2Food.value!.endTime!);
    await getHealthDataForSelectedDay();
  }

  Future<void> extractFoodItemsOpenAI(String text) async {
    final result = await OpenAIService.to.extractFoodsFromText(text);
    matchedFoods.value = result.choices.first.message.content
            ?.map((item) => item.text)
            .whereType<String>()
            .toList() ??
        [];
    logger.i('Extracted food items: $result');
  }
}
