import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:get/get.dart';

/// Class to manage and process health activity data
class HealthActivityManager extends GetxController {
  // Convert static lists to RxList
  final heartRateRecords = RxList<HeartRateRecord>([]);
  final calorieRecords = RxList<CalorieBurnedRecord>([]);
  final hourlyCalorieRecords = RxList<CalorieBurnedRecord>([]);
  final hourlyStepRecords = RxList<StepRecord>([]);
  final stepRecords = RxList<StepRecord>([]);
  final workoutRecords = RxList<WorkoutRecord>([]);

  // Convert statistics to Rx
  final totalSteps = 0.obs;
  final totalCaloriesBurned = 0.0.obs;
  final totalZonePoints = 0.obs;
  final multipleCalorieSources = false.obs;

  // Convert zone minutes to RxMap
  final zoneMinutes = RxMap<int, int>({
    1: 0, // Very Light
    2: 0, // Light
    3: 0, // Moderate
    4: 0, // Hard
    5: 0, // Maximum
  });

  // Zone configs can remain final since they don't change
  final zoneConfigs = {
    1: const ZoneConfig(
      name: 'Zone 1 (Very Light)',
      color: Color(0xFFF9F826), // Bright cyan/teal
      minPercentage: 0,
      maxPercentage: 60,
      icon: Icons.directions_walk,
    ),
    2: const ZoneConfig(
      name: 'Zone 2 (Light)',
      color: Color(0xFF00B0FF), // Bright blue
      minPercentage: 60,
      maxPercentage: 70,
      icon: Icons.directions_walk,
    ),
    3: const ZoneConfig(
      name: 'Zone 3 (Moderate)',
      color: Color(0xFF00BFA6), // Deep blue/purple
      minPercentage: 70,
      maxPercentage: 80,
      icon: Icons.directions_walk,
    ),
    4: const ZoneConfig(
      name: 'Zone 4 (Hard)',
      color: Color(0xFF6C63FF), // Bright purple
      minPercentage: 80,
      maxPercentage: 90,
      icon: Icons.directions_run,
    ),
    5: const ZoneConfig(
      name: 'Zone 5 (Maximum)',
      color: Color(0xFFF50057), // Vibrant fuchsia
      minPercentage: 90,
      maxPercentage: 100,
      icon: Icons.directions_bike,
    ),
  };

  /// Process activity data and store results
  void processActivityData({
    required List<HealthDataPoint> activityData,
    required int userAge,
  }) {
    // Reset all stored values
    _resetAllValues();

    // Parse records
    heartRateRecords.value = _parseHeartRateData(
        activityData.where((data) => data.type == HealthDataType.HEART_RATE).toList());
    calorieRecords.value = parseCalorieData(
        activityData.where((data) => data.type == HealthDataType.TOTAL_CALORIES_BURNED).toList());
    stepRecords.value =
        _parseStepData(activityData.where((data) => data.type == HealthDataType.STEPS).toList());
    workoutRecords.value = _parseWorkoutData(
        activityData.where((data) => data.type == HealthDataType.WORKOUT).toList());

    multipleCalorieSources.value =
        calorieRecords.map((record) => record.sourceName).toSet().length > 1;

    // Process heart rate zones
    _processHeartRateZones(userAge);

    // Process calories by hour
    _processCaloriesByHour();
    // Process steps by hour
    _processStepsByHour();

    // Calculate totals
    _calculateTotals();
  }

  /// Process heart rate data to identify zones
  void _processHeartRateZones(int userAge) {
    if (heartRateRecords.isEmpty) return;

    // Reset zone minutes
    zoneMinutes.updateAll((key, value) => 0);
    totalZonePoints.value = 0;

    for (var record in heartRateRecords) {
      int zone = _getCardioZone(record.numericValue, userAge);

      // Increment zone minutes
      zoneMinutes[zone] = (zoneMinutes[zone] ?? 0) + 1;
    }

    // Calculate total zone points based on minutes in each zone
    totalZonePoints.value = zoneMinutes.entries.fold(0, (sum, entry) {
      return sum + (_getZonePoints(entry.key) * entry.value);
    });
  }

  // Add this new method to bucket calories by hour
  void _processCaloriesByHour() {
    if (calorieRecords.isEmpty) return;

    // Create a map to store hourly totals
    Map<DateTime, double> hourlyTotals = {};

    // Get the date from the first record to use as reference
    DateTime firstDate = DateTime(
      calorieRecords.first.dateFrom.year,
      calorieRecords.first.dateFrom.month,
      calorieRecords.first.dateFrom.day,
    );

    // Initialize all hours with 0 calories
    for (int hour = 0; hour < 24; hour++) {
      DateTime hourKey = firstDate.add(Duration(hours: hour));
      hourlyTotals[hourKey] = 0;
    }

    // Track processed time ranges to avoid double counting
    Set<String> processedRanges = {};

    // Sum up calories for each hour, avoiding duplicates
    for (var record in calorieRecords) {
      String timeRange = '${record.dateFrom}-${record.dateTo}';
      if (processedRanges.contains(timeRange)) continue;

      DateTime hourKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
        record.dateFrom.hour,
      );
      hourlyTotals[hourKey] = (hourlyTotals[hourKey] ?? 0) + record.numericValue;
      processedRanges.add(timeRange);
    }

