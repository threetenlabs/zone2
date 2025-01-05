import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:zone2/app/modules/diary/views/activity/manage_activity.dart';
import 'package:zone2/app/modules/diary/views/food/manage_food.dart';
import 'package:zone2/app/modules/diary/views/water/manage_water.dart';
import 'package:zone2/app/modules/diary/views/weight/manage_weight.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/diary_controller.dart';

class DiaryView extends GetView<DiaryController> {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Obx(() => _buildDateNavigation(context)), // Date navigation at the top
            const SizedBox(height: 16),
            Spacer(), // Pushes the content to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0), // Add padding at the bottom
              child: Column(
                children: [
                  Obx(
                    () => Skeletonizer(
                      enabled: controller.isLoadingWeightData.value,
                      child: _buildDiaryCard(
                        context,
                        icon: Symbols.monitor_weight_gain,
                        title: 'My weight',
                        subtitle: 'Track your weight progress',
                        isChecked: controller.activityManager.value.isWeightLogged.value,
                        onTap: () => _showWeightBottomSheet(context),
                      ),
                    ),
                  ),
                  Obx(
                    () => Skeletonizer(
                      enabled: controller.isLoadingNutritionData.value,
                      child: _buildDiaryCard(
                        context,
                        icon: Symbols.skillet,
                        title: 'My nutrition',
                        subtitle: 'Log your meals and snacks',
                        onTap: () => _showAddFoodBottomSheet(context),
                        isChecked: controller.foodManager.value.isFoodLogged.value,
                      ),
                    ),
                  ),
                  Obx(
                    () => Skeletonizer(
                      enabled: controller.isLoadingActivityData.value,
                      child: _buildDiaryCard(
                        context,
                        icon: Symbols.directions_run,
                        title: 'My activity',
                        subtitle: 'Monitor your Zone Minutes',
                        onTap: () => _showManageActivityBottomSheet(context),
                        isChecked: controller.activityManager.value.isActivityLogged.value,
                      ),
                    ),
                  ),
                  Obx(
                    () => Skeletonizer(
                      enabled: controller.isLoadingWaterData.value,
                      child: _buildDiaryCard(
                        context,
                        icon: Symbols.water_drop,
                        title: 'My hydration',
                        subtitle: 'Keep track of your water intake',
                        onTap: () => _showWaterBottomSheet(context),
                        isChecked: controller.isWaterLogged.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row
      children: [
        FilledButton.icon(
          icon: Icon(Ionicons.chevron_back_outline, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            controller.navigateToPreviousDay();
          },
          label: Container(),
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.surfaceContainerHigh),
            padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(4)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
              ),
            ),
          ),
        ),
        const SizedBox(width: 48), // Add spacing between arrow and date
        Obx(() => Text(controller.diaryDateLabel.value, style: const TextStyle(fontSize: 20))),
        const SizedBox(width: 48), // Add spacing between date and forward arrow
        FilledButton.icon(
          icon: Icon(Ionicons.chevron_forward_outline,
              color: controller.isToday(controller.diaryDate.value)
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onSurface),
          onPressed: controller.isToday(controller.diaryDate.value)
              ? null
              : () {
                  controller.navigateToNextDay(); // Call the new method
                },
          label: Container(),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
                controller.isToday(controller.diaryDate.value)
                    ? Theme.of(context).colorScheme.surfaceContainerHigh.withOpacity(0.5)
                    : Theme.of(context).colorScheme.surfaceContainerHigh),
            padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(4)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDiaryCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      required bool isChecked}) {
    return Card(
        margin:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0), // Add horizontal padding
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // More rounded corners
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(fontSize: 28),
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          onTap: onTap,
          trailing: isChecked
              ? Icon(
                  Symbols.verified,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
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
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) => const WaterBottomSheet(),
    );
  }
}
