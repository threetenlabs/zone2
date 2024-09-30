import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

class TrackController extends GetxController {
  final count = 0.obs;
  final healthService = Get.find<HealthService>();
  final logger = Get.find<Logger>();
  void increment() => count.value++;

  // Method to save weight
  Future<void> saveWeight(double weight) async {
    await healthService.saveWeightToHealth(weight);
    // Additional logic for saving weight can be added here
  }

  // Method to save food
  Future<void> saveFood(String foodItem) async {
    // Logic to save food item
  }

  // Method to save hydration
  Future<void> saveHydration(double volume) async {
    // Logic to save hydration volume
  }

  // Method to get weight data based on time frame
  Future<List<WeightData>> getWeightData(TimeFrame timeFrame) async {
    logger.i('Getting weight data for time frame: $timeFrame');
    // List<HealthDataPoint> healthData = await healthService.getWeightDataByTimeFrame(timeFrame);

    final now = DateTime.now();
    final weightData = await healthService.getWeightData(timeFrame: timeFrame, endTime: now);

    // Group by date and take the last entry for each date
    Map<String, HealthDataPoint> latestEntries = {};
    for (var dataPoint in weightData) {
      String dateKey = DateFormat('M/d/yy').format(dataPoint.dateFrom);
      if (!latestEntries.containsKey(dateKey) ||
          latestEntries[dateKey]!.dateFrom.isBefore(dataPoint.dateFrom)) {
        latestEntries[dateKey] = dataPoint;
      }
    }

    // Convert the latest entries to WeightData, converting kg to lbs
    return Future.wait(latestEntries.values.map((dataPoint) async => WeightData(
        DateFormat('M/d/yy').format(dataPoint.dateFrom),
        // Await the conversion to ensure we get a double value
        await healthService.convertWeightUnit(
            (dataPoint.value as NumericHealthValue).numericValue.toDouble(), WeightUnit.pound))));
  }
}
