import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food_detail.dart';

class FoodSearchWidget extends GetWidget<DiaryController> {
  const FoodSearchWidget({super.key});
  // New widget class
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Full screen height
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context), // Close the bottom sheet
            ),
          ),
          // Search input
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search for food...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              // Call food_service search method
              controller.searchFood(value);
              // Navigator.pop(context); // Close the bottom sheet
            },
          ),
          const SizedBox(height: 16),
          // Check if foodSearchResponse has a value
          Obx(() {
            final foodSearchResponse = controller.foodSearchResults.value;
            if (foodSearchResponse != null && foodSearchResponse.foods.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: foodSearchResponse.foods.length,
                  itemBuilder: (context, index) {
                    final food = foodSearchResponse.foods[index];
                    return ListTile(
                      title: Text(food.description),
                      subtitle: Text('Brand: ${food.brandOwner}'),
                      onTap: () => {
                        controller.selectedFood.value = food,
                        _showFoodDetail(context),
                      }, // Show food details on tap
                    );
                  },
                ),
              );
            } else if (controller.searchPerformed.value) {
              return const Text('No results found'); // Handle no results
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  void _showFoodDetail(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      context: context,
      builder: (context) {
        return const FoodDetailBottomSheet(); // Pass the selected food
      },
    );
  }
}
