import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/ai_food.dart';
import 'package:zone2/app/modules/diary/views/food/food_search.dart';

class AddFoodBottomSheet extends GetView<DiaryController> {
  const AddFoodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
              Text(
                controller.selectedMealType.value.toString().split('.').last,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _showAIBottomSheet(context), // Call search method
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('AI Search'),
                  ),
                  // Search button
                  ElevatedButton(
                    onPressed: () => _showSearchBottomSheet(context), // Call search method
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                  // Scan Barcode button
                  ElevatedButton(
                    onPressed: () {
                      // Add your scan barcode logic here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('Scan Barcode'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMealList(), // Keep the meal list here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealList() {
    RxList<HealthDataPoint> mealList;
    switch (controller.selectedMealType.value) {
      case MealType.BREAKFAST:
        mealList = controller.breakfastData;
        break;
      case MealType.LUNCH:
        mealList = controller.lunchData;
        break;
      case MealType.DINNER:
        mealList = controller.dinnerData;
        break;
      case MealType.SNACK:
        mealList = controller.snackData;
        break;
      default:
        mealList = controller.breakfastData;
        break;
    }
    return Obx(() {
      if (mealList.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: mealList.length,
          itemBuilder: (context, index) {
            final item = mealList[index];
            final nutritionHealthValue = item.value as NutritionHealthValue;
            return GestureDetector(
              // {{ edit_1 }}
              onLongPress: () async {
                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text('Are you sure you want to delete this meal?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false), // No
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true), // Yes
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                // If confirmed, call deleteFood method
                if (confirm == true) {
                  // controller.deleteFood(item.dateFrom, item.dateTo);
                }
              },
              child: ListTile(
                title: Text('Food: ${nutritionHealthValue.name}'),
                subtitle: Text(
                  'Calories: ${nutritionHealthValue.calories?.toStringAsFixed(1) ?? '0.0'} | Protein: ${nutritionHealthValue.protein?.toStringAsFixed(1) ?? '0.0'}g | '
                  'Fat: ${nutritionHealthValue.fat?.toStringAsFixed(1) ?? '0.0'}g | Carbs: ${nutritionHealthValue.carbs?.toStringAsFixed(1) ?? '0.0'}g',
                ),
              ),
            );
          },
        );
      } else {
        return const Text('No meals logged'); // Handle no meals
      }
    });
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const FoodSearchWidget(); // Use the new widget here
      },
    );
  }

  void _showAIBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AISearchBottomSheet(); // Use the new widget here
      },
    );
  }
}
