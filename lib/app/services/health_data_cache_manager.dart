import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:health/health.dart';

class HealthDataCacheManager {
  final String prefix;
  final prefs = GetStorage();
  final logger = Get.find<Logger>();

  HealthDataCacheManager({
    required this.prefix,
  });

  String _encodeData(List<HealthDataPoint> data) {
    final jsonData = data.map((point) {
      var json = point.toJson();
      // Convert ISO dates to timestamps
      json['date_from'] = point.dateFrom.millisecondsSinceEpoch;
      json['date_to'] = point.dateTo.millisecondsSinceEpoch;
      json['source_id'] = point.sourceId;
      json['source_name'] = point.sourceName;
      return json;
    }).toList();

    return jsonEncode({
      'data': jsonData,
    });
  }

  Future<List<HealthDataPoint>> _decodeData(String jsonData) async {
    final Map<String, dynamic> decoded = jsonDecode(jsonData);
    final List<dynamic> dataList = decoded['data'] as List;

    return await Future.wait(dataList.map((item) async {
      final HealthDataPoint point = await fromCachedJson(
        item,
      );
      return point;
    }).toList());
  }

  Future<bool> cacheData(String key, List<HealthDataPoint> data, Duration ttl) async {
    try {
      final expirationTime = DateTime.now().add(ttl);

      await prefs.write('$prefix${key}_data', _encodeData(data));
      await prefs.write('$prefix${key}_expiration', expirationTime.toIso8601String());

      return true;
    } catch (e) {
      logger.e('Error caching data: $e');
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<List<HealthDataPoint>?> getData<T extends HealthValue>(String key) async {
    try {
      final String? jsonData = prefs.read('$prefix${key}_data');
      final String? expirationString = prefs.read('$prefix${key}_expiration');

      if (jsonData == null || expirationString == null) {
        return null;
      }

      final DateTime expiration = DateTime.parse(expirationString);
      if (DateTime.now().isAfter(expiration)) {
        await prefs.remove('$prefix${key}_data');
        await prefs.remove('$prefix${key}_expiration');
        return null;
      }

      return _decodeData(jsonData);
    } catch (e) {
      logger.e('Error retrieving data: $e');
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    await prefs.remove('$prefix${key}_data');
    await prefs.remove('$prefix${key}_expiration');
  }

  Future<HealthDataPoint> fromCachedJson(
    dynamic dataPoint,
  ) async {
    // Handling different [HealthValue] types
    HealthDataType dataType = HealthDataType.NUTRITION;
    HealthValue value;
    switch (dataPoint['type'] as String) {
      case 'NUTRITION':
        dataType = HealthDataType.NUTRITION;
        value =
            NutritionHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'WATER':
        dataType = HealthDataType.WATER;
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        value = NumericHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'WEIGHT':
        dataType = HealthDataType.WEIGHT;
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        value = NumericHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'TOTAL_CALORIES_BURNED':
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        dataType = HealthDataType.TOTAL_CALORIES_BURNED;
        value = NumericHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'HEART_RATE':
        dataType = HealthDataType.HEART_RATE;
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        value = NumericHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'WORKOUT':
        dataType = HealthDataType.WORKOUT;
        value = WorkoutHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      case 'STEPS':
        dataType = HealthDataType.STEPS;
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        value = NumericHealthValue.fromHealthDataPoint(dataPoint['value'] as Map<String, dynamic>);
      default:
        dataType = HealthDataType.WEIGHT;
        final valueJson = dataPoint['value'] as Map<String, dynamic>;
        valueJson['value'] = valueJson['numericValue'];
        value = NumericHealthValue.fromHealthDataPoint(valueJson);
    }

    final DateTime from = DateTime.fromMillisecondsSinceEpoch(dataPoint['date_from'] as int);
    final DateTime to = DateTime.fromMillisecondsSinceEpoch(dataPoint['date_to'] as int);
    final String sourceId = dataPoint["source_id"] as String;
    final String sourceName = dataPoint["source_name"] as String;
    final Map<String, dynamic>? metadata = dataPoint["metadata"] == null
        ? null
        : Map<String, dynamic>.from(dataPoint['metadata'] as Map);
    final unit = dataTypeToUnit[dataType] ?? HealthDataUnit.UNKNOWN_UNIT;
    final String? uuid = dataPoint["uuid"] as String?;

    // Set WorkoutSummary, if available.
    WorkoutSummary? workoutSummary;
    if (dataPoint["workout_type"] != null ||
        dataPoint["total_distance"] != null ||
        dataPoint["total_energy_burned"] != null ||
        dataPoint["total_steps"] != null) {
      workoutSummary = WorkoutSummary.fromHealthDataPoint(dataPoint);
    }

    var recordingMethod = dataPoint["recording_method"] as int?;

    return HealthDataPoint(
      uuid: uuid ?? "",
      value: value,
      type: dataType,
      unit: unit,
      dateFrom: from,
      dateTo: to,
      sourcePlatform: Health().platformType,
      sourceDeviceId: Health().deviceId,
      sourceId: sourceId,
      sourceName: sourceName,
      recordingMethod: RecordingMethod.fromInt(recordingMethod),
      workoutSummary: workoutSummary,
      metadata: metadata,
    );
  }
}
