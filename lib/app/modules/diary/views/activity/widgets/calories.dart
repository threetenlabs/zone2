import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class CaloriesBurnedChart extends GetView<DiaryController> {
  const CaloriesBurnedChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SfCartesianChart(
        title: const ChartTitle(text: 'Total Calories Burned'),
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.hours,
          interval: 1,
          dateFormat: DateFormat('ha'),
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.none,
          desiredIntervals: 12,
          maximumLabels: 13,
          axisLabelFormatter: (AxisLabelRenderDetails args) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(args.value.toInt());
            if (date.hour % 2 == 0) {
              String amPm = date.hour < 12 ? 'A' : 'P';
              String hour = (date.hour % 12 == 0 ? 12 : date.hour % 12).toString();
              return ChartAxisLabel('$hour$amPm', args.textStyle);
            }
            return ChartAxisLabel('', args.textStyle);
          },
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact(),
        ),
        series: <CartesianSeries>[
          ColumnSeries<CalorieBurnedRecord, DateTime>(
            dataSource: controller.activityManager.value.hourlyCalorieRecords,
            xValueMapper: (CalorieBurnedRecord record, _) => record.dateFrom,
            yValueMapper: (CalorieBurnedRecord record, _) => record.numericValue,
            name: 'Calories Burned',
            width: 0.6, // Adjust bar width (0-1)
            spacing: 0.2, // Adjust spacing between bars
            borderRadius: BorderRadius.circular(6), // Optional: rounded corners
            emptyPointSettings: EmptyPointSettings(
              mode: EmptyPointMode.zero,
              color: Colors.transparent,
            ),
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
