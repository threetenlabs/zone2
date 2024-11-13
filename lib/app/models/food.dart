import 'package:health/health.dart';
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
      brand: brand,
      servingSizeUnit: servingSizeUnit,
      servingSize: servingSize,
      householdServingFullText: servingSizeStr,
    );
  }

  factory OpenFoodFactsFood.fromUsdaFood(UsdaFood food) {
    // Map nutrients to OpenFoodFactsNutriment format
    List<OpenFoodFactsNutriment> nutrients = [];

    // Helper function to find nutrient value
    double getNutrientValue(String name) {
      final nutrient = food.foodNutrients.firstWhere(
        (n) => n.name.toLowerCase().contains(name.toLowerCase()),
        orElse: () => UsdaFoodNutrient(name: '', amount: 0.0, unitName: ''),
      );
      return nutrient.amount;
    }

    nutrients.addAll([
      OpenFoodFactsNutriment(
          name: 'energyKCal', amount: getNutrientValue('Energy'), unitName: 'kcal'),
      OpenFoodFactsNutriment(name: 'proteins', amount: getNutrientValue('Protein'), unitName: 'g'),
      OpenFoodFactsNutriment(
          name: 'fat', amount: getNutrientValue('Total lipid (fat)'), unitName: 'g'),
      OpenFoodFactsNutriment(
          name: 'carbohydrates',
          amount: getNutrientValue('Carbohydrate, by difference'),
          unitName: 'g'),
      OpenFoodFactsNutriment(
          name: 'sugars', amount: getNutrientValue('Sugars, Total'), unitName: 'g'),
      OpenFoodFactsNutriment(
          name: 'saturated-fat',
          amount: getNutrientValue('Fatty acids, total saturated'),
          unitName: 'g'),
      OpenFoodFactsNutriment(name: 'sodium', amount: getNutrientValue('Sodium, Na'), unitName: 'g'),
      OpenFoodFactsNutriment(
          name: 'cholesterol', amount: getNutrientValue('Cholesterol'), unitName: 'mg'),
      OpenFoodFactsNutriment(
          name: 'potassium', amount: getNutrientValue('Potassium, K'), unitName: 'g'),
    ]);

    return OpenFoodFactsFood(
      barcode: food.fdcId.toString(),
      description: food.description,
      nutriments: nutrients,
      brand: food.brandOwner.isNotEmpty ? food.brandOwner : 'N/A',
      servingSizeUnit: food.servingSizeUnit,
      servingSize: food.servingSize,
      householdServingFullText: food.householdServingFullText,
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
    var value = (nutrient.amount * 10).round() / 10;
    var displayValue = value;

    // Convert mg to g (grams) if unitName is 'mg'
    if (unit == 'mg') {
      value = ((value / 1000) * 10).round() / 10;
      displayValue = ((displayValue / 1000) * 10).round() / 10;
      unit = 'g';
    }

    // Convert kj to kcal
    if (unit == 'kj') {
      value = ((value / 4.184) * 10).round() / 10;
      displayValue = ((displayValue / 4.184) * 10).round() / 10;
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
      totalCaloriesLabel: '${((healthInfo.calories ?? 0.0) * 10).round() / 10} kcal',
      totalCaloriesValue: ((healthInfo.calories ?? 0.0) * 10).round() / 10,
      proteinLabel: '${((healthInfo.protein ?? 0.0) * 10).round() / 10} g',
      proteinValue: ((healthInfo.protein ?? 0.0) * 10).round() / 10,
      totalCarbsLabel: '${((healthInfo.carbs ?? 0.0) * 10).round() / 10} g',
      totalCarbsValue: ((healthInfo.carbs ?? 0.0) * 10).round() / 10,
      fiberLabel: '${((healthInfo.fiber ?? 0.0) * 10).round() / 10} g',
      fiberValue: ((healthInfo.fiber ?? 0.0) * 10).round() / 10,
      sugarLabel: '${((healthInfo.sugar ?? 0.0) * 10).round() / 10} g',
      sugarValue: ((healthInfo.sugar ?? 0.0) * 10).round() / 10,
      totalFatLabel: '${((healthInfo.fat ?? 0.0) * 10).round() / 10} g',
      totalFatValue: ((healthInfo.fat ?? 0.0) * 10).round() / 10,
      saturatedLabel: '${((healthInfo.fatSaturated ?? 0.0) * 10).round() / 10} g',
      saturatedValue: ((healthInfo.fatSaturated ?? 0.0) * 10).round() / 10,
      sodiumLabel: '${((healthInfo.sodium ?? 0.0) * 10).round() / 10} g',
      sodiumValue: ((healthInfo.sodium ?? 0.0) * 10).round() / 10,
      cholesterolLabel: '${((healthInfo.cholesterol ?? 0.0) * 10).round() / 10} g',
      cholesterolValue: ((healthInfo.cholesterol ?? 0.0) * 10).round() / 10,
      potassiumLabel: '${((healthInfo.potassium ?? 0.0) * 10).round() / 10} g',
      potassiumValue: ((healthInfo.potassium ?? 0.0) * 10).round() / 10,
      mealTypeValue: ((healthInfo.zinc ?? 0.0) * 10).round() / 10,
      type: dataPoint.type,
      startTime: dataPoint.dateFrom,
      endTime: dataPoint.dateTo,
    );
  }
}

class UsdaFoodSearchResponse {
  final FoodSearchCriteria foodSearchCriteria;
  final int totalHits;
  final int currentPage;
  final int totalPages;
  final List<UsdaFood> foods;

  UsdaFoodSearchResponse({
    required this.foodSearchCriteria,
    required this.totalHits,
    required this.currentPage,
    required this.totalPages,
    required this.foods,
  });

  factory UsdaFoodSearchResponse.fromJson(Map<String, dynamic> json) {
    return UsdaFoodSearchResponse(
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
