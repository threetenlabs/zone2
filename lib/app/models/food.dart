import 'package:health/health.dart';
import 'package:zone2/app/services/health_service.dart';

class FoodSearchResponse {
  final FoodSearchCriteria foodSearchCriteria;
  final int totalHits;
  final int currentPage;
  final int totalPages;
  final List<UsdaFood> foods;

  FoodSearchResponse({
    required this.foodSearchCriteria,
    required this.totalHits,
    required this.currentPage,
    required this.totalPages,
    required this.foods,
  });

  factory FoodSearchResponse.fromJson(Map<String, dynamic> json) {
    return FoodSearchResponse(
      foodSearchCriteria:
          FoodSearchCriteria.fromJson(json['foodSearchCriteria'] ?? {}), // Handle null
      totalHits: json['totalHits'] ?? 0, // Default to 0 if null
      currentPage: json['currentPage'] ?? 1, // Default to 1 if null
      totalPages: json['totalPages'] ?? 1, // Default to 1 if null
      foods: List<UsdaFood>.from(
          json['foods']?.map((food) => UsdaFood.fromJson(food)) ?? []), // Handle null
    );
  }
}

class FoodSearchCriteria {
  final String query;
  final List<String> dataType;
  final int pageSize;
  final int pageNumber;
  final String sortBy;
  final String sortOrder;
  final String brandOwner;
  final List<String> tradeChannel;
  final String startDate;
  final String endDate;

  FoodSearchCriteria({
    required this.query,
    required this.dataType,
    required this.pageSize,
    required this.pageNumber,
    required this.sortBy,
    required this.sortOrder,
    required this.brandOwner,
    required this.tradeChannel,
    required this.startDate,
    required this.endDate,
  });

  factory FoodSearchCriteria.fromJson(Map<String, dynamic> json) {
    return FoodSearchCriteria(
      query: json['query'] ?? '', // Default to empty string if null
      dataType: List<String>.from(json['dataType'] ?? []), // Handle null
      pageSize: json['pageSize'] ?? 10, // Default to 10 if null
      pageNumber: json['pageNumber'] ?? 1, // Default to 1 if null
      sortBy: json['sortBy'] ?? 'dataType.keyword', // Default to a specific value if null
      sortOrder: json['sortOrder'] ?? 'asc', // Default to 'asc' if null
      brandOwner: json['brandOwner'] ?? '', // Default to empty string if null
      tradeChannel: List<String>.from(json['tradeChannel'] ?? []), // Handle null
      startDate: json['startDate'] ?? '', // Default to empty string if null
      endDate: json['endDate'] ?? '', // Default to empty string if null
    );
  }
}

class UsdaFood {
  final int fdcId;
  final String dataType;
  final String description;
  final List<UsdaFoodNutrient> foodNutrients;
  final String publicationDate;
  final String brandOwner;
  final String servingSizeUnit;
  final double servingSize;
  final String householdServingFullText;

  UsdaFood({
    required this.fdcId,
    required this.dataType,
    required this.description,
    required this.foodNutrients,
    required this.publicationDate,
    required this.brandOwner,
    required this.servingSizeUnit,
    required this.servingSize,
    required this.householdServingFullText,
  });

  factory UsdaFood.fromJson(Map<String, dynamic> json) {
    return UsdaFood(
      fdcId: json['fdcId'] ?? 0, // Default to 0 if null
      dataType: json['dataType'] ?? '', // Default to empty string if null
      description: json['description'] ?? '', // Default to empty string if null
      foodNutrients: List<UsdaFoodNutrient>.from(
          json['foodNutrients']?.map((nutrient) => UsdaFoodNutrient.fromJson(nutrient)) ??
              []), // Handle null
      publicationDate: json['publicationDate'] ?? '', // Default to empty string if null
      brandOwner: json['brandOwner'] ?? '', // Default to empty string if null
      servingSizeUnit: json['servingSizeUnit'] ?? '', // Default to empty string if null
      servingSize: json['servingSize'] ?? 0.0, // Default to 0.0 if null
      householdServingFullText:
          json['householdServingFullText'] ?? '', // Default to empty string if null
    );
  }
}

class UsdaFoodNutrient {
  final String name;
  final double amount;
  final String unitName;

  UsdaFoodNutrient({
    required this.name,
    required this.amount,
    required this.unitName,
  });

