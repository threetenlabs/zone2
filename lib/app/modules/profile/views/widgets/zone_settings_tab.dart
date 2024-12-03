import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class ZoneSettingsTab extends GetWidget<ProfileController> {
  const ZoneSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          SpinBox(
            min: 0,
            max: 200,
            value: controller.dailyWaterGoalController.text.isNotEmpty
                ? double.parse(controller.dailyWaterGoalController.text)
                : 0,
            decimals: 0,
            step: 1,
            onChanged: (value) {
              controller.setDailyWaterGoal(value.toInt());
            },
            decoration: const InputDecoration(
              labelText: 'Daily Water Goal (oz)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SpinBox(
            min: 0,
            max: 200,
            value: controller.dailyZonePointsGoalController.text.isNotEmpty
                ? double.parse(controller.dailyZonePointsGoalController.text)
                : 0,
            decimals: 0,
            step: 1,
            onChanged: (value) {
              controller.setDailyZonePointsGoal(value.toInt());
            },
            decoration: const InputDecoration(
              labelText: 'Daily Zone Points Goal',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SpinBox(
            min: 0,
            max: 5000,
            value: controller.dailyCalorieIntakeGoalController.text.isNotEmpty
                ? double.parse(controller.dailyCalorieIntakeGoalController.text)
                : 0,
            decimals: 0,
            step: 1,
            onChanged: (value) {
              controller.setDailyCalorieIntakeGoal(value);
            },
            decoration: const InputDecoration(
              labelText: 'Daily Calorie Intake Goal',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SpinBox(
            min: 0,
            max: 5000,
            value: controller.dailyCaloriesBurnedGoalController.text.isNotEmpty
                ? double.parse(controller.dailyCaloriesBurnedGoalController.text)
                : 0,
            decimals: 0,
            step: 1,
            onChanged: (value) {
              controller.setDailyCaloriesBurnedGoal(value);
            },
            decoration: const InputDecoration(
              labelText: 'Daily Calories Burned Goal',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SpinBox(
            min: 0,
            max: 50000,
            value: controller.dailyStepsGoalController.text.isNotEmpty
                ? double.parse(controller.dailyStepsGoalController.text)
                : 0,
            decimals: 0,
            step: 1,
            acceleration: 1.5,
            onChanged: (value) {
              controller.setDailyStepsGoal(value.toInt());
            },
            decoration: const InputDecoration(
              labelText: 'Daily Steps Goal',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isDirty.value ? controller.saveSettings : null,
                child: const Text('Save Settings'),
              )),
        ],
      ),
    );
  }
}
