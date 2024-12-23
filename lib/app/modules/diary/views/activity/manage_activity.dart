import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/activity/widgets/calories.dart';
import 'package:zone2/app/modules/diary/views/activity/widgets/steps.dart';
import 'package:zone2/app/modules/diary/views/activity/widgets/zone.dart';

class ManageActivityBottomSheet extends GetView<DiaryController> {
  const ManageActivityBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Close button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Wrap the cards in Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Your Zone 2 Activity', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 16),
                      ActiveZoneMinutesRadialChart(),
                      SizedBox(height: 16),
                      CaloriesBurnedChart(),
                      SizedBox(height: 16),
                      StepsChart(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildProgressBar(String label, double consumed, double target) {
  //   return Column(
  //     children: [
  //       Text('$label: $consumed g', style: const TextStyle(fontSize: 16)),
  //       LinearProgressIndicator(
  //         value: consumed / target,
  //         minHeight: 10,
  //       ),
  //       const SizedBox(height: 8),
  //     ],
  //   );
  // }

  // void _showFoodBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     barrierColor: Colors.transparent,
  //     context: context,
  //     enableDrag: false,
  //     isScrollControlled: true, // Allow full screen
  //     useSafeArea: true,
  //     builder: (context) {
  //       return const ShowFoodBottomSheet();
  //     },
  //   );
  // }
}
