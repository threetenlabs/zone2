import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/style/theme.dart';

class StepsChart extends GetView<DiaryController> {
  const StepsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Column(
          children: [
            Text(
              'Step Count',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'Target: ${NumberFormat('#,###').format(controller.zone2User.value?.zoneSettings?.dailyStepsGoal ?? 0)}'),
                  Text(
                      'Current: ${NumberFormat('#,###').format(controller.activityManager.value.totalSteps.value)}'),
                  Text(
                      'Remaining: ${NumberFormat('#,###').format(max(0, (controller.zone2User.value?.zoneSettings?.dailyStepsGoal ?? 0) - controller.activityManager.value.totalSteps.value))}'),
                ],
              ),
            ),
            SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
              ),
              title: ChartTitle(
                text: 'Steps Breakdown',
                textStyle: TextStyle(fontSize: 8, color: Theme.of(context).colorScheme.onSurface),
              ),
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
                ColumnSeries<StepRecord, DateTime>(
                  dataSource: controller.activityManager.value.hourlyStepRecords,
                  xValueMapper: (StepRecord record, _) => record.dateFrom,
                  yValueMapper: (StepRecord record, _) => record.numericValue,
                  name: 'Steps',
                  color: MaterialTheme.coolPurple.value,
                  width: 0.6,
                  spacing: 0.2,
                  borderRadius: BorderRadius.circular(6),
                  emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero,
                    color: Colors.transparent,
                  ),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.outer,
                    textStyle: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
