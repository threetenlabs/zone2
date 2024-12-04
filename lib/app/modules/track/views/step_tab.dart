import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart'; // Import GetX for controller access
import 'package:intl/intl.dart';
import 'package:zone2/app/style/theme.dart'; // Add this import

// Define an enum for time frames

class StepTab extends StatelessWidget {
  const StepTab({super.key});

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
            StepGraph(timeFrame: TimeFrame.week),
            StepGraph(timeFrame: TimeFrame.month),
            StepGraph(timeFrame: TimeFrame.sixMonths),
            StepGraph(timeFrame: TimeFrame.allTime),
          ],
        ),
      ),
    );
  }
}

class StepGraph extends GetWidget<TrackController> {
  final TimeFrame timeFrame; // Update type to TimeFrame

  const StepGraph({super.key, required this.timeFrame});

  @override
  Widget build(BuildContext context) {
    // Map enum to string for fetching data

    final records = timeFrame == TimeFrame.month || timeFrame == TimeFrame.week
        ? controller.activityManager.value.dailyStepRecords
        : controller.activityManager.value.monthlyStepRecords;
    final dateFormat = timeFrame == TimeFrame.month || timeFrame == TimeFrame.week
        ? DateFormat('d')
        : DateFormat('MMMM');

    final intervalType = timeFrame == TimeFrame.month || timeFrame == TimeFrame.week
        ? DateTimeIntervalType.days
        : DateTimeIntervalType.months;

    final interval = timeFrame == TimeFrame.month || timeFrame == TimeFrame.week ? 2.0 : 1.0;
    return SfCartesianChart(
      title: ChartTitle(
        text: 'Daily Steps',
        textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
      ),
      primaryXAxis: DateTimeAxis(
        intervalType: intervalType,
        interval: interval,
        dateFormat: dateFormat,
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.none,
        autoScrollingMode: AutoScrollingMode.start,
        // desiredIntervals: timeFrame == TimeFrame.month || timeFrame == TimeFrame.week ? 2 : 1,
        // maximumLabels: timeFrame == TimeFrame.month || timeFrame == TimeFrame.week ? 15 : 3,
        labelAlignment: LabelAlignment.center,
        // axisLabelFormatter: (AxisLabelRenderDetails args) {
        //   DateTime date = DateTime.fromMillisecondsSinceEpoch(args.value.toInt());
        //   if (date.hour % 2 == 0) {
        //     String amPm = date.hour < 12 ? 'A' : 'P';
        //     String hour = (date.hour % 12 == 0 ? 12 : date.hour % 12).toString();
        //     return ChartAxisLabel('$hour$amPm', args.textStyle);
        //   }
        //   return ChartAxisLabel('', args.textStyle);
        // },
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
      ),
      series: <CartesianSeries>[
        ColumnSeries<StepRecord, DateTime>(
          dataSource: records,
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
    );
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