  factory UsdaFoodNutrient.fromJson(Map<String, dynamic> json) {
    return UsdaFoodNutrient(
      name: json['nutrientName'],
      amount: json['value'] != null
          ? (json['value'] is int)
              ? (json['value'] as int).toDouble()
              : (json['value'] as double) // Handle int or double
          : 0.0, // Default to 0.0 if null
      unitName: json['unitName'],
    );
  }
}

/// This class represents a meal in the platform health system.
class PlatformHealthMeal {
  /// The name of the meal.
  final String name;

  /// The label for the total calories of the meal.
  final String totalCaloriesLabel;

  /// The value of the total calories of the meal.
  final double totalCaloriesValue;

  /// The label for the protein content of the meal.
  final String proteinLabel;

  /// The value of the protein content of the meal.
  final double proteinValue;

  /// The label for the total carbs of the meal.
  final String totalCarbsLabel;

  /// The value of the total carbs of the meal.
  final double totalCarbsValue;

  /// The label for the fiber content of the meal.
  final String fiberLabel;

  /// The value of the fiber content of the meal.
  final double fiberValue;

  /// The label for the sugar content of the meal.
  final String sugarLabel;

  /// The value of the sugar content of the meal.
  final double sugarValue;

  /// The label for the total fat of the meal.
  final String totalFatLabel;

  /// The value of the total fat of the meal.
  final double totalFatValue;

  /// The label for the saturated fat of the meal.
  final String saturatedLabel;

  /// The value of the saturated fat of the meal.
  final double saturatedValue;

  /// The label for the sodium content of the meal.
  final String sodiumLabel;

  /// The value of the sodium content of the meal.
  final double sodiumValue;

  /// The label for the cholesterol content of the meal.
  final String cholesterolLabel;

  /// The value of the cholesterol content of the meal.
  final double cholesterolValue;

  /// The label for the potassium content of the meal.
  final String potassiumLabel;

  /// The value of the potassium content of the meal.
  final double potassiumValue;

  /// The label for the zinc content of the meal.
  final String mealTypeLabel;

  /// The value of the zinc content of the meal.
  final double mealTypeValue;

  /// Constructor for the PlatformHealthMeal class.
  PlatformHealthMeal({
    required this.name,
    required this.totalCaloriesLabel,
    required this.totalCaloriesValue,
    required this.proteinLabel,
    required this.proteinValue,
    required this.totalCarbsLabel,
    required this.totalCarbsValue,
    required this.fiberLabel,
    required this.fiberValue,
    required this.sugarLabel,
    required this.sugarValue,
    required this.totalFatLabel,
    required this.totalFatValue,
    required this.saturatedLabel,
    required this.saturatedValue,
    required this.sodiumLabel,
    required this.sodiumValue,
    required this.cholesterolLabel,
    required this.cholesterolValue,
    required this.potassiumLabel,
    required this.potassiumValue,
    required this.mealTypeLabel,
    required this.mealTypeValue,
  });

  static List<dynamic> _getNutrientInfo(UsdaFood food, String nutrientName) {
    final nutrient = food.foodNutrients.firstWhere(
      (n) => n.name == nutrientName,
      orElse: () => UsdaFoodNutrient(name: nutrientName, amount: 0, unitName: ''),
    );

    var unit = nutrient.unitName.toLowerCase();
    var value = nutrient.amount;
    var displayValue = value;

    // Convert mg to g (grams) if unitName is 'mg'
    if (unit == 'mg') {
      value = (value / 1000).roundToDouble();
      if (value > 1000) {
        displayValue = (displayValue / 1000).roundToDouble();
        unit = 'g';
      }
    }

    // Convert kj to kcal
    if (unit == 'kj') {
      value = (value / 4.184).roundToDouble();
      displayValue = (displayValue / 4.184).roundToDouble();
      unit = 'kcal';
    }

    return ['${displayValue.toString()} $unit', value];
  }

