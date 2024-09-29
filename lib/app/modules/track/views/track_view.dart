import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';

class TrackView extends GetView<TrackController> {
  const TrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Track'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Weight'),
              Tab(text: 'Food'),
              Tab(text: 'Hydration'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [WeightTab(), WeightTab(), WeightTab()],
        ),
      ),
    );
  }
}
