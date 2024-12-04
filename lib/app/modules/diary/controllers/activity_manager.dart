import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/activity.dart';
import 'package:get/get.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/services/auth_service.dart';

/// Class to manage and process health activity data
class HealthActivityManager {
  final logger = Get.find<Logger>();
  // Convert static lists to RxList
  final heartRateRecords = RxList<HeartRateRecord>([]);
  // final calorieRecords = RxList<CalorieBurnedRecord>([]);
  // final hourlyCalorieRecords = RxList<CalorieBurnedRecord>([]);
  final hourlyZonePointRecords = RxList<ZonePointRecord>([]);
  final hourlyStepRecords = RxList<StepRecord>([]);
  final stepRecords = RxList<StepRecord>([]);
  final workoutRecords = RxList<WorkoutRecord>([]);

  // Aggregate records by day and month
  final dailyStepRecords = RxList<StepRecord>([]);
  final dailyCalorieRecords = RxList<CalorieBurnedRecord>([]);
  final dailyZonePointRecords = RxList<ZonePointRecord>([]);
  final monthlyStepRecords = RxList<StepRecord>([]);
  final monthlyCalorieRecords = RxList<CalorieBurnedRecord>([]);
  final monthlyZonePointRecords = RxList<ZonePointRecord>([]);

  // Convert statistics to Rx
  final totalSteps = 0.obs;
  final totalCaloriesBurned = 0.0.obs;
  final totalZonePoints = 0.obs;
  final multipleCalorieSources = false.obs;
  final totalWorkoutCalories = 0.0.obs;
  final totalActiveZoneMinutes = 0.obs;

  final zone2User = Rxn<Zone2User>();

  final isActivityLogged = false.obs;

  // Convert zone minutes to RxMap
  final zoneMinutes = RxMap<int, int>({
    1: 0, // Very Light
    2: 0, // Light
    3: 0, // Moderate
    4: 0, // Hard
    5: 0, // Maximum
  });

  final filteredZoneMinutes = RxMap<int, int>({});

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

  HealthActivityManager() {
    AuthService.to.appUser.stream.listen((user) {
      zone2User.value = user;
      _calculateTotals();
    });
  }

  /// Process activity data and store results
  void processDailyActivityData({
    required List<HealthDataPoint> activityData,
    required int userAge,
  }) {
    // Reset all stored values
    _resetAllValues();

    // Parse records
    heartRateRecords.value = _parseHeartRateData(
        activityData.where((data) => data.type == HealthDataType.HEART_RATE).toList());
    // calorieRecords.value = parseCalorieData(
    //     activityData.where((data) => data.type == HealthDataType.TOTAL_CALORIES_BURNED).toList());
    stepRecords.value =
        _parseStepData(activityData.where((data) => data.type == HealthDataType.STEPS).toList());
    workoutRecords.value = _parseWorkoutData(
        activityData.where((data) => data.type == HealthDataType.WORKOUT).toList());

    multipleCalorieSources.value =
        activityData.map((record) => record.sourceName).toSet().length > 1;

    // Process heart rate zones
    _processHeartRateZones(userAge);

    // Process steps by hour
    _processStepsByHour();

    // Calculate totals
    _calculateTotals();
  }

  void processAggregatedActivityData({
    required List<HealthDataPoint> activityData,
    required int userAge,
  }) {
    // Reset all stored values
    _resetAllValues();

    // Parse records
    heartRateRecords.value = _parseHeartRateData(
        activityData.where((data) => data.type == HealthDataType.HEART_RATE).toList());
    // calorieRecords.value = parseCalorieData(
    //     activityData.where((data) => data.type == HealthDataType.TOTAL_CALORIES_BURNED).toList());
    stepRecords.value =
        _parseStepData(activityData.where((data) => data.type == HealthDataType.STEPS).toList());
    workoutRecords.value = _parseWorkoutData(
        activityData.where((data) => data.type == HealthDataType.WORKOUT).toList());

    // multipleCalorieSources.value =
    //     calorieRecords.map((record) => record.sourceName).toSet().length > 1;

    // Process steps by day
    _processStepsByDayAndMonth();

    // Process zone points by day
    _processZonePointsByDayAndMonth(userAge);

    // Calculate totals
    _calculateTotals();
  }

