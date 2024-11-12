import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/modules/diary/controllers/activity_manager.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/food_manager.dart';
import 'package:zone2/app/modules/loading_service.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart'; // Added for date formatting
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/services/openai_service.dart';

class FoodVoiceResult {
  final String label;
  final String searchTerm;
  final double quantity;
  final String unit;
  final MealType mealType;

  FoodVoiceResult({
    required this.label,
    required this.searchTerm,
    required this.quantity,
    required this.unit,
    required this.mealType,
  });

  // Factory method to create a FoodVoiceResult from JSON
  factory FoodVoiceResult.fromJson(Map<String, dynamic> json) {
    return FoodVoiceResult(
      label: json['label'],
      searchTerm: json['searchTerm'],
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      mealType: _parseMealType(json['mealType']),
    );
  }

  // Factory method to create a list of FoodVoiceResult from OpenAI completion
  static List<FoodVoiceResult> fromOpenAiCompletion(List<dynamic> items) {
    return items.map((item) {
      // Handle nulls for food items
      final food = item;
      return FoodVoiceResult(
        label: food?['label'] as String? ?? 'Unknown Food', // Default value for label
        searchTerm: (food?['searchTerm'] as String?) ?? '', // Default to empty string
        quantity: (food?['quantity'] is int)
            ? (food?['quantity'] as int).toDouble()
            : (food?['quantity'] as double? ?? 0.0), // Default to 0.0
        unit: (food?['unit'] as String?) ?? 'units', // Default unit
        mealType: _parseMealType((food?['mealType'] as String?) ?? 'UNKNOWN'), // Default to UNKNOWN
      );
    }).toList();
  }

