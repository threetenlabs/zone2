import 'package:flutter/material.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/services/food_service.dart'; // Import your Food model
import 'package:get/get.dart'; // Import GetX package

class FoodDetailBottomSheet extends GetView<DiaryController> {
  const FoodDetailBottomSheet({super.key});

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
    List<dynamic> energyInfo = _getNutrientInfo('Energy');
    List<dynamic> proteinInfo = _getNutrientInfo('Protein');
    List<dynamic> carbsInfo = _getNutrientInfo('Carbohydrate, by difference');
    List<dynamic> fiberInfo = _getNutrientInfo('Fiber, total dietary');
    List<dynamic> sugarInfo = _getNutrientInfo('Sugars, Total');
    List<dynamic> fatInfo = _getNutrientInfo('Total lipid (fat)');
    List<dynamic> saturatedInfo = _getNutrientInfo('Fatty acids, total saturated');
    List<dynamic> sodiumInfo = _getNutrientInfo('Sodium, Na');
    List<dynamic> cholesterolInfo = _getNutrientInfo('Cholesterol');
    List<dynamic> potassiumInfo = _getNutrientInfo('Potassium, K');

    // Create a Meal instance
    PlatformHealthMeal meal = PlatformHealthMeal(
      name: controller.selectedFood.value?.description ?? '',
      // Store nutrient info in variables to avoid multiple calls

      totalCaloriesLabel: energyInfo[0],
      totalCaloriesValue: energyInfo[1],
      proteinLabel: proteinInfo[0],
      proteinValue: proteinInfo[1],
      totalCarbsLabel: carbsInfo[0],
      totalCarbsValue: carbsInfo[1],
      fiberLabel: fiberInfo[0],
      fiberValue: fiberInfo[1],
      sugarLabel: sugarInfo[0],
      sugarValue: sugarInfo[1],
      totalFatLabel: fatInfo[0],
      totalFatValue: fatInfo[1],
      saturatedLabel: saturatedInfo[0],
      saturatedValue: saturatedInfo[1],
      sodiumLabel: sodiumInfo[0],
      sodiumValue: sodiumInfo[1],
      cholesterolLabel: cholesterolInfo[0],
      cholesterolValue: cholesterolInfo[1],
      potassiumLabel: potassiumInfo[0],
      potassiumValue: potassiumInfo[1],
    );

    controller.selectedMeal.value = meal;

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
            _buildSeparator(),
            _buildNutrientRow('Total Fat', meal.totalFatLabel),
            _buildNutrientRow('Saturated', meal.saturatedLabel),
            _buildSeparator(),
            _buildNutrientRow('Other', ''),
            _buildNutrientRow('Sodium', meal.sodiumLabel),
            _buildNutrientRow('Cholesterol', meal.cholesterolLabel),
            _buildNutrientRow('Potassium', meal.potassiumLabel),
          ],
        ),
      ),
    );
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

  List<dynamic> _getNutrientInfo(String nutrientName) {
    final nutrient = controller.selectedFood.value?.foodNutrients.firstWhere(
      (n) => n.name == nutrientName,
      orElse: () => UsdaFoodNutrient(name: nutrientName, amount: 0, unitName: ''),
    );

    var unit = nutrient?.unitName.toLowerCase();
    var value = nutrient?.amount ?? 0.0;
    var displayValue = value;

    // Convert mg to g (grams) if unitName is 'mg'
    if (unit == 'mg') {
      value = (value / 1000).roundToDouble();
      if (value > 1000) {
        displayValue = (displayValue / 1000).roundToDouble();
        unit = 'g';
      }
    }

    // Convert kj to kcal
    if (unit == 'kj') {
      value = (value / 4.184).roundToDouble();
      displayValue = (displayValue / 4.184).roundToDouble();
      unit = 'kcal';
    }

    return ['${displayValue.toString()} $unit', value];
  }
}
