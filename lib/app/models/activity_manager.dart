import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/activity.dart';

/// Static class to manage and process health activity data
class HealthActivityManager {
  static List<HeartRateRecord> _heartRateRecords = [];
  static List<CalorieBurnedRecord> _calorieRecords = [];
  static List<CalorieBurnedRecord> _hourlyCalorieRecords = [];
  static List<StepRecord> _stepRecords = [];
  static List<WorkoutRecord> _workoutRecords = [];
  static List<HealthDataBucket> _buckets = [];

  // Summary statistics
  static int _totalSteps = 0;
  static double _totalCaloriesBurned = 0.0;
  static int _totalZonePoints = 0;
  static bool _multipleCalorieSources = false;

  static final Map<int, int> _zoneMinutes = {
    1: 0, // Very Light
    2: 0, // Light
    3: 0, // Moderate
    4: 0, // Hard
    5: 0, // Maximum
  };

  static final Map<int, ZoneConfig> _zoneConfigs = {
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
  static void processActivityData({
    required List<HealthDataPoint> activityData,
    required int userAge,
  }) {
    // Reset all stored values
    _resetAllValues();

    // Parse records
    _heartRateRecords = _parseHeartRateData(
        activityData.where((data) => data.type == HealthDataType.HEART_RATE).toList());
    _calorieRecords = parseCalorieData(
        activityData.where((data) => data.type == HealthDataType.TOTAL_CALORIES_BURNED).toList());
    _stepRecords =
        _parseStepData(activityData.where((data) => data.type == HealthDataType.STEPS).toList());
    _workoutRecords = _parseWorkoutData(
        activityData.where((data) => data.type == HealthDataType.WORKOUT).toList());

    _multipleCalorieSources = _calorieRecords.map((record) => record.sourceName).toSet().length > 1;

    // Process heart rate zones
    _processHeartRateZones(userAge);

    // Process calories by hour
    _processCaloriesByHour();

    // Calculate totals
    _calculateTotals();
  }

  /// Process heart rate data to identify zones
  static void _processHeartRateZones(int userAge) {
    if (_heartRateRecords.isEmpty) return;

    // Reset zone minutes
    _zoneMinutes.updateAll((key, value) => 0);
    _totalZonePoints = 0;

    for (var record in _heartRateRecords) {
      int zone = _getCardioZone(record.numericValue, userAge);

      // Increment zone minutes
      _zoneMinutes[zone] = (_zoneMinutes[zone] ?? 0) + 1;
    }

    // Calculate total zone points based on minutes in each zone
    _totalZonePoints = _zoneMinutes.entries.fold(0, (sum, entry) {
      return sum + (_getZonePoints(entry.key) * entry.value);
    });
  }

  // Add this new method to bucket calories by hour
  static void _processCaloriesByHour() {
    if (_calorieRecords.isEmpty) return;

    // Create a map to store hourly totals
    Map<DateTime, double> hourlyTotals = {};

    // Get the date from the first record to use as reference
    DateTime firstDate = DateTime(
      _calorieRecords.first.dateFrom.year,
      _calorieRecords.first.dateFrom.month,
      _calorieRecords.first.dateFrom.day,
    );

    // Initialize all hours with 0 calories
    for (int hour = 0; hour < 24; hour++) {
      DateTime hourKey = firstDate.add(Duration(hours: hour));
      hourlyTotals[hourKey] = 0;
    }

    // Track processed time ranges to avoid double counting
    Set<String> processedRanges = {};

    // Sum up calories for each hour, avoiding duplicates
    for (var record in _calorieRecords) {
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
    _hourlyCalorieRecords = hourlyTotals.entries.map((entry) {
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

  /// Calculate total steps and calories
  static void _calculateTotals() {
    // Sum up steps from regular records
    _totalSteps = _stepRecords.fold(0, (sum, record) => sum + record.numericValue.toInt());

    // Add steps from workouts
    _totalSteps += _workoutRecords.fold(0, (sum, record) => sum + record.totalSteps);

    // Track processed time ranges to avoid double counting
    Set<String> processedRanges = {};

    // Only use calories from regular records, with deduplication
    _totalCaloriesBurned = _calorieRecords.fold(0.0, (sum, record) {
      String timeRange = '${record.dateFrom}-${record.dateTo}';
      if (processedRanges.contains(timeRange)) return sum;

      processedRanges.add(timeRange);
      return sum + record.numericValue;
    });
  }

  /// Reset all stored values to their defaults
  static void _resetAllValues() {
    _heartRateRecords = [];
    _calorieRecords = [];
    _stepRecords = [];
    _workoutRecords = [];
    _buckets = [];
    _totalSteps = 0;
    _totalCaloriesBurned = 0.0;
    _zoneMinutes.updateAll((key, value) => 0);
  }

  /// Parses a list of JSON objects into HeartRateRecord instances.
  static List<HeartRateRecord> _parseHeartRateData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => HeartRateRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into CalorieBurnedRecord instances.
  static List<CalorieBurnedRecord> parseCalorieData(List<HealthDataPoint> healthData) {
    final t = healthData;

    return t.map((data) => CalorieBurnedRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into StepRecord instances.
  static List<StepRecord> _parseStepData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => StepRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into WorkoutRecord instances.
  static List<WorkoutRecord> _parseWorkoutData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => WorkoutRecord.fromJson(data.toJson())).toList();
  }

  /// Calculates the cardio zone based on heart rate and user age.
  static int _getCardioZone(double heartRate, int age) {
    double maxHeartRate = 220.0 - age.toDouble();
    double percentage = (heartRate / maxHeartRate) * 100;

    for (var entry in _zoneConfigs.entries) {
      if (percentage >= entry.value.minPercentage && percentage < entry.value.maxPercentage) {
        return entry.key;
      }
    }
    return 5; // Maximum zone if percentage is >= 90
  }

  /// Calculates Zone Points based on time spent in a cardio zone.
  static int _getZonePoints(int cardioZone) {
    if (cardioZone >= 2 && cardioZone <= 3) {
      return 1;
    } else if (cardioZone >= 4) {
      return 2;
    }
    return 0;
  }

  // Getter methods
  static List<HeartRateRecord> get heartRateRecords => _heartRateRecords;
  static List<CalorieBurnedRecord> get calorieRecords => _calorieRecords;
  static List<StepRecord> get stepRecords => _stepRecords;
  static List<WorkoutRecord> get workoutRecords => _workoutRecords;
  static List<HealthDataBucket> get buckets => _buckets;
  static int get steps => _totalSteps;
  static double get caloriesBurned => _totalCaloriesBurned;
  static Map<int, int> get zoneDurationMinutes => _zoneMinutes;
  static Map<int, ZoneConfig> get zoneConfigs => _zoneConfigs;
  static int get totalZonePoints => _totalZonePoints;
  static bool get multipleCalorieSources => _multipleCalorieSources;
  // Bucket calories by hour
  static List<CalorieBurnedRecord> get hourlyCalorieRecords => _hourlyCalorieRecords;
}
