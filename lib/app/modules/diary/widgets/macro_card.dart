import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class MacroCard extends GetView<DiaryController> {
  const MacroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 75, // Example height
            child: _buildCalorieRow(),
          ),
          SizedBox(
            height: 75, // Example height
            child: _buildMacroRow(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieRow() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTargetColumn(
              'Target', controller.zone2User.value?.zoneSettings?.dailyCalorieIntakeGoal ?? 2000),
          _buildTargetColumn('Consumed', controller.foodManager.value.totalCalories.value),
          _buildTargetColumn('Burned', controller.activityManager.value.totalCaloriesBurned.value),
          _buildRemainingColumn(
              'Remaining',
              (controller.zone2User.value?.zoneSettings?.dailyCalorieIntakeGoal ?? 2000) +
                  controller.activityManager.value.totalCaloriesBurned.value -
                  controller.foodManager.value.totalCalories.value),
        ],
      ),
    );
  }

  Widget _buildMacroRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildMacroColumn('Protein', 0.5, Colors.blue, '50%'),
        _buildMacroColumn('Carbs', 0.7, Colors.green, '70%'),
        _buildMacroColumn('Fat', 0.3, Colors.red, '30%'),
        _buildMacroColumn('Calories', 0.6, Colors.yellow, '60%'),
      ],
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
        Text(value.toStringAsFixed(1)),
        Text(label),
      ],
    );
  }

  Widget _buildRemainingColumn(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value.toStringAsFixed(1)),
        Text(label),
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
