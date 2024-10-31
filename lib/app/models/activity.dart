// health_data_processor.dart

import 'dart:convert';

/// Class representing a heart rate record.
class HeartRateRecord {
  final String uuid;
  final double numericValue;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;

  HeartRateRecord({
    required this.uuid,
    required this.numericValue,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
  });

  factory HeartRateRecord.fromJson(Map<String, dynamic> json) {
    return HeartRateRecord(
      uuid: json['uuid'],
      numericValue: (json['value']['numericValue'] as num).toDouble(),
      unit: json['unit'],
      dateFrom: DateTime.parse(json['dateFrom']),
      dateTo: DateTime.parse(json['dateTo']),
    );
  }
}

/// Class representing a calorie burned record.
class CalorieBurnedRecord {
  final String uuid;
  final double numericValue;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;

  CalorieBurnedRecord({
    required this.uuid,
    required this.numericValue,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
  });

  factory CalorieBurnedRecord.fromJson(Map<String, dynamic> json) {
    return CalorieBurnedRecord(
      uuid: json['uuid'],
      numericValue: (json['value']['numericValue'] as num).toDouble(),
      unit: json['unit'],
      dateFrom: DateTime.parse(json['dateFrom']),
      dateTo: DateTime.parse(json['dateTo']),
    );
  }
}

/// Class representing a step record.
class StepRecord {
  final String uuid;
  final int numericValue;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;

  StepRecord({
    required this.uuid,
    required this.numericValue,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
  });

  factory StepRecord.fromJson(Map<String, dynamic> json) {
    return StepRecord(
      uuid: json['uuid'],
      numericValue: (json['value']['numericValue'] as num).toInt(),
      unit: json['unit'],
      dateFrom: DateTime.parse(json['dateFrom']),
      dateTo: DateTime.parse(json['dateTo']),
    );
  }
}

/// Class representing a workout record.
class WorkoutRecord {
  final String uuid;
  final String workoutActivityType;
  final double totalEnergyBurned;
  final String totalEnergyBurnedUnit;
  final double totalDistance;
  final String totalDistanceUnit;
  final int totalSteps;
  final String totalStepsUnit;
  final DateTime dateFrom;
  final DateTime dateTo;

