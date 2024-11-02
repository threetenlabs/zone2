import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/activity.dart';

/// Static class to manage and process health activity data
class HealthActivityManager {
  static List<HeartRateRecord> _heartRateRecords = [];
  static List<CalorieBurnedRecord> _calorieRecords = [];
  static List<StepRecord> _stepRecords = [];
  static List<WorkoutRecord> _workoutRecords = [];
  static List<HealthDataBucket> _buckets = [];

  // Summary statistics
  static int _totalSteps = 0;
  static double _totalCaloriesBurned = 0.0;
  static int _totalZonePoints = 0;

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
      color: Color(0xFF7FB5FF), // Light blue
      minPercentage: 0,
      maxPercentage: 56,
      icon: Icons.directions_walk,
    ),
    2: const ZoneConfig(
      name: 'Zone 2 (Light)',
      color: Color(0xFF98E169), // Light green
      minPercentage: 57,
      maxPercentage: 63,
      icon: Icons.directions_walk,
    ),
    3: const ZoneConfig(
      name: 'Zone 3 (Moderate)',
      color: Color(0xFFFFD93D), // Bright yellow
      minPercentage: 64,
      maxPercentage: 76,
      icon: Icons.directions_walk,
    ),
    4: const ZoneConfig(
      name: 'Zone 4 (Hard)',
      color: Color(0xFFFF8B3D), // Bright orange
      minPercentage: 77,
      maxPercentage: 95,
      icon: Icons.directions_run,
    ),
    5: const ZoneConfig(
      name: 'Zone 5 (Maximum)',
      color: Color(0xFFFF5757), // Bright red
      minPercentage: 96,
      maxPercentage: 100,
      icon: Icons.directions_bike,
    ),
  };

  /// Process activity data and store results
  static List<HealthDataBucket> processActivityData(
      {required List<HealthDataPoint> activityData,
      required int userAge,
      int bucketSizeInMinutes = 15}) {
    // Reset all stored values
    _resetAllValues();

    // Parse and store records
    _heartRateRecords = _parseHeartRateData(
        activityData.where((data) => data.type == HealthDataType.HEART_RATE).toList());
    _calorieRecords = parseCalorieData(
        activityData.where((data) => data.type == HealthDataType.TOTAL_CALORIES_BURNED).toList());
    _stepRecords =
        _parseStepData(activityData.where((data) => data.type == HealthDataType.STEPS).toList());
    _workoutRecords = _parseWorkoutData(
        activityData.where((data) => data.type == HealthDataType.WORKOUT).toList());

    // Create time series data
    final heartRateTimeSeries = _createHeartRateTimeSeries(_heartRateRecords);
    final calorieTimeSeries = _createCalorieTimeSeries(_calorieRecords, _workoutRecords);
    final stepTimeSeries = _createStepTimeSeries(_stepRecords, _workoutRecords);

    // Generate and store health data points
    final dataPoints =
        _generateHealthDataPoints(heartRateTimeSeries, calorieTimeSeries, stepTimeSeries, userAge);

    // Generate and store buckets
    _buckets = _bucketHealthData(dataPoints, bucketSizeInMinutes);

    // Calculate summary statistics
    _calculateSummaryStatistics(bucketSizeInMinutes);

    return _buckets;
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
    return healthData.map((data) => CalorieBurnedRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into StepRecord instances.
  static List<StepRecord> _parseStepData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => StepRecord.fromJson(data.toJson())).toList();
  }

  /// Parses a list of JSON objects into WorkoutRecord instances.
  static List<WorkoutRecord> _parseWorkoutData(List<HealthDataPoint> healthData) {
    return healthData.map((data) => WorkoutRecord.fromJson(data.toJson())).toList();
  }

  /// Creates a time series map from heart rate records.
  static Map<DateTime, double> _createHeartRateTimeSeries(List<HeartRateRecord> records) {
    Map<DateTime, double> heartRateTimeSeries = {};

    records.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    for (var record in records) {
      DateTime time = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
        record.dateFrom.hour,
        record.dateFrom.minute,
      );

      heartRateTimeSeries[time] = record.numericValue;
    }

    return heartRateTimeSeries;
  }

  /// Creates a time series map from calorie burned records.
  static Map<DateTime, double> _createCalorieTimeSeries(
      List<CalorieBurnedRecord> records, List<WorkoutRecord> workouts) {
    Map<DateTime, double> calorieTimeSeries = {};

    // Process individual calorie records
    for (var record in records) {
      DateTime start = record.dateFrom;
      DateTime end = record.dateTo;

      int minutes = end.difference(start).inMinutes;
      if (minutes == 0) minutes = 1; // Ensure at least one minute

      double caloriesPerMinute = record.numericValue / minutes;

      for (int i = 0; i < minutes; i++) {
        DateTime minuteTime = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute + i,
        );

        calorieTimeSeries.update(
          minuteTime,
          (existing) => existing + caloriesPerMinute,
          ifAbsent: () => caloriesPerMinute,
        );
      }
    }

    // Process workouts
    for (var workout in workouts) {
      DateTime start = workout.dateFrom;
      DateTime end = workout.dateTo;

      int minutes = end.difference(start).inMinutes;
      if (minutes == 0) minutes = 1; // Ensure at least one minute

      double caloriesPerMinute = workout.totalEnergyBurned / minutes;

      for (int i = 0; i < minutes; i++) {
        DateTime minuteTime = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute + i,
        );

        calorieTimeSeries.update(
          minuteTime,
          (existing) => existing + caloriesPerMinute,
          ifAbsent: () => caloriesPerMinute,
        );
      }
    }

    return calorieTimeSeries;
  }

  /// Creates a time series map from step records.
  static Map<DateTime, int> _createStepTimeSeries(
      List<StepRecord> records, List<WorkoutRecord> workouts) {
    Map<DateTime, int> stepTimeSeries = {};

    // Process individual step records
    for (var record in records) {
      DateTime start = record.dateFrom;
      DateTime end = record.dateTo;

      int minutes = end.difference(start).inMinutes;
      if (minutes == 0) minutes = 1; // Ensure at least one minute

      int stepsPerMinute = (record.numericValue / minutes).ceil();

      for (int i = 0; i < minutes; i++) {
        DateTime minuteTime = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute + i,
        );

        stepTimeSeries.update(
          minuteTime,
          (existing) => existing + stepsPerMinute,
          ifAbsent: () => stepsPerMinute,
        );
      }
    }

    // Process workouts
    for (var workout in workouts) {
      DateTime start = workout.dateFrom;
      DateTime end = workout.dateTo;

      int minutes = end.difference(start).inMinutes;
      if (minutes == 0) minutes = 1; // Ensure at least one minute

      int stepsPerMinute = (workout.totalSteps / minutes).ceil();

      for (int i = 0; i < minutes; i++) {
        DateTime minuteTime = DateTime(
          start.year,
          start.month,
          start.day,
          start.hour,
          start.minute + i,
        );

        stepTimeSeries.update(
          minuteTime,
          (existing) => existing + stepsPerMinute,
          ifAbsent: () => stepsPerMinute,
        );
      }
    }

    return stepTimeSeries;
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

  /// Buckets health data points into specified time frames.
  static List<HealthDataBucket> _bucketHealthData(
      List<Zone2HealthDataPoint> dataPoints, int bucketSizeInMinutes) {
    if (dataPoints.isEmpty) {
      return [];
    }

    dataPoints.sort((a, b) => a.time.compareTo(b.time));

    // Track consecutive minutes for each zone
    Map<int, List<DateTime>> consecutiveZoneTimes = {};
    int currentZone = dataPoints.first.cardioZone;
    List<DateTime> currentStreak = [dataPoints.first.time];

    // Process consecutive minutes
    for (int i = 1; i < dataPoints.length; i++) {
      var point = dataPoints[i];
      var previousPoint = dataPoints[i - 1];

      // Check if points are consecutive minutes
      if (point.time.difference(previousPoint.time) == const Duration(minutes: 1)) {
        if (point.cardioZone == currentZone) {
          currentStreak.add(point.time);
        } else {
          // Zone changed, check if previous streak was valid
          if (currentStreak.length >= 5) {
            consecutiveZoneTimes.update(
              currentZone,
              (list) => list..addAll(currentStreak),
              ifAbsent: () => List.from(currentStreak),
            );
          }
          currentZone = point.cardioZone;
          currentStreak = [point.time];
        }
      } else {
        // Gap in data, check if previous streak was valid
        if (currentStreak.length >= 10) {
          consecutiveZoneTimes.update(
            currentZone,
            (list) => list..addAll(currentStreak),
            ifAbsent: () => List.from(currentStreak),
          );
        }
        currentZone = point.cardioZone;
        currentStreak = [point.time];
      }
    }

    // Check final streak
    if (currentStreak.length >= 10) {
      consecutiveZoneTimes.update(
        currentZone,
        (list) => list..addAll(currentStreak),
        ifAbsent: () => List.from(currentStreak),
      );
    }

    DateTime startTime = dataPoints.first.time;
    DateTime endTime = dataPoints.last.time;

    DateTime currentBucketStart = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.hour,
      startTime.minute - (startTime.minute % bucketSizeInMinutes),
    );
    DateTime currentBucketEnd = currentBucketStart.add(Duration(minutes: bucketSizeInMinutes));

    List<HealthDataBucket> buckets = [];

    while (currentBucketStart.isBefore(endTime.add(const Duration(minutes: 1)))) {
      // Collect data points in this bucket
      List<Zone2HealthDataPoint> bucketDataPoints = dataPoints
          .where((dp) =>
              (dp.time.isAtSameMomentAs(currentBucketStart) ||
                  dp.time.isAfter(currentBucketStart)) &&
              dp.time.isBefore(currentBucketEnd))
          .toList();

      double averageHeartRate = 0.0;
      int predominantCardioZone = 0;
      double totalCaloriesBurned = 0.0;
      int totalSteps = 0;
      int totalZonePoints = 0;
      Map<int, int> cardioZoneMinutes = {};

      if (bucketDataPoints.isNotEmpty) {
        averageHeartRate = bucketDataPoints.map((dp) => dp.heartRate).reduce((a, b) => a + b) /
            bucketDataPoints.length;
        totalCaloriesBurned =
            bucketDataPoints.map((dp) => dp.caloriesBurned).reduce((a, b) => a + b);
        totalSteps = bucketDataPoints.map((dp) => dp.steps).reduce((a, b) => a + b);

        // Reset cardioZoneMinutes for this bucket
        cardioZoneMinutes = {};
        totalZonePoints = 0; // Reset zone points

        // Create a Set to track minutes we've already counted
        Set<DateTime> countedMinutes = {};

        for (var dp in bucketDataPoints) {
          // Only count if it's part of a valid streak and hasn't been counted yet
          if ((consecutiveZoneTimes[dp.cardioZone]?.contains(dp.time) ?? false) &&
              !countedMinutes.contains(dp.time)) {
            cardioZoneMinutes.update(
              dp.cardioZone,
              (count) => count + 1,
              ifAbsent: () => 1,
            );
            // Add zone points only for consecutive minutes
            totalZonePoints += _getZonePoints(dp.cardioZone);
            countedMinutes.add(dp.time);
          }
        }
      }

      buckets.add(HealthDataBucket(
        startTime: currentBucketStart,
        endTime: currentBucketEnd,
        averageHeartRate: averageHeartRate,
        predominantCardioZone: predominantCardioZone,
        totalCaloriesBurned: totalCaloriesBurned,
        totalSteps: totalSteps,
        totalZonePoints: totalZonePoints,
        cardioZoneMinutes: cardioZoneMinutes,
      ));

      // Move to next bucket
      currentBucketStart = currentBucketEnd;
      currentBucketEnd = currentBucketEnd.add(Duration(minutes: bucketSizeInMinutes));
    }

    _totalZonePoints = buckets.map((bucket) => bucket.totalZonePoints).reduce((a, b) => a + b);

    return buckets;
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

  /// Generates health data points by combining all health metrics.
  static List<Zone2HealthDataPoint> _generateHealthDataPoints(
      Map<DateTime, double> heartRateTimeSeries,
      Map<DateTime, double> calorieTimeSeries,
      Map<DateTime, int> stepTimeSeries,
      int userAge) {
    List<Zone2HealthDataPoint> dataPoints = [];

    Set<DateTime> allTimes = {};
    allTimes.addAll(heartRateTimeSeries.keys);
    allTimes.addAll(calorieTimeSeries.keys);
    allTimes.addAll(stepTimeSeries.keys);

    List<DateTime> sortedTimes = allTimes.toList()..sort();

    for (var time in sortedTimes) {
      double heartRate = heartRateTimeSeries[time] ?? 0.0;
      double caloriesBurned = calorieTimeSeries[time] ?? 0.0;
      int steps = stepTimeSeries[time] ?? 0;
      int cardioZone = _getCardioZone(heartRate, userAge);

      // Set initial zone points to 0 - they'll be calculated in _bucketHealthData
      int zonePoints = 0;

      dataPoints.add(Zone2HealthDataPoint(
        time: time,
        heartRate: heartRate,
        cardioZone: cardioZone,
        caloriesBurned: caloriesBurned,
        steps: steps,
        zonePoints: zonePoints,
      ));
    }

    return dataPoints;
  }

  /// Calculate summary statistics from bucket data
  static void _calculateSummaryStatistics(int bucketSizeInMinutes) {
    _totalSteps = 0;
    _totalCaloriesBurned = 0.0;
    _zoneMinutes.updateAll((key, value) => 0);

    for (var bucket in _buckets) {
      _totalSteps += bucket.totalSteps;
      _totalCaloriesBurned += bucket.totalCaloriesBurned;

      bucket.cardioZoneMinutes.forEach((zone, minutes) {
        _zoneMinutes[zone] = (_zoneMinutes[zone] ?? 0) + minutes;
      });
    }
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
}

/// New class to hold zone configuration
class ZoneConfig {
  final String name;
  final Color color;
  final double minPercentage;
  final double maxPercentage;
  final IconData icon;

  const ZoneConfig({
    required this.name,
    required this.color,
    required this.minPercentage,
    required this.maxPercentage,
    required this.icon,
  });
}
