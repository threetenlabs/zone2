import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food_detail.dart';

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
              // Button to open search bottom sheet
              ElevatedButton(
                onPressed: () => _showSearchBottomSheet(context), // {{ edit_1 }}
                child: const Text('Search for Food'),
              ),
              const SizedBox(height: 16),
              _buildMealList(), // Keep the meal list here
            ],
          ),
        );
      },
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    // {{ edit_2 }}
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
      },
    );
  }

  Widget _buildMealList() {
    // {{ edit_1 }}
    return Obx(() {
      if (controller.mealData.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.mealData.length,
          itemBuilder: (context, index) {
            final item = controller.mealData[index];
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
