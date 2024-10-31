import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';

class StepsChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;

  const StepsChart({super.key, required this.buckets});

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
        BarSeries<HealthDataBucket, DateTime>(
          dataSource: buckets,
          xValueMapper: (HealthDataBucket bucket, _) => bucket.startTime,
          yValueMapper: (HealthDataBucket bucket, _) => bucket.totalSteps,
          name: 'Steps',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
