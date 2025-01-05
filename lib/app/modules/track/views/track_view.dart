import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';
import 'package:zone2/app/modules/track/views/zone_point_tab.dart';
import 'package:zone2/app/modules/track/views/step_tab.dart';
import 'package:zone2/app/services/health_service.dart';

class TrackView extends GetView<TrackController> {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a map of labels to TimeFrame values
    final Map<String, TimeFrame> labelToTimeFrame = {
      'Week': TimeFrame.week,
      'Month': TimeFrame.month,
      'Journey': TimeFrame.allTime,
    };

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Weight'),
              Tab(text: 'Zone Points'),
              Tab(text: 'Steps'),
            ],
          ),
        ),
        body: Column(
          children: [
            Obx(() {
              return Wrap(
                spacing: 10.0,
                children: labelToTimeFrame.entries.map((entry) {
                  return FilterChip(
                    showCheckmark: false,
                    label: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 12,
                        color: controller.selectedTimeFrame.value == entry.value
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    selected: controller.selectedTimeFrame.value == entry.value,
                    onSelected: (bool selected) {
                      if (selected) {
                        controller.selectedTimeFrame.value = entry.value;
                        controller.applyFilter();
                      }
                    },
                  );
                }).toList(),
              );
            }),
            const Expanded(
              child: TabBarView(
                children: [WeightTab(), ZonePointsTab(), StepTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
