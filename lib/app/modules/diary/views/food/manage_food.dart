import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/show_food.dart';

class ManageFoodBottomSheet extends GetView<DiaryController> {
  final double calorieTarget;
  final double caloriesConsumed;
  final double caloriesBurned;
  final double proteinConsumed;
  final double carbsConsumed;
  final double fatConsumed;

  const ManageFoodBottomSheet({
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

    return Scaffold(
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
                        _showFoodBottomSheet(context),
                      },
                  isChecked: false),
              _buildActionCard(context,
                  icon: Icons.lunch_dining,
                  title: 'Add Lunch',
                  subtitle: 'Add Lunch',
                  iconColor: Colors.green,
                  onTap: () => {
                        controller.selectedMealType.value = MealType.LUNCH,
                        _showFoodBottomSheet(context),
                      },
                  isChecked: false),
              _buildActionCard(context,
                  icon: Icons.dinner_dining,
                  title: 'Add Dinner',
                  subtitle: 'Add Dinner',
                  iconColor: Colors.green,
                  onTap: () => {
                        controller.selectedMealType.value = MealType.DINNER,
                        _showFoodBottomSheet(context),
                      },
                  isChecked: false),
              _buildActionCard(context,
                  icon: Icons.fastfood,
                  title: 'Add Snacks',
                  subtitle: 'Add Snacks',
                  iconColor: Colors.green,
                  onTap: () => {
                        controller.selectedMealType.value = MealType.SNACK,
                        _showFoodBottomSheet(context),
                      },
                  isChecked: false),
            ],
          ),
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

  void _showFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const ShowFoodBottomSheet();
      },
    );
  }
}
