import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../controllers/diary_controller.dart';

class WaterBottomSheet extends GetView<DiaryController> {
  const WaterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Add Water Intake:', style: TextStyle(fontSize: 18)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterButton(context, 8, Icons.local_drink, '8 oz'),
              _buildWaterButton(context, 12, Icons.local_drink, '12 oz'),
              _buildWaterButton(context, 16.9, Icons.local_drink, '16.9 oz'),
              _buildWaterButton(context, 20, Icons.local_drink, '20 oz'),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => LinearProgressIndicator(
                value: controller.waterIntake.value / controller.waterGoal.value,
                minHeight: 10,
              )),
          Center(
              child: Text(
                  style: TextStyle(color: Theme.of(context).colorScheme.outline),
                  '${controller.waterIntake.value.toStringAsFixed(1)} of ${controller.waterGoal.value.toStringAsFixed(1)} oz')),
          const SizedBox(height: 16),
          _buildCustomWaterInput(context),
        ],
      ),
    );
  }

  Widget _buildWaterButton(BuildContext context, double ounces, IconData icon, String label) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () => controller.addWater(ounces),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            padding: const EdgeInsets.all(16),
            fixedSize: const Size(75, 75), // Fixed size
          ),
          child: Column(
            children: [
              Icon(icon),
              Text(label, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomWaterInput(BuildContext context) {
    return Column(
      children: [
        const Text('Add Custom Amount:', style: TextStyle(fontSize: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => NumberPicker(
                  value: controller.customWaterWhole.value,
                  minValue: 1,
                  maxValue: 100, // Adjust as needed
                  onChanged: (value) => controller.customWaterWhole.value = value, // Update whole
                )),
            const Text('.'),
            Obx(() => NumberPicker(
                  value: controller.customWaterDecimal.value,
                  minValue: 0,
                  maxValue: 9,
                  onChanged: (value) =>
                      controller.customWaterDecimal.value = value, // Update decimal
                )),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            final total =
                controller.customWaterWhole.value + (controller.customWaterDecimal.value / 10);
            controller.addWater(total);
            Navigator.pop(context); // Close the bottom sheet
          },
          child: const Text('Add Custom Amount'),
        ),
      ],
    );
  }
}
