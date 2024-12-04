import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
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
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 200,
                    value: controller.dailyWaterGoal.value.toDouble(),
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
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 500,
                    value: controller.zone2FatTarget.value,
                    decimals: 0,
                    step: 1,
                    acceleration: 1.5,
                    onChanged: (value) {
                      controller.setZone2FatTarget(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fat Target (g)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 5000,
                    value: controller.dailyCalorieIntakeGoal.value,
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
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 500,
                    value: controller.zone2ProteinTarget.value,
                    decimals: 0,
                    step: 1,
                    acceleration: 1.5,
                    onChanged: (value) {
                      controller.setZone2ProteinTarget(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Protein Target (g)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 50000,
                    value: controller.dailyStepsGoal.value.toDouble(),
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
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 500,
                    value: controller.zone2CarbsTarget.value,
                    decimals: 0,
                    step: 1,
                    acceleration: 1.5,
                    onChanged: (value) {
                      controller.setZone2CarbsTarget(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Carbs Target (g)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SpinBox(
                    min: 0,
                    max: 200,
                    value: controller.dailyZonePointsGoal.value.toDouble(),
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
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: () async {
                          const url = 'https://tdeecalculator.net';
                          await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
                        },
                        child: const Text('Macro Calculator'),
                      ))),
            ],
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
