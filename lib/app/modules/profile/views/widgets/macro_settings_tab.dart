import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:zone2/app/modules/profile/controllers/profile_controller.dart';

class MacroSettingsTab extends GetWidget<ProfileController> {
  const MacroSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SpinBox(
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
          const SizedBox(height: 20),
          SpinBox(
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
          const SizedBox(height: 20),
          SpinBox(
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
        ],
      ),
    );
  }
}
