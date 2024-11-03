import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/models/activity_manager.dart';

class ActiveZoneMinutesRadialChart extends StatelessWidget {
  const ActiveZoneMinutesRadialChart({super.key});

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

    // Convert the filtered map to a list of data points and sort by zone number in reverse
    List<_ChartData> chartData = filteredZones.entries.map((entry) {
      return _ChartData(
          HealthActivityManager.zoneConfigs[entry.key]?.name ?? '', entry.key, entry.value);
    }).toList()
      ..sort((a, b) => b.zoneNumber.compareTo(a.zoneNumber)); // Sort in descending order

    // List of icons for the legend
    List<Widget> legendIcons = [
      Icon(HealthActivityManager.zoneConfigs[5]!.icon,
          color: HealthActivityManager.zoneConfigs[5]!.color, size: 20), // Zone 5
      Icon(HealthActivityManager.zoneConfigs[4]!.icon,
          color: HealthActivityManager.zoneConfigs[4]!.color, size: 20), // Zone 4
      Icon(HealthActivityManager.zoneConfigs[3]!.icon,
          color: HealthActivityManager.zoneConfigs[3]!.color, size: 20), // Zone 3
      Icon(HealthActivityManager.zoneConfigs[2]!.icon,
          color: HealthActivityManager.zoneConfigs[2]!.color, size: 20), // Zone 2
    ];

    return SfCircularChart(
      title: const ChartTitle(text: 'Zone Points'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
        position: LegendPosition.right,
        legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
          return SizedBox(
            height: 40,
            width: 50,
            child: Row(
              children: <Widget>[
                legendIcons[index],
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Z ${chartData[index].zoneNumber}",
                    style: TextStyle(
                      color: HealthActivityManager.zoneConfigs[chartData[index].zoneNumber]?.color,
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
          maximumValue: 100,
          radius: '90%',
          gap: '2%',
          innerRadius: '32%',
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (_ChartData data, _) => data.zone,
          yValueMapper: (_ChartData data, _) => data.minutes.toDouble(),
          pointColorMapper: (_ChartData data, _) =>
              HealthActivityManager.zoneConfigs[data.zoneNumber]?.color ?? Colors.grey,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${HealthActivityManager.totalZonePoints.toInt()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Zone Points',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
