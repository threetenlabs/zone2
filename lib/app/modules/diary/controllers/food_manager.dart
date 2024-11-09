import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/services/health_service.dart';

/// Class to manage and process food data
class FoodManager {
  // Convert static lists to RxList
  final allMeals = RxList<HealthDataPoint>([]);
  final allZone2Foods = RxList<Zone2Food>([]);
  final filteredMeals = RxList<HealthDataPoint>([]);
  final filteredMealType = Rx<MealType>(MealType.UNKNOWN);

  FoodManager() {
    ever(filteredMealType, (type) {
      filterMealsByType(type);
    });
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

  // Convert statistics to Rx
  final totalCalories = 0.0.obs;
  final totalFat = 0.0.obs;
  final totalCarbohydrates = 0.0.obs;
  final totalProtein = 0.0.obs;

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
}
