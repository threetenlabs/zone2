import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

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
                    () => _buildCard(
                      context,
                      icon: Icons.scale,
                      title: 'Log Weight',
                      subtitle: 'Track your weight progress',
                      iconColor: Theme.of(context).colorScheme.primary, // {{ edit_3 }}
                      onTap: () => _showWeightBottomSheet(context), // {{ edit_1 }}
                      isChecked: controller.isWeightLogged.value, // Pass the checkbox state
                    ),
                  ),
                  _buildCard(
                    context,
                    icon: Icons.fastfood,
                    title: 'Log Meals',
                    subtitle: 'Record your meals',
                    iconColor: Theme.of(context).colorScheme.secondary, // {{ edit_4 }}
                    onTap: () => _showBottomSheet(context, 'Log Meals'),
                    isChecked: false,
                  ),
                  _buildCard(
                    context,
                    icon: Icons.run_circle,
                    title: 'Zone 2',
                    subtitle: 'Monitor your Zone 2 training',
                    iconColor: Theme.of(context).colorScheme.tertiary, // {{ edit_5 }}
                    onTap: () => _showBottomSheet(context, 'Zone 2'),
                    isChecked: false,
                  ),
                  _buildCard(
                    context,
                    icon: Icons.local_drink,
                    title: 'Hydration',
                    subtitle: 'Keep track of your water intake',
                    iconColor: Theme.of(context).colorScheme.tertiary, // {{ edit_6 }}
                    onTap: () => _showBottomSheet(context, 'Hydration'),
                    isChecked: false,
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
    // {{ edit_3 }}

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

  Widget _buildCard(BuildContext context,
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

  void _showWeightBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select your weight in pounds:', style: TextStyle(fontSize: 18)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => NumberPicker(
                      value: controller.weightWhole.value,
                      minValue: 70,
                      maxValue: 550,
                      onChanged: (value) =>
                          controller.weightWhole.value = value, // Update whole pounds
                    ),
                  ),
                  const Text('.', style: TextStyle(fontSize: 24)), // Decimal point
                  Obx(
                    () => NumberPicker(
                      value: controller.weightDecimal.value,
                      minValue: 0,
                      maxValue: 9,
                      onChanged: (value) =>
                          controller.weightDecimal.value = value, // Update decimal
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.saveWeightToHealth(); // Call saveWeightToHealth
                  if (context.mounted) {
                    // Check if the widget is still mounted
                    Navigator.pop(context); // Close the bottom sheet
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        );
      },
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
