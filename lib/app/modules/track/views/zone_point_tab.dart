import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart'; // Import GetX for controller access
import 'package:intl/intl.dart';
import 'package:zone2/app/style/theme.dart'; // Add this import

// Define an enum for time frames

class ZonePointsTab extends GetView<TrackController> {
  const ZonePointsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a map of labels to TimeFrame values
    final Map<String, TimeFrame> labelToTimeFrame = {
      'Week': TimeFrame.week,
      'Month': TimeFrame.month,
      'Journey': TimeFrame.allTime,
    };

    return Column(
      children: [
        Obx(() {
          return Wrap(
            spacing: 8.0,
            children: labelToTimeFrame.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.key),
                selected: controller.selectedTimeFrame.value == entry.value,
                onSelected: (bool selected) {
                  if (selected) {
                    controller.selectedTimeFrame.value = entry.value;
                    // Update the graph data based on the selected time frame
                    controller.getFilteredZonePointData();
                  }
                },
              );
            }).toList(),
          );
        }),
        Expanded(
          child: ZonePointsGraph(),
        ),
      ],
    );
  }
}

class ZonePointsGraph extends GetWidget<TrackController> {
  const ZonePointsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackController>(
      builder: (_) => _buildZonePointsGraph(context),
    );
  }

  Widget _buildZonePointsGraph(BuildContext context) {
    // Determine the date format and interval type based on the time frame
    DateFormat dateFormat;
    DateTimeIntervalType intervalType;
    double interval;

    switch (controller.selectedTimeFrame.value) {
      case TimeFrame.week:
        dateFormat = DateFormat('EEE'); // Day of the week
        intervalType = DateTimeIntervalType.days;
        interval = 1.0;
        break;
      case TimeFrame.month:
        dateFormat = DateFormat('d'); // Day of the month
        intervalType = DateTimeIntervalType.days;
        interval = 2.0;
        break;
      case TimeFrame.allTime:
        dateFormat = DateFormat('MMM'); // Month
        intervalType = DateTimeIntervalType.months;
        interval = 1.0;
        break;
      default:
        dateFormat = DateFormat('d');
        intervalType = DateTimeIntervalType.days;
        interval = 1.0;
    }

    // Calculate average steps per day by month for 1/2 Year and Journey
    final averageRecords = controller.selectedTimeFrame.value == TimeFrame.allTime
        ? _calculateMonthlyAverages(controller.filteredZonePointData.value)
        : controller.filteredZonePointData.value;

    return Skeletonizer(
      enabled: controller.activityDataLoading.value,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Your Zone Point Activity',
          textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
        ),
        primaryXAxis: DateTimeCategoryAxis(
          intervalType: intervalType,
          interval: interval,
          dateFormat: dateFormat,
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.none,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact(),
        ),
        series: <CartesianSeries>[
          ColumnSeries<ZonePointRecord, DateTime>(
            dataSource: averageRecords,
            xValueMapper: (ZonePointRecord record, _) => record.dateFrom,
            yValueMapper: (ZonePointRecord record, _) => record.zonePoints,
            name: 'Zone Points',
            color: MaterialTheme.coolRed.value,
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
    );
  }

  List<ZonePointRecord> _calculateMonthlyAverages(List<ZonePointRecord> records) {
    // Implement logic to calculate average steps per day by month
    // This is a placeholder implementation
    Map<DateTime, List<ZonePointRecord>> groupedByMonth = {};
    for (var record in records) {
      DateTime monthKey = DateTime(record.dateFrom.year, record.dateFrom.month);
      if (!groupedByMonth.containsKey(monthKey)) {
        groupedByMonth[monthKey] = [];
      }
      groupedByMonth[monthKey]!.add(record);
    }

    List<ZonePointRecord> averageRecords = [];
    groupedByMonth.forEach((month, records) {
      double totalSteps = records.fold(0, (sum, record) => sum + record.zonePoints);
      double averageSteps = totalSteps / records.length;
      averageRecords.add(ZonePointRecord(
        dateFrom: month,
        zonePoints: averageSteps.toInt(),
        uuid: "month_${month.toString()}",
        sourceName: 'Zone Points',
        dateTo: month.add(const Duration(days: 1)),
      ));
    });

    return averageRecords;
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
