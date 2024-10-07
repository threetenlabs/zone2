import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/views/add_food.dart';
import 'package:zone2/app/modules/diary/views/manage_water.dart';
import 'package:zone2/app/modules/diary/views/manage_weight.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getHealthDataForSelectedDay();
    return Scaffold(
      body: SafeArea(
        child: Column(
          // {{ edit_2 }}
          children: [
            Obx(() => _buildDateNavigation()), // Add date navigation component
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Obx(
                    () => _buildDiaryCard(
                      context,
                      icon: Ionicons.scale,
                      title: 'Log Weight',
                      subtitle: 'Track your weight progress',
                      iconColor: Theme.of(context).colorScheme.primary,
                      isChecked: controller.isWeightLogged.value,
                      onTap: () => _showWeightBottomSheet(context),
                    ),
                  ),
                  _buildDiaryCard(
                    context,
                    icon: Icons.fastfood,
                    title: 'Add Food', // New card for adding food
                    subtitle: 'Log your meals and snacks',
                    iconColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => _showAddFoodBottomSheet(context), // Show the new bottom sheet
                    isChecked: controller.isWeightLogged.value,
                  ),
                  _buildDiaryCard(
                    context,
                    icon: Icons.run_circle,
                    title: 'Zone 2',
                    subtitle: 'Monitor your Zone 2 training',
                    iconColor: Theme.of(context).colorScheme.tertiary, // {{ edit_5 }}
                    onTap: () => _showBottomSheet(context, 'Zone 2'),
                    isChecked: controller.isWeightLogged.value,
                  ),
                  Obx(
                    () => _buildDiaryCard(context,
                        icon: Icons.local_drink,
                        title: 'Hydration',
                        subtitle: 'Keep track of your water intake',
                        iconColor: Theme.of(context).colorScheme.tertiary, // {{ edit_6 }}
                        onTap: () => _showWaterBottomSheet(context),
                        isChecked: controller.isWaterLogged.value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.navigateToPreviousDay();
          },
        ),
        const SizedBox(width: 8), // Add spacing between arrow and date
        Obx(() => Text(controller.diaryDateLabel.value, style: const TextStyle(fontSize: 20))),
        const SizedBox(width: 8), // Add spacing between date and forward arrow
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: controller.isToday(controller.diaryDate.value)
              ? null
              : () {
                  controller.navigateToNextDay(); // Call the new method
                },
        ),
      ],
    );
  }

  Widget _buildDiaryCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color iconColor,
      required VoidCallback onTap,
      required bool isChecked}) {
    debugPrint('isChecked: $isChecked');
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: onTap,
          trailing: isChecked ? Icon(icon, color: iconColor) : null,
        ));
  }

  void _showWeightBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ManageWeightBottomSheet(),
    );
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AddFoodBottomSheet(
          calorieTarget: 2000, // Example target
          caloriesConsumed: 1200, // Example consumed
          caloriesBurned: 300, // Example burned
          proteinConsumed: 80, // Example protein
          carbsConsumed: 150, // Example carbs
          fatConsumed: 50, // Example fat
        );
      },
    );
  }

  void _showWaterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const WaterBottomSheet(),
    );
  }

  void _showBottomSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Bottom sheet for $title'),
        );
      },
    );
  }
}
