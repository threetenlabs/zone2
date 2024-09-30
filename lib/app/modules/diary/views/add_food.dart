import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              onTap: () => _showSearchBottomSheet(context), // {{ edit_1 }}
              isChecked: false),
          _buildActionCard(context,
              icon: Icons.lunch_dining,
              title: 'Add Lunch',
              subtitle: 'Add Lunch',
              iconColor: Colors.green,
              onTap: () {},
              isChecked: false),
          _buildActionCard(context,
              icon: Icons.dinner_dining,
              title: 'Add Dinner',
              subtitle: 'Add Dinner',
              iconColor: Colors.green,
              onTap: () {},
              isChecked: false),
          _buildActionCard(context,
              icon: Icons.fastfood,
              title: 'Add Snacks',
              subtitle: 'Add Snacks',
              iconColor: Colors.green,
              onTap: () {},
              isChecked: false),
        ],
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

  void _showSearchBottomSheet(BuildContext context) {
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
                  controller.searchFood(value); // {{ edit_1 }}
                  // Navigator.pop(context); // Close the bottom sheet
                },
              ),
              const SizedBox(height: 16),
              // Check if foodSearchResponse has a value
              Obx(() {
                // {{ edit_1 }}
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
                          onTap: () {
                            // Handle food item tap
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Text('No results found'); // Handle no results
                }
              }), // {{ edit_2 }}
            ],
          ),
        );
      },
    );
  }
}
