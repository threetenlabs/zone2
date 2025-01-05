import 'package:zone2/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/services/theme_service.dart';
import 'package:zone2/app/services/firebase_service.dart';

class ProfileController extends GetxController {
  final logger = Get.find<Logger>();
  final authService = Get.find<AuthService>();
  final count = 0.obs;

  final openApiKeyVisible = false.obs;
  final TextEditingController openApiKeyController = TextEditingController();



  final settings = SharedPreferencesService.to;
  final isDirty = false.obs;

  final dailyWaterGoal = 0.obs;
  final dailyZonePointsGoal = 0.obs;
  final dailyCalorieIntakeGoal = 0.0.obs;
  final dailyStepsGoal = 0.obs;
  final zone2ProteinTarget = 0.0.obs;
  final zone2CarbsTarget = 0.0.obs;
  final zone2FatTarget = 0.0.obs;

  @override
  void onInit() async {
    logger.i('ProfileController onInit');
    super.onInit();

    ever(ThemeService.to.isDarkMode, (value) {
      logger.i('darkMode: $value');
      update();
    });

    settings.darkMode.stream.listen((value) {
      logger.i('darkMode: $value');
      update();
    });

    loadSharedPreferences();
  }

  @override
  void onReady() async {
    super.onReady();
    setZoneSettings();
    AuthService.to.appUser.stream.listen((user) async {
      setZoneSettings();
    });
  }

  Future<void> setZoneSettings() async {
    // Initialize TextEditingControllers with values from ZoneSettings
    final zoneSettings = authService.appUser.value.zoneSettings;
    dailyWaterGoal.value = zoneSettings?.dailyWaterGoalInOz ?? 0;
    dailyZonePointsGoal.value = zoneSettings?.dailyZonePointsGoal ?? 0;
    dailyCalorieIntakeGoal.value = zoneSettings?.dailyCalorieIntakeGoal ?? 0;
    dailyStepsGoal.value = zoneSettings?.dailyStepsGoal ?? 0;

    zone2ProteinTarget.value = zoneSettings?.zone2ProteinTarget ?? 0.0;
    zone2CarbsTarget.value = zoneSettings?.zone2CarbsTarget ?? 0.0;
    zone2FatTarget.value = zoneSettings?.zone2FatTarget ?? 0.0;
    isDirty.value = false;
  }

  void markDirty() {
    isDirty.value = true;
  }

  void saveSettings() async {
    // Call FirebaseService to save the updated settings
    final zoneSettings = authService.appUser.value.zoneSettings;
    if (zoneSettings != null) {
      await FirebaseService.to.updateUserZoneSettings(zoneSettings);
      isDirty.value = false;
      logger.i('Zone settings saved to Firestore');
      NotificationService.to.showSuccess('Success', 'Zone settings saved');
    }
  }

  // Method to update daily water goal
  void setDailyWaterGoal(int goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyWaterGoalInOz = goal;
      dailyWaterGoal.value = goal;
      markDirty();
    }
  }

  // Method to update daily zone points goal
  void setDailyZonePointsGoal(int goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyZonePointsGoal = goal;
        dailyZonePointsGoal.value = goal;
      markDirty();
    }
  }

  // Method to update daily calorie intake goal
  void setDailyCalorieIntakeGoal(double goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyCalorieIntakeGoal = goal;
      dailyCalorieIntakeGoal.value = goal;
      markDirty();
    }
  }

  // Method to update daily steps goal
  void setDailyStepsGoal(int goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyStepsGoal = goal;
      dailyStepsGoal.value = goal;
      markDirty();
    }
  }

  // Method to persist updated zone settings
  void updateZoneSettings() {
    // Implement logic to save the updated zone settings, e.g., to a database or shared preferences
    logger.i('Zone settings updated');
  }

  void loadSharedPreferences() {
    openApiKeyController.text = settings.openAIKey.value;
  }

  void setZone2ProteinTarget(double value) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.zone2ProteinTarget = value;
      zone2ProteinTarget.value = value;
      markDirty();
    }
  }

  void setZone2CarbsTarget(double value) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.zone2CarbsTarget = value;
      zone2CarbsTarget.value = value;
      markDirty();
    }
  }

  void setZone2FatTarget(double value) {
    zone2FatTarget.value = value;
    authService.appUser.value.zoneSettings!.zone2FatTarget = value;
    zone2FatTarget.value = value;
    markDirty();
  }

  void saveOpenAIKey() {
    settings.setOpenAIKey(openApiKeyController.text);
    NotificationService.to.showSuccess('Success', 'OpenAI Key saved');
    openApiKeyVisible.value = false;
  }
}
