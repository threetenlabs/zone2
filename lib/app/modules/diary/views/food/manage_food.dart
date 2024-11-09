import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/add_food.dart';
import 'package:zone2/app/modules/diary/widgets/food_carousel.dart';
import 'package:zone2/app/modules/diary/widgets/macro_card.dart';

class ManageFoodBottomSheet extends GetView<DiaryController> {
  const ManageFoodBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // double remainingCalories = calorieTarget - caloriesConsumed + caloriesBurned;
    // double remainingCalories = 1001;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFoodBottomSheet(context), // Call search method
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Close button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Replace the slider with this Chip implementation
              Wrap(
                spacing: 4.0,
                runSpacing: 0.0,
                alignment: WrapAlignment.center,
                children: [
                  _buildMealTypeChip(context, MealType.UNKNOWN, Icons.all_inclusive, 'All'),
                  _buildMealTypeChip(
                      context, MealType.BREAKFAST, Icons.egg_alt_outlined, 'Breakfast'),
                  _buildMealTypeChip(context, MealType.LUNCH, Icons.lunch_dining, 'Lunch'),
                  _buildMealTypeChip(context, MealType.DINNER, Icons.dinner_dining, 'Dinner'),
                  _buildMealTypeChip(context, MealType.SNACK, Icons.fastfood, 'Snack'),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(
                height: 180,
                child: MacroCard(), // Use the new MacroCard widget
              ),
              const SizedBox(height: 16),
              const FoodCarousel(), // Use the new FoodCarousel widget
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeChip(BuildContext context, MealType type, IconData icon, String label) {
    return Obx(() => FilterChip(
          selected: controller.foodManager.value.filteredMealType.value == type,
          showCheckmark: false,
          avatar: Icon(
            icon,
            size: 18,
            color: controller.foodManager.value.filteredMealType.value == type
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: controller.foodManager.value.filteredMealType.value == type
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          onSelected: (bool selected) {
            if (selected) {
              controller.foodManager.value.filteredMealType.value = type;
              controller.foodManager.value.filterMealsByType(type);
            }
          },
        ));
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AddFoodBottomSheet();
      },
    );
  }
}
