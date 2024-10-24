import 'package:flutter/material.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/widgets/nutritional_card.dart';

enum ConversionType {
  usda,
  health,
}

class FoodDetailBottomSheet extends GetView<DiaryController> {
  final ConversionType conversionType;
  const FoodDetailBottomSheet({super.key, required this.conversionType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Rounded top corners
      ),
      child: SingleChildScrollView(
        // Wrap the content in a scrollable view
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.selectedFood.value?.description ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Brand: ${controller.selectedFood.value?.brandOwner ?? ''}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            _buildNutritionalCard(),
            const SizedBox(height: 16),
            _buildAddToMealSection(context),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Use GetX to close the bottom sheet
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalCard() {
    final meal = conversionType == ConversionType.usda
        ? PlatformHealthMeal.fromUsdaFood(
            controller.selectedFood.value!, controller.selectedMealType.value)
        : PlatformHealthMeal.fromHealthDataPoint(controller.selectedHealthMeal.value!);

    controller.selectedMeal.value = meal;

    return NutritionalCard(meal: meal);
  }

  Widget _buildAddToMealSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add to Meal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Numeric input for serving count
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Qty',
                    ),
                    onChanged: (value) {
                      controller.foodServingQty.value = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                // Read-only label for serving size
                Text(
                  controller.selectedFood.value?.servingSizeUnit.isNotEmpty ?? false
                      ? '${controller.selectedFood.value?.householdServingFullText}'
                      : 'Serving',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.saveMealToHealth();
                Navigator.pop(context);
              },
              child: const Text('Add to Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
