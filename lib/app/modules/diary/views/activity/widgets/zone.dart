import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ActiveZoneMinutesRadialChart extends StatelessWidget {
  final List<HealthDataBucket> buckets;

  ActiveZoneMinutesRadialChart({required this.buckets});

  @override
  Widget build(BuildContext context) {
    // Initialize the map to hold total minutes per zone
    Map<String, double> totalZoneMinutes = {};

    // Iterate over each bucket
    for (var bucket in buckets) {
      // For each zone in the bucket's cardioZoneMinutes
      bucket.cardioZoneMinutes.forEach((zone, minutes) {
        // Sum the minutes for each zone across all buckets
        totalZoneMinutes.update(
          zone,
          (value) => value + minutes.toDouble(),
          ifAbsent: () => minutes.toDouble(),
        );
      });
    }

    // Now filter for the zones we are interested in (Zones 2 to 5)
    Map<String, double> zoneMinutes = {
      'Zone 2 (Light)': totalZoneMinutes['Zone 2 (Light)'] ?? 0,
      'Zone 3 (Moderate)': totalZoneMinutes['Zone 3 (Moderate)'] ?? 0,
      'Zone 4 (Hard)': totalZoneMinutes['Zone 4 (Hard)'] ?? 0,
      'Zone 5 (Maximum)': totalZoneMinutes['Zone 5 (Maximum)'] ?? 0,
    };

    // Calculate the total Active Zone Minutes from the zones
    double totalActiveZoneMinutes = zoneMinutes.values.reduce((a, b) => a + b);

    // Handle case when totalActiveZoneMinutes is zero
    if (totalActiveZoneMinutes == 0) {
      totalActiveZoneMinutes = 1; // Avoid division by zero
    }

    // Set the total minutes for percentage calculation
    _ChartData.setTotalMinutes(totalActiveZoneMinutes);

    // Convert the map to a list of data points
    List<_ChartData> chartData = zoneMinutes.entries.map((entry) {
      return _ChartData(entry.key, entry.value);
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
      Icon(Icons.directions_walk, color: Colors.lightGreen, size: 20), // Zone 2
      Icon(Icons.directions_walk, color: Colors.yellow, size: 20), // Zone 3
      Icon(Icons.directions_run, color: Colors.orange, size: 20), // Zone 4
      Icon(Icons.directions_bike, color: Colors.red, size: 20), // Zone 5
    ];

    return SfCircularChart(
      title: ChartTitle(text: 'Active Zone Minutes'),
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
          pointColorMapper: (_ChartData data, _) => _getZoneColor(data.zone),
          legendIconType: LegendIconType.circle,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Text(
            '${totalActiveZoneMinutes.toInt()} min',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Function to get the color for each zone
  Color _getZoneColor(String zone) {
    switch (zone) {
      case 'Zone 2 (Light)':
        return Colors.lightGreen;
      case 'Zone 3 (Moderate)':
        return Colors.yellow;
      case 'Zone 4 (Hard)':
        return Colors.orange;
      case 'Zone 5 (Maximum)':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Data class for the chart
class _ChartData {
  _ChartData(this.zone, this.minutes) {
    // Calculate the percentage for the legend charts
    percentage = ((minutes / totalMinutes) * 100).round();
  }
  final String zone;
  final double minutes;
  late int percentage;
  static double totalMinutes = 0;

  // Static method to set totalMinutes
  static void setTotalMinutes(double total) {
    totalMinutes = total;
  }
}
