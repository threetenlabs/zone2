import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food_detail.dart';
import 'package:zone2/app/modules/diary/views/food_search.dart';

class AddFoodBottomSheet extends GetView<DiaryController> {
  final double calorieTarget;
  final double caloriesConsumed;
  final double caloriesBurned;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatConsumed;

  const AddFoodBottomSheet({
    super.key,
    required this.calorieTarget,
    required this.caloriesConsumed,
    required this.caloriesBurned,
    required this.proteinConsumed,
    required this.carbsConsumed,
    required this.fatConsumed,
  });

  @override
  Widget build(BuildContext context) {
    double remainingCalories = calorieTarget - caloriesConsumed + caloriesBurned;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context), // Close the bottom sheet
              ),
            ),
            Card(
              elevation: 8, // Higher elevation for the top card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Remaining Calories: $remainingCalories',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    _buildProgressBar('Protein', proteinConsumed, 100), // Assuming 100g as target
                    _buildProgressBar('Carbs', carbsConsumed, 100), // Assuming 100g as target
                    _buildProgressBar('Fat', fatConsumed, 100), // Assuming 100g as target
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(context,
                icon: Icons.egg_alt_outlined,
                title: 'Add Breakfast',
                subtitle: 'Add Breakfast',
                iconColor: Colors.green,
                onTap: () => {
                      controller.selectedMealType.value = MealType.BREAKFAST,
                      _showAddFoodBottomSheet(context),
                    },
                isChecked: false),
            _buildActionCard(context,
                icon: Icons.lunch_dining,
                title: 'Add Lunch',
                subtitle: 'Add Lunch',
                iconColor: Colors.green,
                onTap: () => {
                      controller.selectedMealType.value = MealType.LUNCH,
                      _showAddFoodBottomSheet(context),
                    },
                isChecked: false),
            _buildActionCard(context,
                icon: Icons.dinner_dining,
                title: 'Add Dinner',
                subtitle: 'Add Dinner',
                iconColor: Colors.green,
                onTap: () => {
                      controller.selectedMealType.value = MealType.DINNER,
                      _showAddFoodBottomSheet(context),
                    },
                isChecked: false),
            _buildActionCard(context,
                icon: Icons.fastfood,
                title: 'Add Snacks',
                subtitle: 'Add Snacks',
                iconColor: Colors.green,
                onTap: () => {
                      controller.selectedMealType.value = MealType.SNACK,
                      _showAddFoodBottomSheet(context),
                    },
                isChecked: false),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double consumed, double target) {
    return Column(
      children: [
        Text('$label: $consumed g', style: const TextStyle(fontSize: 16)),
        LinearProgressIndicator(
          value: consumed / target,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color iconColor, // {{ edit_1 }}
      required VoidCallback onTap,
      required bool isChecked}) {
    // {{ edit_1 }}
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: isChecked ? const Icon(Icons.check_box) : null, // {{ edit_2 }}
      ),
    );
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
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
             Text(
               'Add ${controller.selectedMealType.value.toString().split('.').last}',
               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
             ),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add Calories button
                  ElevatedButton(
                    onPressed: () {
                      // Add your add calories logic here
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text('Add Calories'),
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
              // New button row
              
            ],
          ),
        );
      },
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const FoodSearchWidget(); // Use the new widget here
      },
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
                  controller.deleteFood(item.dateFrom, item.dateTo); // {{ edit_2 }}
                }
              },
              child: ListTile(
                title:
                    Text('Meal: ${nutritionHealthValue.name}'), // Assuming meal has a name property
                subtitle: Text(
                  'Calories: ${nutritionHealthValue.calories} | Protein: ${nutritionHealthValue.protein}g | '
                  'Fat: ${nutritionHealthValue.fat}g | Carbs: ${nutritionHealthValue.carbs}g', // Displaying nutritional info
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
}
