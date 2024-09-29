import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/modules/track/views/weight_tab.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

class TrackController extends GetxController {
  final count = 0.obs;
  final healthService = Get.find<HealthService>();

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
    List<HealthDataPoint> healthData = await healthService.getWeightDataByTimeFrame(timeFrame);

    // Convert HealthDataPoint to WeightData
    return healthData
        .map((dataPoint) => WeightData(
            DateFormat('M/d/yy').format(dataPoint.dateFrom), // DateFormat is now defined
            (dataPoint.value as NumericHealthValue)
                .numericValue
                .toDouble())) // Convert HealthValue to double and format date
        .toList();
  }
}
