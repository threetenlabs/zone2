import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:zone2/app/models/activity_manager.dart';

class ActiveZoneMinutesRadialChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;

  const ActiveZoneMinutesRadialChart({super.key, required this.buckets});

  @override
  Widget build(BuildContext context) {
    // Filter and calculate total Active Zone Minutes from zones 2-5 only
    Map<int, int> filteredZones =
        Map.fromEntries(HealthActivityManager.zoneDurationMinutes.entries.where((entry) {
      int zoneNumber = entry.key;
      return zoneNumber >= 2 && zoneNumber <= 5;
    }));

    int totalActiveZoneMinutes = filteredZones.values.isEmpty
        ? 1 // Avoid division by zero
        : filteredZones.values.reduce((a, b) => a + b);

    // Set the total minutes for percentage calculation
    _ChartData.setTotalMinutes(totalActiveZoneMinutes);

    // Convert the filtered map to a list of data points
    List<_ChartData> chartData = filteredZones.entries.map((entry) {
      return _ChartData(
          HealthActivityManager.zoneConfigs[entry.key]?.name ?? '', entry.key, entry.value);
    }).toList();

    // List of colors corresponding to each zone
    List<Color> colors = [
      Colors.lightGreen, // Zone 2 (Light)
      Colors.yellow, // Zone 3 (Moderate)
      Colors.orange, // Zone 4 (Hard)
      Colors.red, // Zone 5 (Maximum)
    ];

    // List of icons for the legend
    List<Widget> legendIcons = [
      const Icon(Icons.directions_walk, color: Colors.lightGreen, size: 20), // Zone 2
      const Icon(Icons.directions_walk, color: Colors.yellow, size: 20), // Zone 3
      const Icon(Icons.directions_run, color: Colors.orange, size: 20), // Zone 4
      const Icon(Icons.directions_bike, color: Colors.red, size: 20), // Zone 5
    ];

    return SfCircularChart(
      title: const ChartTitle(text: 'Active Zone Minutes'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
          return SizedBox(
            height: 60,
            width: 150,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: SfCircularChart(
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                        widget: legendIcons[index],
                      ),
                    ],
                    series: <RadialBarSeries<_ChartData, String>>[
                      RadialBarSeries<_ChartData, String>(
                        dataSource: [chartData[index]],
                        maximumValue: 100,
                        radius: '100%',
                        cornerStyle: CornerStyle.bothCurve,
                        xValueMapper: (_ChartData data, _) => data.zone,
                        yValueMapper: (_ChartData data, _) => data.percentage.toDouble(),
                        pointColorMapper: (_ChartData data, _) => colors[index],
                        innerRadius: '70%',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: Text(
                    point.x,
                    style: TextStyle(
                      color: colors[index],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      series: <RadialBarSeries<_ChartData, String>>[
        RadialBarSeries<_ChartData, String>(
          dataSource: chartData,
          maximumValue: chartData.map((data) => data.minutes).reduce((a, b) => a > b ? a : b) * 1.2,
          gap: '10%',
          radius: '100%',
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (_ChartData data, _) => data.zone,
          yValueMapper: (_ChartData data, _) => data.minutes,
          pointColorMapper: (_ChartData data, _) =>
              HealthActivityManager.zoneConfigs[data.zoneNumber]?.color ?? Colors.grey,
          legendIconType: LegendIconType.circle,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Text(
            '${totalActiveZoneMinutes.toInt()} min',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Data class for the chart
class _ChartData {
  _ChartData(this.zone, this.zoneNumber, this.minutes) {
    // Calculate the percentage for the legend charts
    percentage = ((minutes / totalMinutes) * 100).round();
  }
  final String zone;
  final int zoneNumber;
  final int minutes;
  late int percentage;
  static int totalMinutes = 0;

  // Static method to set totalMinutes
  static void setTotalMinutes(int total) {
    totalMinutes = total;
  }
}
