import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/models/activity_manager.dart';

class CaloriesBurnedChart extends StatelessWidget {
  const CaloriesBurnedChart({super.key});

  @override
  Widget build(BuildContext context) {
    final calorieRecords = HealthActivityManager.hourlyCalorieRecords;

    return SfCartesianChart(
      title: const ChartTitle(text: 'Total Calories Burned'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.hours,
        interval: 2,
        dateFormat: DateFormat('ha'),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
      ),
      series: <CartesianSeries>[
        ColumnSeries<CalorieBurnedRecord, DateTime>(
          dataSource: calorieRecords,
          xValueMapper: (CalorieBurnedRecord record, _) => record.dateFrom,
          yValueMapper: (CalorieBurnedRecord record, _) => record.numericValue,
          name: 'Calories Burned',
          width: 0.8, // Adjust bar width (0-1)
          spacing: 0.2, // Adjust spacing between bars
          borderRadius: BorderRadius.circular(4), // Optional: rounded corners
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
