import 'package:health/health.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfoodfacts;

class FoodSearchResponse {
  final int totalHits;

  final List<OpenFoodFactsFood> foods;

  FoodSearchResponse({
    required this.totalHits,
    required this.foods,
  });

  factory FoodSearchResponse.fromResult(List<openfoodfacts.Product> foods) {
    return FoodSearchResponse(
      totalHits: foods.length,
      foods: List<OpenFoodFactsFood>.from(
          foods.map((food) => OpenFoodFactsFood.fromOpenFoodFacts(food))),
    );
  }
}

class OpenFoodFactsFood {
  final String barcode;
  final String description;
  final List<OpenFoodFactsNutriment> nutriments;
  final String brand;
  final String servingSizeUnit;
  final double servingSize;
  final String householdServingFullText;

  OpenFoodFactsFood({
    required this.barcode,
    required this.description,
    required this.nutriments,
    required this.brand,
    required this.servingSizeUnit,
    required this.servingSize,
    required this.householdServingFullText,
  });

  factory OpenFoodFactsFood.fromOpenFoodFacts(openfoodfacts.Product product) {
    final barcode = product.barcode;
    final description = product.productName;
    final brand = product.brands ?? 'N/A';
    final nutriments = product.nutriments;

    List<OpenFoodFactsNutriment> nutrients = [
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.energyKCal.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.energyKCal, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'kcal'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.proteins.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.proteins, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.fat.name,
          amount: nutriments?.getValue(openfoodfacts.Nutrient.fat, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.carbohydrates.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.carbohydrates, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.sugars.name,
          amount:
              nutriments?.getValue(openfoodfacts.Nutrient.sugars, openfoodfacts.PerSize.serving) ??
                  0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.saturatedFat.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.saturatedFat, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.sodium.name,
          amount:
              nutriments?.getValue(openfoodfacts.Nutrient.sodium, openfoodfacts.PerSize.serving) ??
                  0.0,
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.cholesterol.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.cholesterol, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'mg'),
      OpenFoodFactsNutriment(
          name: openfoodfacts.Nutrient.potassium.name,
          amount: nutriments?.getValue(
                  openfoodfacts.Nutrient.potassium, openfoodfacts.PerSize.serving) ??
              0.0,
          unitName: 'g'),
    ];

    // Parse serving size
    String servingSizeStr = product.servingSize ?? '';
    double servingSize = product.servingQuantity ?? 0.0;
    String servingSizeUnit = 'g';

    if (servingSizeStr.isNotEmpty) {
      // Extract unit from serving size string if available
      final unitMatch = RegExp(r'\((.*?)\)').firstMatch(servingSizeStr);
      if (unitMatch != null) {
        servingSizeUnit = unitMatch.group(1) ?? 'g';
      }
    }

    return OpenFoodFactsFood(
      barcode: barcode ?? '',
      description: description ?? '',
      nutriments: nutrients,
      brand: brand ?? '',
      servingSizeUnit: servingSizeUnit,
      servingSize: servingSize,
      householdServingFullText: servingSizeStr,
    );
  }
}

class OpenFoodFactsNutriment {
  final String name;
  final double amount;
  final String unitName;

  OpenFoodFactsNutriment({
    required this.name,
    required this.amount,
    required this.unitName,
  });