    // Convert back to CalorieBurnedRecord list
    hourlyCalorieRecords.value = hourlyTotals.entries.map((entry) {
      return CalorieBurnedRecord(
        numericValue: entry.value,
        dateFrom: entry.key,
        dateTo: entry.key.add(const Duration(hours: 1)),
        sourceName: 'hourly',
        uuid: 'hourly_${entry.key.toString()}',
        unit: 'KILOCALORIE',
      );
    }).toList()
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
  }

  void _processStepsByHour() {
    if (stepRecords.isEmpty) return;

    // Create a map to store hourly totals
    Map<DateTime, int> hourlyTotals = {};

    // Get the date from the first record to use as reference
    DateTime firstDate = DateTime(
      stepRecords.first.dateFrom.year,
      stepRecords.first.dateFrom.month,
      stepRecords.first.dateFrom.day,
    );

    // Initialize all hours with 0 steps
    for (int hour = 0; hour < 24; hour++) {
      DateTime hourKey = firstDate.add(Duration(hours: hour));
      hourlyTotals[hourKey] = 0;
    }

    // Track processed time ranges to avoid double counting
    Set<String> processedRanges = {};

    // Sum up steps for each hour, avoiding duplicates
    for (var record in stepRecords) {
      String timeRange = '${record.dateFrom}-${record.dateTo}';
      if (processedRanges.contains(timeRange)) continue;

      DateTime hourKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
        record.dateFrom.hour,
      );
      hourlyTotals[hourKey] = (hourlyTotals[hourKey] ?? 0) + record.numericValue.toInt();
      processedRanges.add(timeRange);
    }

    // Convert back to StepRecord list
    hourlyStepRecords.value = hourlyTotals.entries.map((entry) {
      return StepRecord(
        numericValue: entry.value,
        dateFrom: entry.key,
        dateTo: entry.key.add(const Duration(hours: 1)),
        uuid: 'hourly_${entry.key.toString()}',
        unit: 'COUNT',
      );
    }).toList()
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
  }

  /// Calculate total steps and calories
  void _calculateTotals() {
    // Sum up steps from regular records
    totalSteps.value = stepRecords.fold(0, (sum, record) => sum + record.numericValue.toInt());

    // Add steps from workouts
    totalSteps.value += workoutRecords.fold(0, (sum, record) => sum + record.totalSteps);

    // Track processed time ranges to avoid double counting
    Set<String> processedRanges = {};

    // Only use calories from regular records, with deduplication
    totalCaloriesBurned.value = calorieRecords.fold(0.0, (sum, record) {
      String timeRange = '${record.dateFrom}-${record.dateTo}';
      if (processedRanges.contains(timeRange)) return sum;

      processedRanges.add(timeRange);
      return sum + record.numericValue;
    });
  }

  /// Reset all stored values to their defaults
  void _resetAllValues() {
    heartRateRecords.clear();
    calorieRecords.clear();
    stepRecords.clear();
    workoutRecords.clear();
    totalSteps.value = 0;
    totalCaloriesBurned.value = 0.0;
    zoneMinutes.updateAll((key, value) => 0);
  }

  /// Parses a list of JSON objects into HeartRateRecord instances.
  List<HeartRateRecord> _parseHeartRateData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => HeartRateRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into CalorieBurnedRecord instances.
  List<CalorieBurnedRecord> parseCalorieData(List<HealthDataPoint> healthData) {
    final t = healthData;

    return t.map((data) => CalorieBurnedRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into StepRecord instances.
  List<StepRecord> _parseStepData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => StepRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into WorkoutRecord instances.
  List<WorkoutRecord> _parseWorkoutData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => WorkoutRecord.fromJson(data.toJson())).toList();
  }

  /// Calculates the cardio zone based on heart rate and user age.
  int _getCardioZone(double heartRate, int age) {
    double maxHeartRate = 220.0 - age.toDouble();
    double percentage = (heartRate / maxHeartRate) * 100;

    for (var entry in zoneConfigs.entries) {
      if (percentage >= entry.value.minPercentage && percentage < entry.value.maxPercentage) {
        return entry.key;
      }
    }
    return 5; // Maximum zone if percentage is >= 90
  }

  /// Calculates Zone Points based on time spent in a cardio zone.
  int _getZonePoints(int cardioZone) {
    if (cardioZone >= 2 && cardioZone <= 3) {
      return 1;
    } else if (cardioZone >= 4) {
      return 2;
    }
    return 0;
  }

  // Getter methods
  // List<HeartRateRecord> get heartRateRecords => heartRateRecords;
  // List<CalorieBurnedRecord> get calorieRecords => calorieRecords;
  // List<StepRecord> get stepRecords => _stepRecords;
  // List<WorkoutRecord> get workoutRecords => _workoutRecords;
  // int get steps => _totalSteps.value;
  // double get caloriesBurned => _totalCaloriesBurned.value;
  // Map<int, int> get zoneDurationMinutes => _zoneMinutes;
  // Map<int, ZoneConfig> get zoneConfigs => _zoneConfigs;
  // int get totalZonePoints => _totalZonePoints.value;
  // bool get multipleCalorieSources => _multipleCalorieSources.value;
  // // Bucket calories by hour
  // List<CalorieBurnedRecord> get hourlyCalorieRecords => hourlyCalorieRecords;
  // List<StepRecord> get hourlyStepRecords => _hourlyStepRecords;
}
