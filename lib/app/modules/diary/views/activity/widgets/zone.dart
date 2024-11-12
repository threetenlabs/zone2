import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class ActiveZoneMinutesRadialChart extends GetView<DiaryController> {
  const ActiveZoneMinutesRadialChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the total minutes for percentage calculation
    _ChartData.setTotalMinutes(controller.activityManager.value.totalActiveZoneMinutes.value);

    // Convert the filtered map to a list of data points and sort by zone number in reverse
    List<_ChartData> chartData =
        controller.activityManager.value.filteredZoneMinutes.entries.map((entry) {
      return _ChartData(controller.activityManager.value.zoneConfigs[entry.key]?.name ?? '',
          entry.key, entry.value);
    }).toList()
          ..sort((a, b) => b.zoneNumber.compareTo(a.zoneNumber)); // Sort in descending order

    // List of icons for the legend
    List<Widget> legendIcons = [
      Icon(controller.activityManager.value.zoneConfigs[5]!.icon,
          color: controller.activityManager.value.zoneConfigs[5]!.color, size: 20), // Zone 5
      Icon(controller.activityManager.value.zoneConfigs[4]!.icon,
          color: controller.activityManager.value.zoneConfigs[4]!.color, size: 20), // Zone 4
      Icon(controller.activityManager.value.zoneConfigs[3]!.icon,
          color: controller.activityManager.value.zoneConfigs[3]!.color, size: 20), // Zone 3
      Icon(controller.activityManager.value.zoneConfigs[2]!.icon,
          color: controller.activityManager.value.zoneConfigs[2]!.color, size: 20), // Zone 2
    ];

    return Obx(
      () => Card(
        child: Column(
          children: [
            Text(
              'Zone Points',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Target: ${controller.zone2User.value?.zoneSettings?.dailyZonePointsGoal}'),
                  Text('Earned: ${controller.activityManager.value.totalZonePoints}'),
                  Text(
                      'Remaining: ${(controller.zone2User.value?.zoneSettings?.dailyZonePointsGoal ?? 0) - controller.activityManager.value.totalZonePoints.value}'),
                ],
              ),
            ),
            SfCircularChart(
              title: ChartTitle(
                text: 'Zone Breakdown',
                textStyle: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface),
              ),
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
                              color: controller.activityManager.value
                                  .zoneConfigs[chartData[index].zoneNumber]?.color,
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
                      controller.activityManager.value.zoneConfigs[data.zoneNumber]?.color ??
                      Colors.grey,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${controller.activityManager.value.totalZonePoints.toInt()}',
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
            ),
          ],
        ),
      ),
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
