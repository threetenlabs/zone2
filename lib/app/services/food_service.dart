import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:zone2/app/models/food.dart';

class FoodService extends GetxService {
  final String apiKey = 'ygfyVKsHpawwcVqw8PISfTHFWGFEccnaRhgY0cNk';
  final String baseUrl = 'https://api.nal.usda.gov/fdc/v1';
  final logger = Get.find<Logger>();
  final box = GetStorage('food_data');

  final String usdaFoodInfoKey = 'usda_food_info_key';

  bool getUserHasRemovedAds() {
    return box.read(usdaFoodInfoKey) ?? false;
  }

  Future<void> saveUserHasRemovedAds(bool value) async {
    await box.write(usdaFoodInfoKey, value);
  }

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
