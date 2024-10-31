import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';

class CardioZoneChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;
  final Map<String, Color> zoneColors;

  const CardioZoneChart({super.key, required this.buckets, required this.zoneColors});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Cardio Zones Over Time'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat('HH:mm'),
      ),
      primaryYAxis: const NumericAxis(isVisible: false),
      series: <CartesianSeries>[
        StackedColumnSeries<HealthDataBucket, DateTime>(
          dataSource: buckets,
          xValueMapper: (HealthDataBucket bucket, _) => bucket.startTime,
          yValueMapper: (HealthDataBucket bucket, _) => 1, // All bars have the same height
          pointColorMapper: (HealthDataBucket bucket, _) =>
              zoneColors[bucket.predominantCardioZone] ?? Colors.grey,
          name: 'Cardio Zone',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
            labelAlignment: ChartDataLabelAlignment.middle,
            labelPosition: ChartDataLabelPosition.inside,
          ),
          dataLabelMapper: (HealthDataBucket bucket, _) => bucket.predominantCardioZone,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
