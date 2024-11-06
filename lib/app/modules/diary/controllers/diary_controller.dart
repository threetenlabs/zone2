import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  // Weight tracking
  final weightWhole = 70.obs;
  final weightDecimal = 0.obs;
  final healthData = RxList<HealthDataPoint>();
  final isWeightLogged = false.obs; // Track if weight is logged

  // Date tracking
  final diaryDate = DateTime.now().obs;
  final diaryDateLabel = ''.obs; // Observable for date label

  // Water tracking
  final waterIntake = 0.0.obs; // Track total water intake
  final waterGoal = 120.0.obs; // Set water goal
  final isWaterLogged = false.obs; // Track if water is logged
  final customWaterWhole = 1.obs;
  final customWaterDecimal = 0.obs;
  final foodSearchResults = Rxn<FoodSearchResponse>();
  final searchPerformed = false.obs;

  // Meal tracking
  final selectedMealType = Rx<MealType>(MealType.BREAKFAST);
  final filteredMealType = Rx<MealType>(MealType.ALL);
  final selectedOpenFoodFactsFood = Rxn<OpenFoodFactsFood>();
  final selectedZone2Food = Rxn<Zone2Food>();
  final selectedPlatformHealthFood = Rxn<HealthDataPoint>();
  final foodServingQty = Rxn<double>();
  final foodServingController = TextEditingController(text: '');

  final allMeals = RxList<HealthDataPoint>();
  final filteredMeals = RxList<HealthDataPoint>();

  // Activity tracking
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

  // Barcode scanning
  final Rxn<Barcode> barcode = Rxn<Barcode>();
  final Rxn<BarcodeCapture> capture = Rxn<BarcodeCapture>();
  late MobileScannerController scannerController;
  StreamSubscription<Object?>? scannerSubscription;

  @override
  void onInit() async {
    super.onInit();
    final now = DateTime.now();
    diaryDate.value = DateTime(now.year, now.month, now.day, 11, 58, 0);

    ever(healthService.isAuthorized, (isAuthorized) => authorizedChanged(isAuthorized));
    ever(diaryDate, (date) => updateDateLabel());
    updateDateLabel();
    await initSpeechState();

    scannerController = MobileScannerController();

    scannerSubscription = scannerController.barcodes.listen(handleBarcode);
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

  Future<void> handleBarcode(BarcodeCapture barcodeCapture) async {
    if (capture.value == barcodeCapture) return;

    capture.value = barcodeCapture;

    barcode.value = barcodeCapture.barcodes.first;
    final foodId = barcodeCapture.barcodes.first.displayValue;
    logger.i('barcode: $foodId');

    await findFoodByBarcode(foodId ?? '');

    barcode.value = null;
    capture.value = null;
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

    allMeals.value = await healthService.getMealData(timeFrame: TimeFrame.today, endTime: endTime);
    filterMealsByType(filteredMealType.value);

    final allActivityData =
        await healthService.getActivityData(timeFrame: TimeFrame.today, endTime: endTime);

    activityManager.value.processActivityData(activityData: allActivityData, userAge: 48);
  }

  Future<void> filterMealsByType(MealType type) async {
    if (type == MealType.ALL) {
      filteredMeals.value = allMeals;
    } else {
      filteredMeals.value = allMeals
          .where((meal) =>
              (meal.value as NutritionHealthValue).zinc ==
              HealthService.to.convertMealthTypeToDouble(type))
          .toList();
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
    searchPerformed.value = false;
    await EasyLoading.show(
      status: 'Searching for food...',
      maskType: EasyLoadingMaskType.black,
    );

    foodSearchResults.value = await foodService.searchFood(query);
    await EasyLoading.dismiss();
    searchPerformed.value = true;
  }

  Future<void> findFoodByBarcode(String barcode) async {
    logger.i('finding food by barcode: $barcode');

    try {
      await EasyLoading.show(status: 'Getting food...', maskType: EasyLoadingMaskType.black);
      final result = await foodService.getFoodById(barcode);
      logger.i('Food: ${result.product?.productName}');

      if (result.product != null) {
        selectedOpenFoodFactsFood.value = OpenFoodFactsFood.fromOpenFoodFacts(result.product!);
        selectedZone2Food.value = Zone2Food.fromOpenFoodFactsFood(selectedOpenFoodFactsFood.value!);
        update();
      }
    } catch (e) {
      logger.e('Error finding food by barcode: $e');
    } finally {
      await EasyLoading.dismiss();
    }
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