  factory PlatformHealthMeal.fromUsdaFood(UsdaFood food, MealType mealType) {
    final energyInfo = _getNutrientInfo(food, 'Energy');
    final proteinInfo = _getNutrientInfo(food, 'Protein');
    final carbsInfo = _getNutrientInfo(food, 'Carbohydrate, by difference');
    final fiberInfo = _getNutrientInfo(food, 'Fiber, total dietary');
    final sugarInfo = _getNutrientInfo(food, 'Sugars, Total');
    final fatInfo = _getNutrientInfo(food, 'Total lipid (fat)');
    final saturatedInfo = _getNutrientInfo(food, 'Fatty acids, total saturated');
    final sodiumInfo = _getNutrientInfo(food, 'Sodium, Na');
    final cholesterolInfo = _getNutrientInfo(food, 'Cholesterol');
    final potassiumInfo = _getNutrientInfo(food, 'Potassium, K');

    PlatformHealthMeal meal = PlatformHealthMeal(
        name: '',
        totalCaloriesLabel: energyInfo[0],
        totalCaloriesValue: energyInfo[1],
        proteinLabel: proteinInfo[0],
        proteinValue: proteinInfo[1],
        totalCarbsLabel: carbsInfo[0],
        totalCarbsValue: carbsInfo[1],
        fiberLabel: fiberInfo[0],
        fiberValue: fiberInfo[1],
        sugarLabel: sugarInfo[0],
        sugarValue: sugarInfo[1],
        totalFatLabel: fatInfo[0],
        totalFatValue: fatInfo[1],
        saturatedLabel: saturatedInfo[0],
        saturatedValue: saturatedInfo[1],
        sodiumLabel: sodiumInfo[0],
        sodiumValue: sodiumInfo[1],
        cholesterolLabel: cholesterolInfo[0],
        cholesterolValue: cholesterolInfo[1],
        potassiumLabel: potassiumInfo[0],
        potassiumValue: potassiumInfo[1],
        mealTypeLabel: mealType.name,
        mealTypeValue: HealthService.to.convertDataTypeToDouble(mealType));

    return meal;
  }

  factory PlatformHealthMeal.fromHealthDataPoint(HealthDataPoint dataPoint) {
    final healthInfo = dataPoint.value as NutritionHealthValue;
    return PlatformHealthMeal(
      name: healthInfo.name ?? '',
      totalCaloriesLabel: healthInfo.calories.toString(),
      totalCaloriesValue: healthInfo.calories ?? 0.0,
      proteinLabel: healthInfo.protein.toString(),
      proteinValue: healthInfo.protein ?? 0.0,
      totalCarbsLabel: healthInfo.carbs.toString(),
      totalCarbsValue: healthInfo.carbs ?? 0.0,
      fiberLabel: healthInfo.fiber.toString(),
      fiberValue: healthInfo.fiber ?? 0.0,
      sugarLabel: healthInfo.sugar.toString(),
      sugarValue: healthInfo.sugar ?? 0.0,
      totalFatLabel: healthInfo.fat.toString(),
      totalFatValue: healthInfo.fat ?? 0.0,
      saturatedLabel: healthInfo.fatSaturated.toString(),
      saturatedValue: healthInfo.fatSaturated ?? 0.0,
      sodiumLabel: healthInfo.sodium.toString(),
      sodiumValue: healthInfo.sodium ?? 0.0,
      cholesterolLabel: healthInfo.cholesterol.toString(),
      cholesterolValue: healthInfo.cholesterol ?? 0.0,
      potassiumLabel: healthInfo.potassium.toString(),
      potassiumValue: healthInfo.potassium ?? 0.0,
      mealTypeLabel: healthInfo.mealType.toString(),
      mealTypeValue: healthInfo.zinc ?? 0.0,
    );
  }
}

// class Zone2NutritionalInfo {
//   final double energy;
//   final double protein;
//   final double carbohydrates;
//   final double sugars;
//   final double totalFat;
//   final double saturatedFat;
//   final double sodium;
//   final double cholesterol;
//   final double potassium;
//   final int mealTypeInteger;

//   Zone2NutritionalInfo({
//     required this.energy,
//     required this.protein,
//     required this.carbohydrates,
//     required this.sugars,
//     required this.totalFat,
//     required this.saturatedFat,
//     required this.sodium,
//     required this.cholesterol,
//     required this.potassium,
//     required this.mealTypeInteger,
//   });

//   // Method to create Zone2NutritionalInfo from UsdaFood
//   factory Zone2NutritionalInfo.fromUsdaFood(UsdaFood food) {
//     double energy = 0.0;
//     double protein = 0.0;
//     double carbohydrates = 0.0;
//     double sugars = 0.0;
//     double totalFat = 0.0;
//     double saturatedFat = 0.0;
//     double sodium = 0.0;
//     double cholesterol = 0.0;
//     double potassium = 0.0;