  WorkoutRecord({
    required this.uuid,
    required this.workoutActivityType,
    required this.totalEnergyBurned,
    required this.totalEnergyBurnedUnit,
    required this.totalDistance,
    required this.totalDistanceUnit,
    required this.totalSteps,
    required this.totalStepsUnit,
    required this.dateFrom,
    required this.dateTo,
  });

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    return WorkoutRecord(
      uuid: json['uuid'],
      workoutActivityType: value['workoutActivityType'],
      totalEnergyBurned: (value['totalEnergyBurned'] as num?)?.toDouble() ?? 0.0,
      totalEnergyBurnedUnit: value['totalEnergyBurnedUnit'] ?? '',
      totalDistance: (value['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalDistanceUnit: value['totalDistanceUnit'] ?? '',
      totalSteps: (value['totalSteps'] as num?)?.toInt() ?? 0,
      totalStepsUnit: value['totalStepsUnit'] ?? '',
      dateFrom: DateTime.parse(json['dateFrom']),
      dateTo: DateTime.parse(json['dateTo']),
    );
  }
}

/// Parses a list of JSON objects into HeartRateRecord instances.
List<HeartRateRecord> parseHeartRateData(List<dynamic> jsonData) {
  return jsonData.map((json) => HeartRateRecord.fromJson(json)).toList();
}

/// Parses a list of JSON objects into CalorieBurnedRecord instances.
List<CalorieBurnedRecord> parseCalorieData(List<dynamic> jsonData) {
  return jsonData.map((json) => CalorieBurnedRecord.fromJson(json)).toList();
}

/// Parses a list of JSON objects into StepRecord instances.
List<StepRecord> parseStepData(List<dynamic> jsonData) {
  return jsonData.map((json) => StepRecord.fromJson(json)).toList();
}

/// Parses a list of JSON objects into WorkoutRecord instances.
List<WorkoutRecord> parseWorkoutData(List<dynamic> jsonData) {
  return jsonData.map((json) => WorkoutRecord.fromJson(json)).toList();
}

/// Creates a time series map from heart rate records.
Map<DateTime, double> createHeartRateTimeSeries(List<HeartRateRecord> records) {
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
Map<DateTime, double> createCalorieTimeSeries(
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
Map<DateTime, int> createStepTimeSeries(List<StepRecord> records, List<WorkoutRecord> workouts) {
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
String getCardioZone(double heartRate, int age) {
  double maxHeartRate = (220 - age) as double;
  double percentage = (heartRate / maxHeartRate) * 100;

  if (percentage < 60) {
    return 'Zone 1 (Very Light)';
  } else if (percentage < 70) {
    return 'Zone 2 (Light)';
  } else if (percentage < 80) {
    return 'Zone 3 (Moderate)';
  } else if (percentage < 90) {
    return 'Zone 4 (Hard)';
  } else {
    return 'Zone 5 (Maximum)';
  }
}

/// Class representing a combined data point of health metrics.
class HealthDataPoint {
  final DateTime time;
  final double heartRate;
  final String cardioZone;
  final double caloriesBurned;
  final int steps;

  HealthDataPoint({
    required this.time,
    required this.heartRate,
    required this.cardioZone,
    required this.caloriesBurned,
    required this.steps,
  });
}

/// Generates health data points by combining all health metrics.
List<HealthDataPoint> generateHealthDataPoints(Map<DateTime, double> heartRateTimeSeries,
    Map<DateTime, double> calorieTimeSeries, Map<DateTime, int> stepTimeSeries, int userAge) {
  List<HealthDataPoint> dataPoints = [];

  Set<DateTime> allTimes = {};
  allTimes.addAll(heartRateTimeSeries.keys);
  allTimes.addAll(calorieTimeSeries.keys);
  allTimes.addAll(stepTimeSeries.keys);

  List<DateTime> sortedTimes = allTimes.toList()..sort();

  for (var time in sortedTimes) {
    double heartRate = heartRateTimeSeries[time] ?? 0.0;
    double caloriesBurned = calorieTimeSeries[time] ?? 0.0;
    int steps = stepTimeSeries[time] ?? 0;
    String cardioZone = getCardioZone(heartRate, userAge);

    dataPoints.add(HealthDataPoint(
      time: time,
      heartRate: heartRate,
      cardioZone: cardioZone,
      caloriesBurned: caloriesBurned,
      steps: steps,
    ));
  }

  return dataPoints;
}

/// Class representing a bucketed summary of health data.
class HealthDataBucket {
  final DateTime startTime;
  final DateTime endTime;
  final double averageHeartRate;
  final String predominantCardioZone;
  final double totalCaloriesBurned;
  final int totalSteps;

  HealthDataBucket({
    required this.startTime,
    required this.endTime,
    required this.averageHeartRate,
    required this.predominantCardioZone,
    required this.totalCaloriesBurned,
    required this.totalSteps,
  });
}

/// Buckets health data points into specified time frames.
List<HealthDataBucket> bucketHealthData(List<HealthDataPoint> dataPoints, int bucketSizeInMinutes) {
  if (dataPoints.isEmpty) {
    return [];
  }

  dataPoints.sort((a, b) => a.time.compareTo(b.time));

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
    List<HealthDataPoint> bucketDataPoints = dataPoints
        .where((dp) =>
            (dp.time.isAtSameMomentAs(currentBucketStart) || dp.time.isAfter(currentBucketStart)) &&
            dp.time.isBefore(currentBucketEnd))
        .toList();

    double averageHeartRate = 0.0;
    String predominantCardioZone = '';
    double totalCaloriesBurned = 0.0;
    int totalSteps = 0;

    if (bucketDataPoints.isNotEmpty) {
      averageHeartRate = bucketDataPoints.map((dp) => dp.heartRate).reduce((a, b) => a + b) /
          bucketDataPoints.length;
      totalCaloriesBurned = bucketDataPoints.map((dp) => dp.caloriesBurned).reduce((a, b) => a + b);
      totalSteps = bucketDataPoints.map((dp) => dp.steps).reduce((a, b) => a + b);

      // Determine predominant cardio zone
      Map<String, int> zoneCounts = {};
      for (var dp in bucketDataPoints) {
        zoneCounts.update(dp.cardioZone, (count) => count + 1, ifAbsent: () => 1);
      }
      predominantCardioZone = zoneCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    buckets.add(HealthDataBucket(
      startTime: currentBucketStart,
      endTime: currentBucketEnd,
      averageHeartRate: averageHeartRate,
      predominantCardioZone: predominantCardioZone,
      totalCaloriesBurned: totalCaloriesBurned,
      totalSteps: totalSteps,
    ));

    // Move to next bucket
    currentBucketStart = currentBucketEnd;
    currentBucketEnd = currentBucketEnd.add(Duration(minutes: bucketSizeInMinutes));
  }

  return buckets;
}

/// Processes the data and generates bucketed health data.
List<HealthDataBucket> processData(
    List<dynamic> heartRateJsonData,
    List<dynamic> calorieJsonData,
    List<dynamic> stepJsonData,
    List<dynamic> workoutJsonData,
    int bucketSizeInMinutes,
    int userAge) {
  // Parse JSON data
  List<HeartRateRecord> heartRateRecords = parseHeartRateData(heartRateJsonData);
  List<CalorieBurnedRecord> calorieRecords = parseCalorieData(calorieJsonData);
  List<StepRecord> stepRecords = parseStepData(stepJsonData);
  List<WorkoutRecord> workoutRecords = parseWorkoutData(workoutJsonData);

  // Create time series data
  Map<DateTime, double> heartRateTimeSeries = createHeartRateTimeSeries(heartRateRecords);
  Map<DateTime, double> calorieTimeSeries = createCalorieTimeSeries(calorieRecords, workoutRecords);
  Map<DateTime, int> stepTimeSeries = createStepTimeSeries(stepRecords, workoutRecords);

  // Generate health data points
  List<HealthDataPoint> dataPoints =
      generateHealthDataPoints(heartRateTimeSeries, calorieTimeSeries, stepTimeSeries, userAge);

  // Bucket data
  List<HealthDataBucket> buckets = bucketHealthData(dataPoints, bucketSizeInMinutes);

  // The 'buckets' list now contains the processed data
  // You can now pass 'buckets' to your visualization logic
  return buckets;
}

/// Example usage of the data processing functions.
void main() {
  // Example JSON data (replace with your actual data)
  List<dynamic> heartRateJsonData = [
    jsonDecode(
        '{"uuid":"3bab9eb6-9d8f-4751-b3c9-643c73dd1fd2","value":{"__type":"NumericHealthValue","numericValue":100},"type":"HEART_RATE","unit":"BEATS_PER_MINUTE","dateFrom":"2024-10-31T05:57:00.000","dateTo":"2024-10-31T05:57:00.000","sourcePlatform":"googleHealthConnect","sourceDeviceId":"unknown","sourceId":"","sourceName":"com.fitbit.FitbitMobile","recordingMethod":"unknown"}'),
    // Add more heart rate records here
  ];

  List<dynamic> calorieJsonData = [
    jsonDecode(
        '{"uuid":"1cf209d5-d393-4c39-9f43-e8c846fd48be","value":{"__type":"NumericHealthValue","numericValue":21.08977},"type":"TOTAL_CALORIES_BURNED","unit":"KILOCALORIE","dateFrom":"2024-10-31T00:15:00.000","dateTo":"2024-10-31T00:30:00.000","sourcePlatform":"googleHealthConnect","sourceDeviceId":"AP3A.241005.015","sourceId":"","sourceName":"com.fitbit.FitbitMobile","recordingMethod":"unknown"}'),
    // Add more calorie records here
  ];

  List<dynamic> stepJsonData = [
    jsonDecode(
        '{"uuid":"3a57ac69-1d40-4095-b947-fbc8046df15e","value":{"__type":"NumericHealthValue","numericValue":9},"type":"STEPS","unit":"COUNT","dateFrom":"2024-10-31T04:41:00.000","dateTo":"2024-10-31T04:42:00.000","sourcePlatform":"googleHealthConnect","sourceDeviceId":"AP3A.241005.015","sourceId":"","sourceName":"com.fitbit.FitbitMobile","recordingMethod":"unknown"}'),
    // Add more step records here
  ];

  List<dynamic> workoutJsonData = [
    jsonDecode(
        '{"uuid":"b7dd800b-a958-3958-b187-248c4c7a507d","value":{"__type":"WorkoutHealthValue","workoutActivityType":"OTHER","totalEnergyBurned":909,"totalEnergyBurnedUnit":"KILOCALORIE","totalDistance":3838,"totalDistanceUnit":"METER","totalSteps":5154,"totalStepsUnit":"COUNT"},"type":"WORKOUT","unit":"NO_UNIT","dateFrom":"2024-10-31T04:54:56.000","dateTo":"2024-10-31T06:08:16.000","sourcePlatform":"googleHealthConnect","sourceDeviceId":"AP3A.241005.015","sourceId":"","sourceName":"com.fitbit.FitbitMobile","recordingMethod":"unknown"}'),
    // Add more workout records here
  ];

  int bucketSizeInMinutes = 15; // You can change this to 15, 30, 60, etc.
  int userAge = 30; // Replace with the actual user's age

  List<HealthDataBucket> buckets = processData(
    heartRateJsonData,
    calorieJsonData,
    stepJsonData,
    workoutJsonData,
    bucketSizeInMinutes,
    userAge,
  );

  // Example: Print the buckets
  for (var bucket in buckets) {
    print(
        'Time: ${bucket.startTime} - ${bucket.endTime}, Avg HR: ${bucket.averageHeartRate.toStringAsFixed(1)}, '
        'Zone: ${bucket.predominantCardioZone}, Calories: ${bucket.totalCaloriesBurned.toStringAsFixed(2)}, '
        'Steps: ${bucket.totalSteps}');
  }
}
