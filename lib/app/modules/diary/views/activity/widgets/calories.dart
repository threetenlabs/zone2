import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';

class CaloriesBurnedChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;

  const CaloriesBurnedChart({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Total Calories Burned'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat('HH:mm'),
      ),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Calories')),
      series: <CartesianSeries>[
        ColumnSeries<HealthDataBucket, DateTime>(
          dataSource: buckets,
          xValueMapper: (HealthDataBucket bucket, _) => bucket.startTime,
          yValueMapper: (HealthDataBucket bucket, _) => bucket.totalCaloriesBurned,
          name: 'Calories Burned',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
