import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zone2/app/services/health_service.dart';

class WeightTab extends GetView<TrackController> {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a map of labels to TimeFrame values
    final Map<String, TimeFrame> labelToTimeFrame = {
      'Week': TimeFrame.week,
      'Month': TimeFrame.month,
      'Journey': TimeFrame.allTime,
    };

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Obx(() {
            return Wrap(
              spacing: 10.0,
              children: labelToTimeFrame.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: controller.selectedTimeFrame.value == entry.value,
                  onSelected: (bool selected) {
                    if (selected) {
                      controller.selectedTimeFrame.value = entry.value;
                      controller.getFilteredWeightData();
                    }
                  },
                );
              }).toList(),
            );
          }),
          Expanded(
            child: WeightGraph(),
          ),
        ],
      ),
    );
  }
}

class WeightGraph extends GetWidget<TrackController> {
  const WeightGraph({super.key});

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
                dataSource: controller.filteredWeightData.value,
                xValueMapper: (WeightData weight, _) {
                  final DateFormat inputFormat = DateFormat('M/d/yy');
                  final DateFormat outputFormat = DateFormat('M/dd');
                  DateTime date = inputFormat.parse(weight.date);
                  return outputFormat.format(date);
                },
                yValueMapper: (WeightData weight, _) => weight.weight,
              ),
              if (controller.selectedTimeFrame.value == TimeFrame.allTime)
                LineSeries<WeightData, String>(
                  dataSource: controller.getTrendLineData(),
                  xValueMapper: (WeightData weight, _) {
                    final DateFormat inputFormat = DateFormat('M/d/yy');
                    final DateFormat outputFormat = DateFormat('M/dd');
                    DateTime date = inputFormat.parse(weight.date);
                    return outputFormat.format(date);
                  },
                  yValueMapper: (WeightData weight, _) => weight.weight,
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

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
