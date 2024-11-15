import 'package:flutter/material.dart';

class FoodCarouselCard extends StatelessWidget {
  const FoodCarouselCard(
      {super.key,
      required this.index,
      required this.label,
      required this.calories,
      required this.protein,
      required this.fat,
      required this.carbs});

  final int index;
  final String label;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Calories: ${calories.toStringAsFixed(1)} kcal',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Protein: ${protein.toStringAsFixed(1)} g',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Fat: ${fat.toStringAsFixed(1)} g',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Carbs: ${carbs.toStringAsFixed(1)} g',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Tap To View Details',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