  /// Process heart rate data to identify zones
  void _processHeartRateZones(int userAge) {
    if (heartRateRecords.isEmpty) return;

    // Reset zone minutes
    zoneMinutes.updateAll((key, value) => 0);
    totalZonePoints.value = 0;

    // Track processed minutes to avoid duplicates
    Set<DateTime> processedMinutes = {};

    // Create a map to store hourly zone points
    Map<DateTime, int> hourlyZonePoints = {};

    for (var record in heartRateRecords) {
      DateTime minuteKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
        record.dateFrom.hour,
        record.dateFrom.minute,
      );

      // Skip if this minute has already been processed
      if (processedMinutes.contains(minuteKey)) {
        logger.i('Skipping duplicate minute: $minuteKey');
        continue;
      }

      processedMinutes.add(minuteKey);

      int zone = _getCardioZone(record.numericValue, userAge);

      // Increment zone minutes
      zoneMinutes[zone] = (zoneMinutes[zone] ?? 0) + 1;

      // Only consider zones 2 to 5 for hourly zone points
      if (zone >= 2 && zone <= 5) {
        // Calculate zone points for the current minute
        int zonePoints = _getZonePoints(zone);

        // Calculate the hour key
        DateTime hourKey = DateTime(
          record.dateFrom.year,
          record.dateFrom.month,
          record.dateFrom.day,
          record.dateFrom.hour,
        );

        // Increment hourly zone points
        hourlyZonePoints[hourKey] = (hourlyZonePoints[hourKey] ?? 0) + zonePoints;
      }
    }

    // Calculate total zone points based on minutes in each zone
    totalZonePoints.value = zoneMinutes.entries.fold(0, (sum, entry) {
      return sum + (_getZonePoints(entry.key) * entry.value);
    });

    totalActiveZoneMinutes.value = filteredZoneMinutes.values.isEmpty
        ? 1 // Avoid division by zero
        : filteredZoneMinutes.values.reduce((a, b) => a + b);

    filteredZoneMinutes.value = Map.fromEntries(zoneMinutes.entries.where((entry) {
      int zoneNumber = entry.key;
      return zoneNumber >= 2 && zoneNumber <= 5;
    }));

