import 'package:flutter/material.dart';
import 'package:zone2/app/services/food_service.dart'; // Import your Food model

class FoodDetailBottomSheet extends StatefulWidget {
  final Food food; // Assuming Food is your model class for food items

  const FoodDetailBottomSheet({Key? key, required this.food}) : super(key: key);

  @override
  _FoodDetailBottomSheetState createState() => _FoodDetailBottomSheetState();
}

class _FoodDetailBottomSheetState extends State<FoodDetailBottomSheet> {
  int servingCount = 1; // Default serving count

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
            Text(widget.food.description,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Brand: ${widget.food.brandOwner}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            _buildNutritionalCard(),
            const SizedBox(height: 16),
            _buildAddToMealSection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Close the bottom sheet
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNutrientRow('Total Calories', _getNutrientValue('Total lipid (fat)')),
            _buildSeparator(),
            _buildNutrientRow('Protein', _getNutrientValue('Protein')),
            _buildSeparator(),
            _buildNutrientRow('Total Carbs', _getNutrientValue('Carbohydrate, by difference')),
            _buildNutrientRow('Fiber', _getNutrientValue('Fiber, total dietary')),
            _buildNutrientRow('Sugar', _getNutrientValue('Sugars, Total')),
            _buildSeparator(),
            _buildNutrientRow('Total Fat', _getNutrientValue('Total lipid (fat)')),
            _buildNutrientRow('Saturated', _getNutrientValue('Fatty acids, total saturated')),
            _buildSeparator(),
            _buildNutrientRow('Other', ''),
            _buildNutrientRow('Sodium', _getNutrientValue('Sodium, Na')),
            _buildNutrientRow('Cholesterol', _getNutrientValue('Cholesterol')),
            _buildNutrientRow('Potassium', _getNutrientValue('Potassium, K')),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToMealSection() {
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
                      hintText: '1',
                    ),
                    onChanged: (value) {
                      setState(() {
                        servingCount = int.tryParse(value) ?? 1; // Update serving count
                      });
                    },
                  ),
                ),
                // Read-only label for serving size
                Text(
                  widget.food.servingSizeUnit.isNotEmpty
                      ? '${widget.food.servingSize} ${widget.food.servingSizeUnit.toLowerCase()}'
                      : 'Serving',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle adding to meal logic here
                debugPrint('Added $servingCount servings of ${widget.food.description} to meal.');
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

  String _getNutrientValue(String nutrientName) {
    final nutrient = widget.food.foodNutrients.firstWhere(
      (n) => n.name == nutrientName,
      orElse: () => FoodNutrient(name: nutrientName, amount: 0, unitName: ''),
    );
    return '${nutrient.amount} ${nutrient.unitName.toLowerCase()}';
  }
}
