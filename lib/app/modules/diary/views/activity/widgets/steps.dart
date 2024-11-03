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
    return Obx(
      () => SfCartesianChart(
        title: const ChartTitle(text: 'Total Steps'),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.hours,
          interval: 3,
          dateFormat: DateFormat('ha'),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact(),
        ),
        series: <CartesianSeries>[
          ColumnSeries<StepRecord, DateTime>(
            dataSource: controller.activityManager.value.hourlyStepRecords,
            xValueMapper: (StepRecord record, _) => record.dateFrom,
            yValueMapper: (StepRecord record, _) => record.numericValue,
            name: 'Steps',
            width: 0.6,
            spacing: 0.2,
            borderRadius: BorderRadius.circular(6),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
