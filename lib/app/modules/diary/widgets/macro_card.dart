import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/style/theme.dart';

class MacroCard extends GetView<DiaryController> {
  const MacroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiaryController>(
      init: controller,
      builder: (c) => Card(
        elevation: 8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 75, // Example height
                child: _buildCalorieRow(context),
              ),
              SizedBox(
                height: 75, // Example height
                child: _buildMacroRow(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieRow(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTargetColumn('Target',
              controller.zone2User.value.zoneSettings?.dailyCalorieIntakeGoal.round() ?? 2000),
          Center(child: Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          _buildTargetColumn('Consumed', controller.foodManager.value.totalCalories.value.round()),
          Center(child: Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          _buildTargetColumn(
              'Burned', controller.activityManager.value.totalWorkoutCalories.value.round()),
          Center(child: Text('=', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          _buildRemainingColumn(
              'Remaining',
              ((controller.zone2User.value?.zoneSettings?.dailyCalorieIntakeGoal ?? 2000) -
                      (controller.foodManager.value.totalCalories.value) +
                      controller.activityManager.value.totalWorkoutCalories.value)
                  .roundToDouble(),
              context),
        ],
      ),
    );
  }

  Widget _buildMacroRow(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildMacroColumn(
            'Protein',
            controller.foodManager.value.totalProteinTarget.value != 0
                ? controller.foodManager.value.totalProtein.value /
                    controller.foodManager.value.totalProteinTarget.value
                : 0.0,
            MaterialTheme.coolBlue.value,
            controller.foodManager.value.totalProteinTarget.value != 0
                ? '${(controller.foodManager.value.totalProtein.value / controller.foodManager.value.totalProteinTarget.value * 100).toStringAsFixed(0)}%'
                : '0%',
          ),
          _buildMacroColumn(
            'Carbs',
            controller.foodManager.value.totalCarbohydratesTarget.value != 0
                ? controller.foodManager.value.totalCarbohydrates.value /
                    controller.foodManager.value.totalCarbohydratesTarget.value
                : 0.0,
            MaterialTheme.coolOrange.value,
            controller.foodManager.value.totalCarbohydratesTarget.value != 0
                ? '${(controller.foodManager.value.totalCarbohydrates.value / controller.foodManager.value.totalCarbohydratesTarget.value * 100).toStringAsFixed(0)}%'
                : '0%',
          ),
          _buildMacroColumn(
            'Fat',
            controller.foodManager.value.totalFatTarget.value != 0
                ? controller.foodManager.value.totalFat.value /
                    controller.foodManager.value.totalFatTarget.value
                : 0.0,
            MaterialTheme.coolRed.value,
            controller.foodManager.value.totalFatTarget.value != 0
                ? '${(controller.foodManager.value.totalFat.value / controller.foodManager.value.totalFatTarget.value * 100).toStringAsFixed(0)}%'
                : '0%',
          ),
        ],
      ),
    );
  }

  Widget _buildTargetColumn(
    String label,
    dynamic value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value.round().toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildRemainingColumn(String label, double value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value.round().toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(label,
            style: TextStyle(fontSize: 10, color: const Color.fromARGB(255, 130, 129, 129))),
      ],
    );
  }

  Widget _buildMacroColumn(String label, double value, Color color, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        SizedBox(
          width: 75, // Set a fixed width
          child: LinearProgressIndicator(
            value: value, // Example value
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text(percentage),
      ],
    );
  }
}
