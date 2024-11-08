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
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
          shouldAlwaysShow: true,
          tooltipSettings: InteractiveTooltip(enable: true, color: Colors.red),
          builder: (BuildContext context, TrackballDetails trackballDetails) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${trackballDetails.point!.y?.toInt()} steps',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
        title: const ChartTitle(text: 'Total Steps'),
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
            width: 0.6,
            spacing: 0.2,
            borderRadius: BorderRadius.circular(6),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          ),
        ],
        // tooltipBehavior: TooltipBehavior(
        //   enable: true,
        //   activationMode: ActivationMode.longPress,
        //   shouldAlwaysShow: true,
        //   builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        //     return Container(
        //       padding: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         color: Colors.black87,
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       child: Text(
        //         '${data.numericValue} steps',
        //         style: const TextStyle(color: Colors.white),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