    // Convert hourly zone points to ZonePointRecord list
    hourlyZonePointRecords.value = hourlyZonePoints.entries.map((entry) {
      return ZonePointRecord(
        uuid: 'hourly_zone_${entry.key.toString()}',
        zonePoints: entry.value,
        dateFrom: entry.key,
        dateTo: entry.key.add(const Duration(hours: 1)),
        sourceName: 'hourly',
      );
    }).toList()
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
  }

  // // Add this new method to bucket calories by hour
  // void _processCaloriesByHour() {
  //   if (calorieRecords.isEmpty) return;

  //   // Create a map to store hourly totals
  //   Map<DateTime, double> hourlyTotals = {};

  //   // Get the date from the first record, or use current date if no records
  //   DateTime firstDate = calorieRecords.isEmpty
  //       ? DateTime.now()
  //       : DateTime(
  //           calorieRecords.first.dateFrom.year,
  //           calorieRecords.first.dateFrom.month,
  //           calorieRecords.first.dateFrom.day,
  //         );

  //   // Initialize all hours with 0 calories
  //   for (int hour = 0; hour < 24; hour++) {
  //     DateTime hourKey = firstDate.add(Duration(hours: hour));
  //     hourlyTotals[hourKey] = 0;
  //   }

  //   // Track processed time ranges to avoid double counting
  //   Set<String> processedRanges = {};

  //   // Sum up calories for each hour, avoiding duplicates
  //   for (var record in calorieRecords) {
  //     String timeRange = '${record.dateFrom}-${record.dateTo}';
  //     if (processedRanges.contains(timeRange)) continue;

  //     DateTime hourKey = DateTime(
  //       record.dateFrom.year,
  //       record.dateFrom.month,
  //       record.dateFrom.day,
  //       record.dateFrom.hour,
  //     );
  //     hourlyTotals[hourKey] = (hourlyTotals[hourKey] ?? 0) + record.numericValue;
  //     processedRanges.add(timeRange);
  //   }

  //   // Convert back to CalorieBurnedRecord list
  //   hourlyCalorieRecords.value = hourlyTotals.entries.map((entry) {
  //     return CalorieBurnedRecord(
  //       numericValue: entry.value,
  //       dateFrom: entry.key,
  //       dateTo: entry.key.add(const Duration(hours: 1)),
  //       sourceName: 'hourly',
  //       uuid: 'hourly_${entry.key.toString()}',
  //       unit: 'KILOCALORIE',
  //     );
  //   }).toList()
  //     ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
  // }

  void _processStepsByHour() {
    if (stepRecords.isEmpty) return;

    // Create a map to store hourly totals
    Map<DateTime, int> hourlyTotals = {};

    // Get the date from the first record, or use current date if no records
    DateTime firstDate = stepRecords.isEmpty
        ? DateTime.now()
        : DateTime(
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

    // Track processed time ranges to avoid double counting
    // Set<String> processedRanges = {};

    // Only use calories from regular records, with deduplication
    // totalCaloriesBurned.value = calorieRecords.fold(0.0, (sum, record) {
    //   String timeRange = '${record.dateFrom}-${record.dateTo}';
    //   if (processedRanges.contains(timeRange)) return sum;

    //   processedRanges.add(timeRange);
    //   return sum + record.numericValue;
    // });

    totalWorkoutCalories.value =
        workoutRecords.fold(0.0, (sum, record) => sum + record.totalEnergyBurned);

    isActivityLogged.value = workoutRecords.isNotEmpty ||
        totalSteps.value >= (zone2User.value?.zoneSettings?.dailyStepsGoal ?? 0) ||
        totalWorkoutCalories.value > 0;
  }

  /// Reset all stored values to their defaults
  void _resetAllValues() {
    heartRateRecords.clear();
    // calorieRecords.clear();
    stepRecords.clear();
    workoutRecords.clear();
    totalSteps.value = 0;
    totalCaloriesBurned.value = 0.0;
    zoneMinutes.updateAll((key, value) => 0);
    filteredZoneMinutes.value = {};
    totalActiveZoneMinutes.value = 0;
    dailyZonePointRecords.clear();
    dailyStepRecords.clear();
    dailyCalorieRecords.clear();
    monthlyStepRecords.clear();
    monthlyCalorieRecords.clear();
    monthlyZonePointRecords.clear();
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

  // Add this new method to bucket steps by day and month
  void _processStepsByDayAndMonth() {
    if (stepRecords.isEmpty) return;

    // Create maps to store daily and monthly totals
    Map<DateTime, int> dailyTotals = {};
    Map<DateTime, int> monthlyTotals = {};

    // Sum up steps for each day and month
    for (var record in stepRecords) {
      DateTime dayKey = DateTime(record.dateFrom.year, record.dateFrom.month, record.dateFrom.day);
      DateTime monthKey = DateTime(record.dateFrom.year, record.dateFrom.month);

      dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + record.numericValue.toInt();
      monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) + record.numericValue.toInt();
    }

    // Convert daily totals back to StepRecord list
    dailyStepRecords.value = RxList<StepRecord>(dailyTotals.entries.map((entry) {
      return StepRecord(
        numericValue: entry.value,
        dateFrom: entry.key,
        dateTo: entry.key.add(const Duration(days: 1)),
        uuid: 'daily_${entry.key.toString()}',
        unit: 'COUNT',
      );
    }).toList());

    // Convert monthly totals back to StepRecord list
    monthlyStepRecords.value = RxList<StepRecord>(monthlyTotals.entries.map((entry) {
      return StepRecord(
        numericValue: entry.value,
        dateFrom: entry.key,
        dateTo: DateTime(entry.key.year, entry.key.month + 1).subtract(const Duration(days: 1)),
        uuid: 'monthly_${entry.key.toString()}',
        unit: 'COUNT',
      );
    }).toList());
  }

  // // Add this new method to bucket calories by day
  // void _processCaloriesByDay() {
  //   if (workoutRecords.isEmpty) return;

  //   // Create a map to store daily totals
  //   Map<DateTime, double> dailyTotals = {};

  //   // Sum up calories for each day
  //   for (var record in workoutRecords) {
  //     DateTime dayKey = DateTime(
  //       record.dateFrom.year,
  //       record.dateFrom.month,
  //       record.dateFrom.day,
  //     );
  //     dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + record.totalEnergyBurned;
  //   }

  //   // Convert back to CalorieBurnedRecord list
  //   // Assuming you want to store this in a new RxList
  //   dailyCalorieRecords.value = RxList<CalorieBurnedRecord>(dailyTotals.entries.map((entry) {
  //     return CalorieBurnedRecord(
  //       numericValue: entry.value,
  //       dateFrom: entry.key,
  //       dateTo: entry.key.add(const Duration(days: 1)),
  //       sourceName: 'daily',
  //       uuid: 'daily_${entry.key.toString()}',
  //       unit: 'KILOCALORIE',
  //     );
  //   }).toList());
  // }

  void _processZonePointsByDayAndMonth(int userAge) {
    if (heartRateRecords.isEmpty) return;

    // Create maps to store daily and monthly totals
    Map<DateTime, int> dailyZonePoints = {};
    Map<DateTime, int> monthlyZonePoints = {};

    // Track processed minutes to avoid duplicates
    Set<DateTime> processedMinutes = {};

    for (var record in heartRateRecords) {
      DateTime minuteKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
        record.dateFrom.hour,
        record.dateFrom.minute,
      );

      // Skip if this minute has already been processed
      if (processedMinutes.contains(minuteKey)) continue;

      processedMinutes.add(minuteKey);

      int zone = _getCardioZone(record.numericValue, userAge);
      if (zone < 2 || zone > 5) continue; // Only consider zones 2 to 5

      DateTime dayKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
        record.dateFrom.day,
      );

      DateTime monthKey = DateTime(
        record.dateFrom.year,
        record.dateFrom.month,
      );

      // Add zone points for the current record
      dailyZonePoints[dayKey] = (dailyZonePoints[dayKey] ?? 0) + _getZonePoints(zone);
      monthlyZonePoints[monthKey] = (monthlyZonePoints[monthKey] ?? 0) + _getZonePoints(zone);
    }

    // Convert daily totals back to ZonePointRecord list
    dailyZonePointRecords.value = RxList<ZonePointRecord>(dailyZonePoints.entries.map((entry) {
      return ZonePointRecord(
        uuid: 'zone_daily_${entry.key.toString()}',
        zonePoints: entry.value,
        dateFrom: entry.key,
        dateTo: entry.key.add(const Duration(days: 1)),
        sourceName: 'daily',
      );
    }).toList());

    // Convert monthly totals back to ZonePointRecord list
    monthlyZonePointRecords.value = RxList<ZonePointRecord>(monthlyZonePoints.entries.map((entry) {
      return ZonePointRecord(
        uuid: 'zone_monthly_${entry.key.toString()}',
        zonePoints: entry.value,
        dateFrom: entry.key,
        dateTo: DateTime(entry.key.year, entry.key.month + 1).subtract(const Duration(days: 1)),
        sourceName: 'monthly',
      );
    }).toList());
  }
}
