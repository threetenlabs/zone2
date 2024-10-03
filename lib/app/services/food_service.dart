import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

// ... existing code ...

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

  int _compareDataType(String a, String b) {
    const order = {
      'Foundation': 0,
      'SR Legacy': 1,
      'Branded': 2,
    };
    return (order[a] ?? 3).compareTo(order[b] ?? 3); // Default to 3 for unknown types
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
  });
}

class FoodService extends GetxService {
  final String apiKey = 'ygfyVKsHpawwcVqw8PISfTHFWGFEccnaRhgY0cNk';
  final String baseUrl = 'https://api.nal.usda.gov/fdc/v1';

  final logger = Get.find<Logger>();

  Future<FoodSearchResponse> searchFood(String searchTerm) async {
    // First call for Foundation
    final foundationResponse = await http.post(
      Uri.parse('$baseUrl/foods/search?api_key=$apiKey'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "query": searchTerm,
        "dataType": ["Foundation"],
        "pageSize": 25, // Limit to 25
        "sortBy": "dataType.keyword",
        "sortOrder": "asc",
      }),
    );

    // Second call for SR Legacy and Branded
    final legacyBrandedResponse = await http.post(
      Uri.parse('$baseUrl/foods/search?api_key=$apiKey'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "query": searchTerm,
        "dataType": ["SR Legacy", "Branded"],
        "pageSize": 25, // Limit to 25
        "sortBy": "dataType.keyword",
        "sortOrder": "asc",
      }),
    );

    // Check responses and decode JSON
    if (foundationResponse.statusCode == 200 && legacyBrandedResponse.statusCode == 200) {
      final foundationJsonResponse = json.decode(foundationResponse.body);
      final legacyBrandedJsonResponse = json.decode(legacyBrandedResponse.body);

      // Create FoodSearchResponse for both responses
      final foundationFoods = FoodSearchResponse.fromJson(foundationJsonResponse).foods;
      final legacyBrandedFoods = FoodSearchResponse.fromJson(legacyBrandedJsonResponse).foods;

      // Union the results
      final combinedFoods = [...foundationFoods, ...legacyBrandedFoods];

      // Create a new FoodSearchResponse with combined results
      final combinedResponse = FoodSearchResponse(
        foodSearchCriteria:
            FoodSearchCriteria.fromJson(foundationJsonResponse['foodSearchCriteria'] ?? {}),
        totalHits: foundationJsonResponse['totalHits'] + legacyBrandedJsonResponse['totalHits'],
        currentPage: 1,
        totalPages: 1,
        foods: combinedFoods,
      );

      return combinedResponse;
    } else {
      throw Exception('Failed to load food data');
    }
  }

  Future<dynamic> getFoodById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/food/$id?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final j = json.decode(response.body);
      debugPrint(j.toString());
      return j;
    } else {
      throw Exception('Failed to load food data');
    }
  }
}
