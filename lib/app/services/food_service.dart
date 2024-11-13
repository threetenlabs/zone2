import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:logger/logger.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:http/http.dart' as http;
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/utils/env.dart';

class FoodService extends GetxService {
  final logger = Get.find<Logger>();
  final box = GetStorage('food_data');

  final String usdaFoodApiKey = Env.usdaFoodApiKey;
  final String baseUrl = 'https://api.nal.usda.gov/fdc/v1';

  final productFields = [
    ProductField.BARCODE,
    ProductField.NAME,
    ProductField.GENERIC_NAME,
    ProductField.ABBREVIATED_NAME,
    ProductField.BRANDS,
    ProductField.QUANTITY,
    ProductField.SERVING_SIZE,
    ProductField.SERVING_QUANTITY,
    ProductField.PACKAGING_QUANTITY,
    ProductField.FRONT_IMAGE,
    ProductField.IMAGE_FRONT_URL,
    ProductField.IMAGE_FRONT_SMALL_URL,
    ProductField.IMAGE_NUTRITION_URL,
    ProductField.IMAGE_NUTRITION_SMALL_URL,
    ProductField.IMAGE_PACKAGING_URL,
    ProductField.IMAGE_PACKAGING_SMALL_URL,
    ProductField.INGREDIENTS,
    ProductField.NO_NUTRITION_DATA,
    ProductField.NUTRIMENTS,
    ProductField.NUTRIMENT_ENERGY_UNIT,
    ProductField.NUTRIMENT_DATA_PER,
    ProductField.NUTRITION_DATA,
    ProductField.NUTRISCORE,
    ProductField.LABELS,
    ProductField.PACKAGING,
    ProductField.PACKAGING_QUANTITY,
    ProductField.STORES_TAGS,
    ProductField.STORES,
  ];

  @override
  void onInit() {
    super.onInit();
    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'com.threetenlabs.zone2',
    );
  }

  Future<FoodSearchResponse> searchFood(String searchTerm) async {
    try {
      final futures = await Future.wait([
        _searchOpenFoodFacts(searchTerm),
        searchUsdaFood(searchTerm),
      ]);

      final offResults = futures[0] as FoodSearchResponse;
      final usdaResults = futures[1] as UsdaFoodSearchResponse;

      final usdaFoods =
          usdaResults.foods.map((food) => OpenFoodFactsFood.fromUsdaFood(food)).toList();

      final allFoods = [...usdaFoods, ...offResults.foods];

      // final fuse = Fuzzy(
      //   allFoods,
      //   options: FuzzyOptions(
      //     keys: [
      //       WeightedKey(
      //         name: 'description',
      //         getter: (food) => (food as OpenFoodFactsFood).description,
      //         weight: 3,
      //       ),
      //       WeightedKey(
      //         name: 'brand',
      //         getter: (food) => (food as OpenFoodFactsFood).brand,
      //         weight: 1,
      //       ),
      //     ],
      //   ),
      // );

      // final results = fuse.search(searchTerm);
      // final sortedFoods = results.map((r) => r.item as OpenFoodFactsFood).toList();

      return FoodSearchResponse(
        totalHits: allFoods.length,
        foods: allFoods,
      );
    } catch (e) {
      logger.e('Error searching for food: $e');
      return FoodSearchResponse(foods: [], totalHits: 0);
    }
  }

  Future<FoodSearchResponse> _searchOpenFoodFacts(String searchTerm) async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(parametersList: <Parameter>[
      SearchTerms(terms: [searchTerm]),
      const SortBy(
        option: SortOption.PRODUCT_NAME,
      ),
      const PageSize(size: 100),
    ], version: ProductQueryVersion.v3, language: OpenFoodFactsLanguage.ENGLISH);

    try {
      SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '', password: ''),
        configuration,
        uriHelper: uriHelperFoodProd,
      );

      final filteredResults = result.products?.where((product) {
        if (product.nutriments == null) return false;
        return product.nutriments!.toJson().keys.any((key) => key.endsWith('_serving'));
      }).toList();

      return FoodSearchResponse.fromResult(filteredResults ?? []);
    } catch (e) {
      logger.e('Error searching OpenFoodFacts: $e');
      return FoodSearchResponse(foods: [], totalHits: 0);
    }
  }

  Future<ProductResultV3> getFoodById(String barcode) async {
    try {
      final response = await OpenFoodAPIClient.getProductV3(
        ProductQueryConfiguration(
          barcode,
          version: ProductQueryVersion.v3,
          language: OpenFoodFactsLanguage.ENGLISH,
          fields: productFields,
        ),
        user: const User(userId: '', password: ''),
        uriHelper: kDebugMode ? uriHelperFoodTest : uriHelperFoodProd,
      );

      return response;
    } catch (e) {
      logger.e('Error getting food by id: $e');
      throw Exception('Failed to load food data');
    }
  }

  Future<UsdaFoodSearchResponse> searchUsdaFood(String searchTerm) async {
    try {
      final futures = await Future.wait([
        http.post(
          Uri.parse('$baseUrl/foods/search?api_key=$usdaFoodApiKey'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "query": searchTerm,
            "dataType": ["Foundation"],
            "pageSize": 25,
            "sortBy": "dataType.keyword",
            "sortOrder": "asc",
          }),
        ),
        http.post(
          Uri.parse('$baseUrl/foods/search?api_key=$usdaFoodApiKey'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "query": searchTerm,
            "dataType": ["Branded"],
            "pageSize": 25,
            "sortBy": "dataType.keyword",
            "sortOrder": "asc",
          }),
        ),
      ]);

      final foundationResponse = futures[0];
      final legacyBrandedResponse = futures[1];

      if (foundationResponse.statusCode == 200 && legacyBrandedResponse.statusCode == 200) {
        final foundationJsonResponse = json.decode(foundationResponse.body);
        final legacyBrandedJsonResponse = json.decode(legacyBrandedResponse.body);

        final foundationFoods = UsdaFoodSearchResponse.fromJson(foundationJsonResponse).foods;
        final legacyBrandedFoods = UsdaFoodSearchResponse.fromJson(legacyBrandedJsonResponse).foods;

        final combinedFoods = [...foundationFoods, ...legacyBrandedFoods];

        return UsdaFoodSearchResponse(
          foodSearchCriteria:
              FoodSearchCriteria.fromJson(foundationJsonResponse['foodSearchCriteria'] ?? {}),
          totalHits: foundationJsonResponse['totalHits'] + legacyBrandedJsonResponse['totalHits'],
          currentPage: 1,
          totalPages: 1,
          foods: combinedFoods,
        );
      } else {
        throw Exception('Failed to load food data');
      }
    } catch (e) {
      logger.e('Error searching USDA food: $e');
      throw Exception('Failed to load food data');
    }
  }

  Future<dynamic> getUsdaFoodById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/food/$id?api_key=$usdaFoodApiKey'));
    if (response.statusCode == 200) {
      final j = json.decode(response.body);
      debugPrint(j.toString());
      return j;
    } else {
      throw Exception('Failed to load food data');
    }
  }
}
