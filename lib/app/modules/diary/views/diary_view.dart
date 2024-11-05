import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/views/activity/manage_activity.dart';
import 'package:zone2/app/modules/diary/views/food/manage_food.dart';
import 'package:zone2/app/modules/diary/views/water/manage_water.dart';
import 'package:zone2/app/modules/diary/views/weight/manage_weight.dart';
import 'package:ionicons/ionicons.dart';
import 'package:zone2/app/style/theme.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getHealthDataForSelectedDay();
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Obx(() => _buildDateNavigation()), // Add date navigation component
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Obx(
                    () => _buildDiaryCard(
                      context,
                      icon: Ionicons.scale,
                      title: 'Record Weight',
                      subtitle: 'Track your weight progress',
                      iconColor: Theme.of(context).colorScheme.primary,
                      isChecked: controller.isWeightLogged.value,
                      onTap: () => _showWeightBottomSheet(context),
                    ),
                  ),
                  _buildDiaryCard(
                    context,
                    icon: Icons.fastfood,
                    title: 'Track Meals',
                    subtitle: 'Log your meals and snacks',
                    iconColor: Theme.of(context).colorScheme.secondary,
                    onTap: () => _showAddFoodBottomSheet(context),
                    isChecked: controller.isWeightLogged.value,
                  ),
                  _buildDiaryCard(
                    context,
                    icon: Icons.run_circle,
                    title: 'Monitor Activity',
                    subtitle: 'Monitor your Zone Minutes',
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onTap: () => _showManageActivityBottomSheet(context),
                    isChecked: controller.isWeightLogged.value,
                  ),
                  Obx(
                    () => _buildDiaryCard(context,
                        icon: Icons.local_drink,
                        title: 'Track Hydration',
                        subtitle: 'Keep track of your water intake',
                        iconColor: Theme.of(context).colorScheme.tertiary,
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
          trailing: isChecked ? Icon(Icons.check, color: MaterialTheme.coolBlue.value) : null,
        ));
  }

  void _showWeightBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) => const ManageWeightBottomSheet(),
    );
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const ManageFoodBottomSheet();
      },
    );
  }

  void _showManageActivityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const ManageActivityBottomSheet();
      },
    );
  }

  void _showWaterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) => const WaterBottomSheet(),
    );
  }
}
