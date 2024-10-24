import 'package:flutter/material.dart';
import 'package:zone2/app/models/food.dart';

class NutritionalCard extends StatelessWidget {
  final PlatformHealthMeal meal;

  const NutritionalCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNutrientRow('Total Calories', meal.totalCaloriesLabel),
            _buildSeparator(),
            _buildNutrientRow('Protein', meal.proteinLabel),
            _buildSeparator(),
            _buildNutrientRow('Total Carbs', meal.totalCarbsLabel),
            _buildNutrientRow('Fiber', meal.fiberLabel),
            _buildNutrientRow('Sugar', meal.sugarLabel),
            _buildNutrientRow('Total Fat', meal.totalFatLabel),
            _buildNutrientRow('Saturated', meal.saturatedLabel),
            _buildNutrientRow('Other', ''),
            _buildNutrientRow('Sodium', meal.sodiumLabel),
            _buildNutrientRow('Cholesterol', meal.cholesterolLabel),
            _buildNutrientRow('Potassium', meal.potassiumLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, textAlign: TextAlign.right),
      ],
    );
  }

  Widget _buildSeparator() {
    return const Divider();
  }
}
