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
  final List<Food> foods;

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
      foods:
          List<Food>.from(json['foods']?.map((food) => Food.fromJson(food)) ?? []), // Handle null
    );
  }

  // void sortFoods() {
  //   foods.sort((a, b) {
  //     // First sort by dataType
  //     int dataTypeComparison = _compareDataType(a.dataType, b.dataType);
  //     if (dataTypeComparison != 0) {
  //       return dataTypeComparison;
  //     }
  //     // If dataTypes are the same, sort by name
  //     return a.description.compareTo(b.description);
  //   });
  // }

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

class Food {
  final int fdcId;
  final String dataType;
  final String description;
  final List<FoodNutrient> foodNutrients;
  final String publicationDate;
  final String brandOwner;
  final String servingSizeUnit;
  final double servingSize;

  Food({
    required this.fdcId,
    required this.dataType,
    required this.description,
    required this.foodNutrients,
    required this.publicationDate,
    required this.brandOwner,
    required this.servingSizeUnit,
    required this.servingSize,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      fdcId: json['fdcId'] ?? 0, // Default to 0 if null
      dataType: json['dataType'] ?? '', // Default to empty string if null
      description: json['description'] ?? '', // Default to empty string if null
      foodNutrients: List<FoodNutrient>.from(
          json['foodNutrients']?.map((nutrient) => FoodNutrient.fromJson(nutrient)) ??
              []), // Handle null
      publicationDate: json['publicationDate'] ?? '', // Default to empty string if null
      brandOwner: json['brandOwner'] ?? '', // Default to empty string if null
      servingSizeUnit: json['servingSizeUnit'] ?? '', // Default to empty string if null
      servingSize: json['servingSize'] ?? 0.0, // Default to 0.0 if null
    );
  }
}

class FoodNutrient {
  final String name;
  final double amount;
  final String unitName;

  FoodNutrient({
    required this.name,
    required this.amount,
    required this.unitName,
  });

  factory FoodNutrient.fromJson(Map<String, dynamic> json) {
    return FoodNutrient(
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