  // Helper method to parse meal type from string
  static MealType _parseMealType(String type) {
    switch (type.toUpperCase()) {
      case 'BREAKFAST':
        return MealType.BREAKFAST;
      case 'LUNCH':
        return MealType.LUNCH;
      case 'DINNER':
        return MealType.DINNER;
      case 'SNACK':
        return MealType.SNACK;
      default:
        return MealType.UNKNOWN;
    }
  }
}

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
  final foodManager = FoodManager().obs;
  final selectedMealType = Rx<MealType>(MealType.BREAKFAST);
  final selectedOpenFoodFactsFood = Rxn<OpenFoodFactsFood>();
  final selectedZone2Food = Rxn<Zone2Food>();
  final foodServingQty = Rxn<double>();
  final foodServingController = TextEditingController(text: '');

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
  final isTestMode = false.obs; // Toggle this for testing

  final voiceResults = RxList<FoodVoiceResult>();
  final zone2User = Rxn<Zone2User>();
  String selectedVoiceFood = '';
  RxList<FoodVoiceResult> searchResults = RxList<FoodVoiceResult>();

  // Barcode scanning
  final Rxn<Barcode> barcode = Rxn<Barcode>();
  final Rxn<BarcodeCapture> capture = Rxn<BarcodeCapture>();
  late MobileScannerController scannerController;
  StreamSubscription<Object?>? scannerSubscription;

  ChartSeriesController? chartController;

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
    await HealthService.to.authorize();
    await getHealthDataForSelectedDay(true);
  }

  @override
  void onReady() async {
    super.onReady();
    AuthService.to.zone2User.stream.listen((user) async {
      logger.i('zone2User: $user');
      zone2User.value = user;
      // if (user != null) {
      //   await checkHealthPermissions();
      // }
    });
  }

  Future<void> checkHealthPermissions() async {
    if (!HealthService.to.hasPermissions.value) {
      await getHealthDataForSelectedDay(true);
    }
  }

  Future<void> initSpeechState() async {
    try {
      isAvailable.value = await speech.initialize(
        onError: (error) => _onSpeechError(error),
        onStatus: (status) => _onSpeechStatus(status),
        finalTimeout: const Duration(milliseconds: 5000),
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
      await speech.listen(
        onResult: _onSpeechResult,
        listenOptions: SpeechListenOptions(partialResults: true),
        localeId: currentLocaleId.value,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 5),
      );
      isListening.value = true;
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

      await getHealthDataForSelectedDay(true);
      // logger.i('Health data: $healthData');
    } catch (e) {
      logger.e('Error loading health data: $e');
    }
  }

  Future<void> getHealthDataForSelectedDay(bool forceRefresh) async {
    try {
      await BusyIndicatorService.to.showBusyIndicator('Retrieving health data...');
      await Future.wait([
        _retrieveWeightData(),
        _retrieveWaterData(),
        _retrieveMealData(),
        _retrieveActivityData(),
      ]);
    } catch (e) {
      logger.e('Error getting health data: $e');
      FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
    } finally {
      BusyIndicatorService.to.hideBusyIndicator();
    }
  }

  Future<void> _retrieveWeightData({bool? forceRefresh = false}) async {
    final weightData = await healthService.getWeightData(
        timeFrame: TimeFrame.day, seedDate: diaryDate.value, forceRefresh: forceRefresh);
    weightData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

    if (weightData.isNotEmpty) {
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
  }

  Future<void> _retrieveWaterData({bool? forceRefresh = false}) async {
    final waterData = await healthService.getWaterData(
        timeFrame: TimeFrame.day, seedDate: diaryDate.value, forceRefresh: forceRefresh);

    if (waterData.isNotEmpty) {
      double waterIntakeInLiters = waterData.fold(
          0, (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toDouble());
      double waterIntakeInOunces =
          await healthService.convertWaterUnit(waterIntakeInLiters, WaterUnit.ounce);
      waterIntake.value = waterIntakeInOunces; // Update the water intake observable
      isWaterLogged.value = waterIntake.value > 0;

      logger.i('Water logged: $isWaterLogged.value');
    } else {
      logger.w('No water data found');
      isWaterLogged.value = false;
    }
  }

  Future<void> _retrieveMealData({bool? forceRefresh = false}) async {
    final foodDataPoints = await healthService.getMealData(
        timeFrame: TimeFrame.day, seedDate: diaryDate.value, forceRefresh: forceRefresh);
    foodManager.value.processFoodData(foodDataPoints);
  }

  Future<void> _retrieveActivityData({bool? forceRefresh = false}) async {
    final allActivityData = await healthService.getActivityData(
        timeFrame: TimeFrame.day, seedDate: diaryDate.value, forceRefresh: forceRefresh);
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
      final mealType = HealthService.to.convertMealthTypeToDouble(selectedMealType.value);
      selectedZone2Food.value!.servingQuantity = servingQty;
      selectedZone2Food.value!.mealTypeValue = mealType;

      final success =
          await healthService.saveMealToHealth(selectedMealType.value, selectedZone2Food.value!);
      if (success) {
        // Send success notification
        NotificationService.to
            .showSuccess('Meal Saved', 'Your meal has been successfully saved to health data.');
        await _retrieveMealData(forceRefresh: true);
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
    await getHealthDataForSelectedDay(false);
  }

  Future<void> navigateToPreviousDay() async {
    diaryDate.value = diaryDate.value.subtract(const Duration(days: 1));
    await resetTracking();
    await getHealthDataForSelectedDay(false);
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

      await _retrieveWaterData(forceRefresh: true);
    } catch (e) {
      logger.e('Error saving weight to Health: $e');
    }
  }

  Future<void> searchFood(String query) async {
    searchPerformed.value = false;
    await BusyIndicatorService.to.showBusyIndicator(
      'Searching for food...',
    );

    foodSearchResults.value = await foodService.searchFood(query);
    BusyIndicatorService.to.hideBusyIndicator();
    searchPerformed.value = true;
  }

  Future<void> findFoodByBarcode(String barcode) async {
    logger.i('finding food by barcode: $barcode');

    try {
      await BusyIndicatorService.to.showBusyIndicator('Getting food...');
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
      BusyIndicatorService.to.hideBusyIndicator();
    }
  }

  Future<void> deleteFood() async {
    await healthService.deleteData(HealthDataType.NUTRITION, selectedZone2Food.value!.startTime!,
        selectedZone2Food.value!.endTime!);
    await _retrieveMealData(forceRefresh: true);
  }

  Future<void> extractFoodItemsOpenAI(String text) async {
    try {
      isProcessing.value = true;

      if (isTestMode.value) {
        await Future.delayed(const Duration(seconds: 1));
        voiceResults.value = [
          FoodVoiceResult(
            label: "2 scrambled eggs with spinach",
            searchTerm: "eggs",
            quantity: 2,
            unit: "large",
            mealType: MealType.BREAKFAST,
          ),
          FoodVoiceResult(
            label: "1 slice whole grain toast with avocado",
            searchTerm: "whole grain bread",
            quantity: 1,
            unit: "slice",
            mealType: MealType.BREAKFAST,
          ),
          // ... other test items
        ];
        matchedFoods.value = voiceResults.map((r) => r.label).toList();
      } else {
        final openAIChatCompletion = await OpenAIService.to.extractFoodsFromText(text);
        final newItems = FoodVoiceResult.fromOpenAiCompletion(
            openAIChatCompletion['foods']['items'] as List<dynamic>);
        voiceResults.value = newItems;

        matchedFoods.value = voiceResults.map((r) => r.label).toList();
      }
    } catch (e) {
      logger.e('Error extracting foods: $e');
      NotificationService.to
          .showError('Error', 'Failed to process speech input. Please try again.');
      voiceResults.clear();
      matchedFoods.clear();
    } finally {
      isProcessing.value = false;
    }
  }

  void selectFoodFromVoice(String foodDescription) async {
    try {
      // Store the selected food description
      selectedVoiceFood = foodDescription;

      // Reset search results before new search
      foodSearchResults.value = null;

      await BusyIndicatorService.to.showBusyIndicator('Searching for food...');

      // Perform the search
      final results = await foodService.searchFood(foodDescription);
      foodSearchResults.value = results;

      if (results.foods.isNotEmpty) {
        // Navigate to search results view
        Get.snackbar('Got results', 'Found ${results.foods.length} results');
      } else {
        Get.snackbar(
          'No Results',
          'No foods found matching "$foodDescription"',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to search for food: ${error.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      BusyIndicatorService.to.hideBusyIndicator();
    }
  }

  void viewFoodFromSearch(OpenFoodFactsFood openFoodFactsFood) {
    selectedOpenFoodFactsFood.value = openFoodFactsFood;
    selectedZone2Food.value = Zone2Food.fromOpenFoodFactsFood(openFoodFactsFood);
    foodServingController.text = '';
    if (selectedZone2Food.value!.totalCaloriesValue <= 0) {
      NotificationService.to.showWarning(
          'No Calories', 'This food has no calories and cannot be added to your meal.');
    }
  }
}
