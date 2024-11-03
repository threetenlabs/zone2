import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class StepsChart extends GetView<DiaryController> {
  const StepsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Total Steps'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat('HH:mm'),
      ),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Steps')),
      series: <CartesianSeries>[
        BarSeries<StepRecord, DateTime>(
          dataSource: controller.activityManager.value.stepRecords,
          xValueMapper: (StepRecord record, _) => record.dateFrom,
          yValueMapper: (StepRecord record, _) => record.numericValue,
          name: 'Steps',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
