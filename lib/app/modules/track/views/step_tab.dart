import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart';
import 'package:zone2/app/style/theme.dart';

class StepTab extends GetView<TrackController> {
  const StepTab({super.key});

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
                    controller.applyFilter();
                  }
                },
              );
            }).toList(),
          );
        }),
        Expanded(
          child: GetBuilder<TrackController>(
            builder: (_) => StepGraph(),
          ),
        ),
      ],
    );
  }
}

class StepGraph extends GetView<TrackController> {
  const StepGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackController>(
      builder: (_) => _buildStepGraph(context),
    );
  }

  Widget _buildStepGraph(BuildContext context) {
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

    return Skeletonizer(
      enabled: controller.activityManager.value.journeyActivityDataLoading.value,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Your Step Activity',
          textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
        ),
        primaryXAxis: DateTimeCategoryAxis(
          intervalType: intervalType,
          interval: interval,
          dateFormat: dateFormat,
          desiredIntervals: 3,
          majorGridLines: const MajorGridLines(width: 0),
          labelIntersectAction: AxisLabelIntersectAction.none,
          labelAlignment: LabelAlignment.center,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact(),
        ),
        series: <CartesianSeries>[
          ColumnSeries<StepRecord, DateTime>(
            dataSource: controller.activityManager.value.filteredJourneyStepData.value,
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
    );
  }
}
