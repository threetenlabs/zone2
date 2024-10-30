import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class NutritionalCard extends GetView<DiaryController> {
  const NutritionalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNutrientRow(
                  'Total Calories', controller.selectedZone2Food.value?.totalCaloriesLabel ?? ''),
              _buildSeparator(),
              _buildNutrientRow('Protein', controller.selectedZone2Food.value?.proteinLabel ?? ''),
              _buildSeparator(),
              _buildNutrientRow(
                  'Total Carbs', controller.selectedZone2Food.value?.totalCarbsLabel ?? ''),
              _buildNutrientRow('Fiber', controller.selectedZone2Food.value?.fiberLabel ?? ''),
              _buildNutrientRow('Sugar', controller.selectedZone2Food.value?.sugarLabel ?? ''),
              _buildNutrientRow(
                  'Total Fat', controller.selectedZone2Food.value?.totalFatLabel ?? ''),
              _buildNutrientRow(
                  'Saturated', controller.selectedZone2Food.value?.saturatedLabel ?? ''),
              _buildNutrientRow('Other', ''),
              _buildNutrientRow('Sodium', controller.selectedZone2Food.value?.sodiumLabel ?? ''),
              _buildNutrientRow(
                  'Cholesterol', controller.selectedZone2Food.value?.cholesterolLabel ?? ''),
              _buildNutrientRow(
                  'Potassium', controller.selectedZone2Food.value?.potassiumLabel ?? ''),
            ],
          ),
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