//     for (var nutrient in food.foodNutrients) {
//       switch (nutrient.name) {
//         case 'Energy':
//           energy = nutrient.amount;
//           break;
//         case 'Protein':
//           protein = nutrient.amount;
//           break;
//         case 'Total lipid (fat)':
//           totalFat = nutrient.amount;
//           break;
//         case 'Carbohydrate, by difference':
//           carbohydrates = nutrient.amount;
//           break;
//         case 'Sugars, Total':
//           sugars = nutrient.amount;
//           break;
//         case 'Fatty acids, total saturated':
//           saturatedFat = nutrient.amount;
//           break;
//         case 'Sodium, Na':
//           sodium = nutrient.amount;
//           break;
//         case 'Cholesterol':
//           cholesterol = nutrient.amount;
//           break;
//         case 'Potassium, K':
//           potassium = nutrient.amount;
//           break;
//         // Add more cases as needed
//       }
//     }

//     return Zone2NutritionalInfo(
//       energy: energy,
//       protein: protein,
//       carbohydrates: carbohydrates,
//       sugars: sugars,
//       totalFat: totalFat,
//       saturatedFat: saturatedFat,
//       sodium: sodium,
//       cholesterol: cholesterol,
//       potassium: potassium,
//       mealTypeInteger: 1, // Default or map accordingly
//     );
//   }

//   // Method to create Zone2NutritionalInfo from HealthDataPoint
//   factory Zone2NutritionalInfo.fromHealthDataPoint(HealthDataPoint dataPoint) {
//     final healthInfo = dataPoint.value as NutritionHealthValue;
//     return Zone2NutritionalInfo(
//       energy: healthInfo.calories ?? 0.0,
//       protein: healthInfo.protein ?? 0.0,
//       carbohydrates: healthInfo.carbs ?? 0.0,
//       sugars: healthInfo.sugar ?? 0.0,
//       totalFat: healthInfo.fat ?? 0.0,
//       saturatedFat: healthInfo.fatSaturated ?? 0.0,
//       sodium: healthInfo.sodium ?? 0.0,
//       cholesterol: healthInfo.cholesterol ?? 0.0,
//       potassium: healthInfo.potassium ?? 0.0,
//       mealTypeInteger: 1, // Default or map accordingly
//     );
//   }

//   // Method to convert Zone2NutritionalInfo to UsdaFood
//   UsdaFood toUsdaFood() {
//     // Create a UsdaFood object based on the nutritional info
//     return UsdaFood(
//       fdcId: 0, // Set appropriate ID or logic
//       dataType: 'Branded', // Set appropriate type
//       description: 'Custom Food', // Set appropriate description
//       foodNutrients: [
//         UsdaFoodNutrient(name: 'Energy', amount: energy, unitName: 'kcal'),
//         UsdaFoodNutrient(name: 'Protein', amount: protein, unitName: 'g'),
//         UsdaFoodNutrient(name: 'Total lipid (fat)', amount: totalFat, unitName: 'g'),
//         UsdaFoodNutrient(name: 'Carbohydrate, by difference', amount: carbohydrates, unitName: 'g'),
//         UsdaFoodNutrient(name: 'Sugars, Total', amount: sugars, unitName: 'g'),
//         UsdaFoodNutrient(name: 'Fatty acids, total saturated', amount: saturatedFat, unitName: 'g'),
//         UsdaFoodNutrient(name: 'Sodium, Na', amount: sodium, unitName: 'mg'),
//         UsdaFoodNutrient(name: 'Cholesterol', amount: cholesterol, unitName: 'mg'),
//         UsdaFoodNutrient(name: 'Potassium, K', amount: potassium, unitName: 'mg'),
//       ],
//       publicationDate: DateTime.now().toString(), // Set appropriate date
//       brandOwner: '', // Set appropriate brand owner
//       servingSizeUnit: 'g', // Set appropriate serving size unit
//       servingSize: 100.0, // Set appropriate serving size
//       householdServingFullText: '1 serving', // Set appropriate serving text
//     );
//   }

//   // Method to convert Zone2NutritionalInfo to HealthDataPoint
//   NutritionHealthValue toHealthDataPoint() {
//     return NutritionHealthValue(
//       name: 'Custom Food',
//       calories: energy,
//       protein: protein,
//       fat: totalFat,
//       carbs: carbohydrates,
//       sugar: sugars,
//       fatSaturated: saturatedFat,
//       sodium: sodium,
//       cholesterol: cholesterol,
//       potassium: potassium,
//       zinc: zinc,
//       // Add other fields as necessary
//     );
//   }
// }
