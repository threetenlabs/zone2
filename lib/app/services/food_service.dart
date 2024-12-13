import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:logger/logger.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:http/http.dart' as http;
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/utils/env.dart';
import 'package:fuzzy/fuzzy.dart';

class FatSecretAuth {
  static const _authUrl = 'https://oauth.fatsecret.com/connect/token';
  static const _clientId = '60b6999cc95d4550a0c2b8dbbae9e0db';
  static const _clientSecret = 'c9e125ee9aef4fa18170936a56761c1e';

  String? _accessToken;
  int? _expiryTime;

  /// Fetches the token, renewing it if necessary.
  Future<String> getAccessToken() async {
    // Check if the token exists and is not expired
    if (_accessToken != null &&
        _expiryTime != null &&
        DateTime.now().millisecondsSinceEpoch < _expiryTime!) {
      return _accessToken!;
    }

    // Token is expired or missing, fetch a new one
    return await _fetchNewToken();
  }

  /// Fetches a new access token from the FatSecret API
  Future<String> _fetchNewToken() async {
    final response = await http.post(
      Uri.parse(_authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode("$_clientId:$_clientSecret"))}',
      },
      body: 'grant_type=client_credentials&scope=premier',
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      _accessToken = responseBody['access_token'];
      final expiresIn =
          (responseBody['expires_in'] * 1000).toInt(); // Convert to milliseconds and cast to int
      _expiryTime = (DateTime.now().millisecondsSinceEpoch + expiresIn).toInt(); // Cast to int

      return _accessToken!;
    } else {
      throw Exception('Failed to fetch new access token: ${response.body}');
    }
  }
}

class FoodService extends GetxService {
  final logger = Get.find<Logger>();
  final box = GetStorage('food_data');
  final auth = FatSecretAuth();

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
        searchFoodFatSecret(searchTerm),
      ]);

      final offResults = futures[0] as FoodSearchResponse;
      final usdaResults = futures[1] as UsdaFoodSearchResponse;

      final usdaFoods =
          usdaResults.foods.map((food) => OpenFoodFactsFood.fromUsdaFood(food)).toList();

      // Separate foundation foods
      final foundationFoods = usdaFoods.where((food) => food.dataType == 'Foundation').toList();

      // Get remaining foods
      final otherFoods = [
        ...usdaFoods.where((food) => food.dataType != 'Foundation'),
        ...offResults.foods
      ];

      // Create Fuzzy instance for sorting remaining foods
      final fuse = Fuzzy(
        otherFoods,
        options: FuzzyOptions(
          keys: [
            WeightedKey(
              name: 'description',
              getter: (food) => (food as OpenFoodFactsFood).description,
              weight: 0.7,
            ),
            WeightedKey(
              name: 'brand',
              getter: (food) => (food as OpenFoodFactsFood).brand,
              weight: 0.3,
            ),
          ],
          threshold: 0.4,
        ),
      );

      // Sort remaining foods by fuzzy match score
      final sortedOtherFoods =
          fuse.search(searchTerm).map((result) => result.item as OpenFoodFactsFood).toList();

      // Combine foundation foods with sorted remaining foods
      final allFoods = [...foundationFoods, ...sortedOtherFoods];

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
    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: <Parameter>[
          SearchTerms(terms: [searchTerm]),
          const SortBy(
            option: SortOption.PRODUCT_NAME,
          ),
          const PageSize(size: 50),
        ],
        version: ProductQueryVersion.v3,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: productFields);

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

  Future<void> getFatSecretFoodById(String id) async {
    final url = Uri.parse('https://platform.fatsecret.com/rest/food/v4?food_id=33691&format=json');

    try {
      final accessToken = await auth.getAccessToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        logger.i('Response: ${response.body}');
      } else {
        logger.e('Failed to fetch food details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  Future<void> searchFoodFatSecret(
    String searchExpression,
  ) async {
    // Base URL for the API
    final baseUrl = 'https://platform.fatsecret.com/rest/foods/search/v3';

    // Build query parameters
    final queryParams = {
      'search_expression': searchExpression,
      'page_number': '0',
      'max_results': '30',
      'flag_default_serving': 'true',
      'format': 'json',
    };

    // Create the URI with query parameters
    final url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      // Make the GET request
      final accessToken = await auth.getAccessToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Check the response status
      if (response.statusCode == 200) {
        logger.i('Response: ${response.body}');
      } else {
        logger.e('Failed to fetch search results. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }
}
