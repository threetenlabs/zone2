import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart'; // Import GetX for controller access
import 'package:intl/intl.dart'; // Add this import

// Define an enum for time frames

class WeightTab extends GetView<TrackController> {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Week'),
              Tab(text: 'Month'),
              Tab(text: '6M'),
              Tab(text: 'Journey'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WeightGraph(timeFrame: TimeFrame.week),
            WeightGraph(timeFrame: TimeFrame.month),
            WeightGraph(timeFrame: TimeFrame.sixMonths),
            WeightGraph(timeFrame: TimeFrame.allTime),
          ],
        ),
      ),
    );
  }
}

class WeightGraph extends GetWidget<TrackController> {
  final TimeFrame timeFrame;

  const WeightGraph({super.key, required this.timeFrame});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Skeletonizer(
            enabled: controller.weightDataLoading.value,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              title: const ChartTitle(text: "Weight Loss Journey"),
              series: <CartesianSeries>[
                LineSeries<WeightData, String>(
                  dataSource: controller.userWeightData.value,
                  xValueMapper: (WeightData weight, _) {
                    final DateFormat inputFormat = DateFormat('M/d/yy');
                    final DateFormat outputFormat = DateFormat('M/dd');
                    DateTime date = inputFormat.parse(weight.date);
                    return outputFormat.format(date);
                  },
                  yValueMapper: (WeightData weight, _) => weight.weight,
                ),
              ],
            ));
      },
    );
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