  factory OpenFoodFactsNutriment.fromJson(Map<String, dynamic> json) {
    return OpenFoodFactsNutriment(
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

/// This class represents a meal the application, a bridge between OpenFoodFactsFood and HealthDataPoint.
class Zone2Food {
  /// The name of the meal.
  final String name;

  /// The quantity of the serving.
  double servingQuantity;

  /// The brand of the meal.
  final String brand;

  /// The label for the serving size of the meal.
  final String servingLabel;

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

  /// The value gets mapped from the zinc content of the meal from the health app.
  double mealTypeValue;

  final HealthDataType? type;

  final DateTime? startTime;

  final DateTime? endTime;

  /// Constructor for the Zone2Meal class.
  Zone2Food({
    required this.name,
    required this.brand,
    required this.servingQuantity,
    required this.servingLabel,
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
    required this.mealTypeValue,
    this.type,
    this.startTime,
    this.endTime,
  });

  static List<dynamic> _getNutrientInfo(OpenFoodFactsFood food, String nutrientName) {
    final nutrient = food.nutriments.firstWhere(
      (n) => n.name == nutrientName,
      orElse: () => OpenFoodFactsNutriment(name: nutrientName, amount: 0, unitName: ''),
    );

    var unit = nutrient.unitName.toLowerCase();
    var value = nutrient.amount;
    var displayValue = value;

    // Convert mg to g (grams) if unitName is 'mg'
    if (unit == 'mg') {
      value = (value / 1000).roundToDouble();
      displayValue = (displayValue / 1000).roundToDouble();
      unit = 'g';
    }

    // Convert kj to kcal
    if (unit == 'kj') {
      value = (value / 4.184).roundToDouble();
      displayValue = (displayValue / 4.184).roundToDouble();
      unit = 'kcal';
    }

    return ['${displayValue.toString()} $unit', value];
  }

  factory Zone2Food.fromOpenFoodFactsFood(OpenFoodFactsFood food) {
    final energyInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.energyKCal.name);
    final proteinInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.proteins.name);
    final carbsInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.carbohydrates.name);
    final fiberInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.fiber.name);
    final sugarInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.sugars.name);
    final fatInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.fat.name);
    final saturatedInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.saturatedFat.name);
    final sodiumInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.sodium.name);
    final cholesterolInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.cholesterol.name);
    final potassiumInfo = _getNutrientInfo(food, openfoodfacts.Nutrient.potassium.name);

    Zone2Food meal = Zone2Food(
        name: food.description,
        brand: food.brand,
        servingLabel: food.householdServingFullText,
        servingQuantity: 0.0,
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
        mealTypeValue: 0.0);

    return meal;
  }

  factory Zone2Food.fromHealthDataPoint(HealthDataPoint dataPoint) {
    final healthInfo = dataPoint.value as NutritionHealthValue;

    // This is a hack: the name is formatted as "name | brand | serving quantity | serving label" in the health app
    final nameParts = healthInfo.name?.split(' | ');
    final name = nameParts != null && nameParts.isNotEmpty ? nameParts[0] : '';
    final brand = nameParts != null && nameParts.length > 1 ? nameParts[1] : '';
    final servingQuantity =
        nameParts != null && nameParts.length > 2 ? double.parse(nameParts[2]) : 0.0;
    final servingLabel = nameParts != null && nameParts.length > 3 ? nameParts[3] : '';

    return Zone2Food(
      name: name,
      brand: brand,
      servingQuantity: servingQuantity,
      servingLabel: servingLabel,
      totalCaloriesLabel: '${healthInfo.calories ?? 0.0} kcal',
      totalCaloriesValue: healthInfo.calories ?? 0.0,
      proteinLabel: '${healthInfo.protein ?? 0.0} g',
      proteinValue: healthInfo.protein ?? 0.0,
      totalCarbsLabel: '${healthInfo.carbs ?? 0.0} g',
      totalCarbsValue: healthInfo.carbs ?? 0.0,
      fiberLabel: '${healthInfo.fiber ?? 0.0} g',
      fiberValue: healthInfo.fiber ?? 0.0,
      sugarLabel: '${healthInfo.sugar ?? 0.0} g',
      sugarValue: healthInfo.sugar ?? 0.0,
      totalFatLabel: '${healthInfo.fat ?? 0.0} g',
      totalFatValue: healthInfo.fat ?? 0.0,
      saturatedLabel: '${healthInfo.fatSaturated ?? 0.0} g',
      saturatedValue: healthInfo.fatSaturated ?? 0.0,
      sodiumLabel: '${healthInfo.sodium ?? 0.0} g',
      sodiumValue: healthInfo.sodium ?? 0.0,
      cholesterolLabel: '${healthInfo.cholesterol ?? 0.0} g',
      cholesterolValue: healthInfo.cholesterol ?? 0.0,
      potassiumLabel: '${healthInfo.potassium ?? 0.0} g',
      potassiumValue: healthInfo.potassium ?? 0.0,
      mealTypeValue: healthInfo.zinc ?? 0.0,
      type: dataPoint.type,
      startTime: dataPoint.dateFrom,
      endTime: dataPoint.dateTo,
    );
  }
}
