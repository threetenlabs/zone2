import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';

/// Class to manage and process food data
class FoodManager {
  // Convert static lists to RxList
  final allMeals = RxList<HealthDataPoint>([]);
  final allZone2Foods = RxList<Zone2Food>([]);
  final filteredMeals = RxList<HealthDataPoint>([]);
  final filteredMealType = Rx<MealType>(MealType.UNKNOWN);
  final zone2User = Rxn<Zone2User>();
  final logger = Get.find<Logger>();
  // Convert statistics to Rx
  final totalCalories = 0.0.obs;
  final totalFat = 0.0.obs;
  final totalCarbohydrates = 0.0.obs;
  final totalProtein = 0.0.obs;
  final totalFatTarget = 0.0.obs;
  final totalCarbohydratesTarget = 0.0.obs;
  final totalProteinTarget = 0.0.obs;

  FoodManager() {
    ever(filteredMealType, (type) {
      filterMealsByType(type);
    });
    AuthService.to.zone2User.stream.listen((user) {
      zone2User.value = user;
      if (user != null) {
        checkForTargetMacros();
      }
    });

    SharedPreferencesService.to.zone2ProteinTarget.stream.listen((value) {
      totalProteinTarget.value = value;
    });
    SharedPreferencesService.to.zone2CarbsTarget.stream.listen((value) {
      totalCarbohydratesTarget.value = value;
    });
    SharedPreferencesService.to.zone2FatTarget.stream.listen((value) {
      totalFatTarget.value = value;
    });
  }

  /// Calculate total calories, fat, carbohydrates, and protein
  void _calculateTotals() {
    for (var meal in allZone2Foods) {
      totalCalories.value += meal.totalCaloriesValue;
      totalFat.value += meal.totalFatValue;
      totalCarbohydrates.value += meal.totalCarbsValue;
      totalProtein.value += meal.proteinValue;
    }
  }

  /// Reset all stored values to their defaults
  void _resetAllValues() {
    allMeals.clear();
    totalCalories.value = 0.0;
    totalFat.value = 0.0;
    totalCarbohydrates.value = 0.0;
    totalProtein.value = 0.0;
  }

  /// Process food data and store results
  void processFoodData(List<HealthDataPoint> healthDataPoints) {
    // Reset all stored values
    _resetAllValues();

    // Convert HealthDataPoints to Zone2Food and store meals
    allZone2Foods.value = healthDataPoints.map((dataPoint) {
      return Zone2Food.fromHealthDataPoint(dataPoint);
    }).toList();

    allMeals.value = healthDataPoints;

    // Calculate totals
    _calculateTotals();

    filterMealsByType(filteredMealType.value);
  }

  /// Calculates daily macro targets in grams based on target calories
  /// Returns a Map with protein, carbs, and fat targets
  Map<String, double> calculateMacroTargets({
    required double targetCalories,
    double proteinPercentage = 0.30,
    double carbsPercentage = 0.40,
    double fatPercentage = 0.30,
  }) {
    // Calories per gram: Protein = 4, Carbs = 4, Fat = 9
    final proteinGrams = (targetCalories * proteinPercentage) / 4;
    final carbsGrams = (targetCalories * carbsPercentage) / 4;
    final fatGrams = (targetCalories * fatPercentage) / 9;

    return {
      'protein': double.parse(proteinGrams.toStringAsFixed(1)),
      'carbs': double.parse(carbsGrams.toStringAsFixed(1)),
      'fat': double.parse(fatGrams.toStringAsFixed(1)),
    };
  }

  Future<void> checkForTargetMacros() async {
    if (SharedPreferencesService.to.zone2ProteinTarget.value == 0.0 ||
        SharedPreferencesService.to.zone2CarbsTarget.value == 0.0 ||
        SharedPreferencesService.to.zone2FatTarget.value == 0.0) {
      logger.w('Macros not set, setting default values');

      final targetMacros = calculateMacroTargets(
          targetCalories: zone2User.value?.zoneSettings?.dailyCalorieIntakeGoal ?? 2000.0);
      SharedPreferencesService.to.setZone2ProteinTarget(targetMacros['protein'] as double);
      SharedPreferencesService.to.setZone2CarbsTarget(targetMacros['carbs'] as double);
      SharedPreferencesService.to.setZone2FatTarget(targetMacros['fat'] as double);
    } else {
      totalProteinTarget.value = SharedPreferencesService.to.zone2ProteinTarget.value;
      totalCarbohydratesTarget.value = SharedPreferencesService.to.zone2CarbsTarget.value;
      totalFatTarget.value = SharedPreferencesService.to.zone2FatTarget.value;
    }
  }

  Future<void> filterMealsByType(MealType type) async {
    if (type == MealType.UNKNOWN) {
      filteredMeals.value = allMeals;
    } else {
      filteredMeals.value = allMeals
          .where((meal) =>
              (meal.value as NutritionHealthValue).zinc ==
              HealthService.to.convertMealthTypeToDouble(type))
          .toList();
    }
  }
}
