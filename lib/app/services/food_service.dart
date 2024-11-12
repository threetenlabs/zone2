import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:logger/logger.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/utils/helper.dart';

class FoodService extends GetxService {
  final logger = Get.find<Logger>();
  final box = GetStorage('food_data');

  final String usdaFoodInfoKey = 'usda_food_info_key';

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

  bool getUserHasRemovedAds() {
    return box.read(usdaFoodInfoKey) ?? false;
  }

  Future<void> saveUserHasRemovedAds(bool value) async {
    await box.write(usdaFoodInfoKey, value);
  }

  Future<FoodSearchResponse> searchFood(String searchTerm) async {
    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        SearchTerms(terms: [searchTerm]),
        const SortBy(
          option: SortOption.NOTHING,
        ),
        const PageSize(size: 100),
      ],
      version: ProductQueryVersion.v3,
      language: OpenFoodFactsLanguage.ENGLISH,
      country: OpenFoodFactsCountry.USA,
      fields: productFields,
    );

    try {
      SearchResult result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '', password: ''),
        configuration,
        uriHelper: uriHelperFoodProd,
      );

      // final searchResults = result.products?.map((product) => product.toJson()).toList();
      // printWrapped(searchResults.toString());
      // Filter out products that don't have a serving size
      final filteredResults =
          result.products?.where((product) => product.nutrimentDataPer == "serving").toList();

      final response = FoodSearchResponse.fromResult(filteredResults ?? []);

      return response;
    } catch (e) {
      logger.e('Error searching for food: $e');
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
          country: OpenFoodFactsCountry.USA,
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
}
