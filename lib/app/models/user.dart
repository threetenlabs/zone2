//User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Zone2User {
  final String uid;
  final String email;
  String name;
  final bool onboardingComplete;
  ZoneSettings? zoneSettings;
  Zone2User(
      {required this.uid,
      required this.email,
      required this.name,
      required this.onboardingComplete,
      this.zoneSettings});

  factory Zone2User.fromJson(Map data) {
    return Zone2User(
        uid: data['uid'],
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        onboardingComplete: data['onboardingComplete'] ?? false,
        zoneSettings: ZoneSettings.fromJson(data['zoneSettings'] ?? {}));
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "onboardingComplete": onboardingComplete,
        "zoneSettings": zoneSettings?.toJson() ?? {}
      };
}

class ZoneSettings {
  final Timestamp journeyStartDate;
  int dailyWaterGoalInOz;
  int dailyZonePointsGoal;
  double dailyCalorieIntakeGoal;
  int dailyStepsGoal;
  final String reasonForStartingJourney;
  final double initialWeightInLbs;
  final double targetWeightInLbs;
  final double heightInInches;
  final int heightInFeet;
  final String birthDate;
  final String gender;
  double zone2ProteinTarget;
  double zone2CarbsTarget;
  double zone2FatTarget;

  ZoneSettings(
      {required this.journeyStartDate,
      required this.dailyWaterGoalInOz,
      required this.dailyZonePointsGoal,
      required this.dailyCalorieIntakeGoal,
      required this.dailyStepsGoal,
      required this.reasonForStartingJourney,
      required this.initialWeightInLbs,
      required this.targetWeightInLbs,
      required this.heightInInches,
      required this.heightInFeet,
      required this.birthDate,
      required this.gender,
      required this.zone2ProteinTarget,
      required this.zone2CarbsTarget,
      required this.zone2FatTarget});

  factory ZoneSettings.fromJson(Map data) {
    return ZoneSettings(
        journeyStartDate: data['journeyStartDate'] as Timestamp? ?? Timestamp.now(),
        dailyWaterGoalInOz: (data['dailyWaterGoalInOz'] as num?)?.toInt() ?? 100,
        dailyZonePointsGoal: (data['dailyZonePointsGoal'] as num?)?.toInt() ?? 100,
        dailyCalorieIntakeGoal: (data['dailyCalorieIntakeGoal'] as num?)?.toDouble() ?? 0.0,
        dailyStepsGoal: (data['dailyStepsGoal'] as num?)?.toInt() ?? 10000,
        reasonForStartingJourney: data['reasonForStartingJourney'] as String? ?? '',
        initialWeightInLbs: (data['initialWeightInLbs'] as num?)?.toDouble() ?? 0.0,
        targetWeightInLbs: (data['targetWeightInLbs'] as num?)?.toDouble() ?? 0.0,
        heightInInches: (data['heightInInches'] as num?)?.toDouble() ?? 0.0,
        heightInFeet: (data['heightInFeet'] as num?)?.toInt() ?? 0,
        birthDate: data['birthDate'] as String? ?? '',
        gender: data['gender'] as String? ?? '',
        zone2ProteinTarget: (data['zone2ProteinTarget'] as num?)?.toDouble() ?? 0.0,
        zone2CarbsTarget: (data['zone2CarbsTarget'] as num?)?.toDouble() ?? 0.0,
        zone2FatTarget: (data['zone2FatTarget'] as num?)?.toDouble() ?? 0.0);
  }

  Map<String, dynamic> toJson() => {
        "journeyStartDate": journeyStartDate,
        "dailyWaterGoalInOz": dailyWaterGoalInOz,
        "dailyZonePointsGoal": dailyZonePointsGoal,
        "dailyCalorieIntakeGoal": dailyCalorieIntakeGoal,
        "dailyStepsGoal": dailyStepsGoal,
        "reasonForStartingJourney": reasonForStartingJourney,
        "initialWeightInLbs": initialWeightInLbs,
        "targetWeightInLbs": targetWeightInLbs,
        "heightInInches": heightInInches,
        "heightInFeet": heightInFeet,
        "birthDate": birthDate,
        "gender": gender,
        "zone2ProteinTarget": zone2ProteinTarget,
        "zone2CarbsTarget": zone2CarbsTarget,
        "zone2FatTarget": zone2FatTarget
      };
}
