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

/// Class representing a combined data point of health metrics.
class Zone2HealthDataPoint {
  final DateTime time;
  final double heartRate;
  final int cardioZone;
  final double caloriesBurned;
  final int steps;
  final int zonePoints;

  Zone2HealthDataPoint({
    required this.time,
    required this.heartRate,
    required this.cardioZone,
    required this.caloriesBurned,
    required this.steps,
    required this.zonePoints,
  });
}

/// Class representing a bucketed summary of health data.
class HealthDataBucket {
  final DateTime startTime;
  final DateTime endTime;
  final double averageHeartRate;
  final int predominantCardioZone;
  final double totalCaloriesBurned;
  final int totalSteps;
  final int totalZonePoints;
  final Map<int, int> cardioZoneMinutes;

    HealthDataBucket({
    required this.startTime,
    required this.endTime,
    required this.averageHeartRate,
    required this.predominantCardioZone,
    required this.totalCaloriesBurned,
    required this.totalSteps,
    required this.totalZonePoints,
    required this.cardioZoneMinutes,
  });
}
