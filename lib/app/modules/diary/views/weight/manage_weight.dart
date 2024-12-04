import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../controllers/diary_controller.dart';

class ManageWeightBottomSheet extends GetView<DiaryController> {
  const ManageWeightBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
                  value: controller.activityManager.value.weightWhole.value,
                  minValue: 70,
                  maxValue: 550,
                  onChanged: controller.activityManager.value.isWeightLogged.value
                      ? (value) {} // Empty function when weight is logged
                      : (value) => controller.activityManager.value.weightWhole.value =
                          value, // Update whole pounds
                ),
              ),
              const Text('.', style: TextStyle(fontSize: 24)), // Decimal point
              Obx(
                () => NumberPicker(
                  value: controller.activityManager.value.weightDecimal.value,
                  minValue: 0,
                  maxValue: 9,
                  onChanged: controller.activityManager.value.isWeightLogged.value
                      ? (value) {} // Empty function when weight is logged
                      : (value) => controller.activityManager.value.weightDecimal.value =
                          value, // Update decimal
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => FilledButton.icon(
              onPressed: controller.activityManager.value.isWeightLogged.value
                  ? null
                  : () async {
                      await controller.saveWeightToHealth(); // Call saveWeightToHealth
                      if (context.mounted) {
                        // Check if the widget is still mounted
                        Navigator.pop(context); // Close the bottom sheet
                      }
                    },
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
