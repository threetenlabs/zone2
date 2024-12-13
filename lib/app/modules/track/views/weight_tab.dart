import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/style/theme.dart';

class WeightTab extends GetView<TrackController> {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: WeightGraph(),
    );
  }
}

class WeightGraph extends GetView<TrackController> {
  const WeightGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackController>(
      builder: (_) {
        return Skeletonizer(
          enabled: controller.activityManager.value.journeyWeightDataLoading.value,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: ChartTitle(
                text: "Weight Loss Journey",
                textStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
            series: <CartesianSeries>[
              LineSeries<WeightDataRecord, String>(
                color: Get.isDarkMode
                    ? MaterialTheme.weightColor.dark.color
                    : MaterialTheme.weightColor.light.color,
                dataSource: controller.activityManager.value.filteredJourneyWeightData,
                xValueMapper: (WeightDataRecord weight, _) {
                  final DateFormat inputFormat = DateFormat('M/d/yy');
                  final DateFormat outputFormat = DateFormat('M/dd');
                  DateTime date = inputFormat.parse(weight.date);
                  return outputFormat.format(date);
                },
                yValueMapper: (WeightDataRecord weight, _) => weight.weight,
              ),
              if (controller.selectedTimeFrame.value == TimeFrame.allTime)
                LineSeries<WeightDataRecord, String>(
                  dataSource: controller.getTrendLineData(),
                  xValueMapper: (WeightDataRecord weight, _) {
                    final DateFormat inputFormat = DateFormat('M/d/yy');
                    final DateFormat outputFormat = DateFormat('M/dd');
                    DateTime date = inputFormat.parse(weight.date);
                    return outputFormat.format(date);
                  },
                  yValueMapper: (WeightDataRecord weight, _) => weight.weight,
                  color: Colors.red,
                  dashArray: <double>[5, 5],
                ),
            ],
          ),
        );
      },
    );
  }
}
