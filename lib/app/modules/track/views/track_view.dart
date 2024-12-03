import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';
import 'package:zone2/app/modules/track/views/zone_point_tab.dart';
import 'package:zone2/app/modules/track/views/step_tab.dart';

class TrackView extends GetView<TrackController> {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Weight'),
              Tab(text: 'Calories'),
              Tab(text: 'Steps'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [WeightTab(), ZonePointsTab(), StepTab()],
        ),
      ),
    );
  }
}
