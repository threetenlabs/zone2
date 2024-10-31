import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';

class HeartRateChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;

  const HeartRateChart({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Average Heart Rate'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat('HH:mm'),
      ),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Beats Per Minute')),
      series: <CartesianSeries>[
        LineSeries<HealthDataBucket, DateTime>(
          dataSource: buckets,
          xValueMapper: (HealthDataBucket bucket, _) => bucket.startTime,
          yValueMapper: (HealthDataBucket bucket, _) => bucket.averageHeartRate,
          name: 'Heart Rate',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
