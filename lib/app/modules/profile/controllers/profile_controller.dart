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

  late final TextEditingController dailyWaterGoalController;
  late final TextEditingController dailyZonePointsGoalController;
  late final TextEditingController dailyCalorieIntakeGoalController;
  late final TextEditingController dailyCaloriesBurnedGoalController;
  late final TextEditingController dailyStepsGoalController;

  final settings = SharedPreferencesService.to;
  final isDirty = false.obs;

  var zone2ProteinTarget = 0.0.obs;
  var zone2CarbsTarget = 0.0.obs;
  var zone2FatTarget = 0.0.obs;

  @override
  void onInit() async {
    logger.i('ProfileController onInit');
    super.onInit();
    // Initialize TextEditingControllers for ZoneSettings
    final zoneSettings = authService.appUser.value.zoneSettings;
    dailyWaterGoalController =
        TextEditingController(text: zoneSettings?.dailyWaterGoalInOz.toString() ?? '');
    dailyZonePointsGoalController =
        TextEditingController(text: zoneSettings?.dailyZonePointsGoal.toString() ?? '');
    dailyCalorieIntakeGoalController =
        TextEditingController(text: zoneSettings?.dailyCalorieIntakeGoal.toString() ?? '');
    dailyStepsGoalController =
        TextEditingController(text: zoneSettings?.dailyStepsGoal.toString() ?? '');

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

  void increment() => count.value++;

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
      dailyWaterGoalController.text = goal.toString();
      markDirty();
    }
  }

  // Method to update daily zone points goal
  void setDailyZonePointsGoal(int goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyZonePointsGoal = goal;
      dailyZonePointsGoalController.text = goal.toString();
      markDirty();
    }
  }

  // Method to update daily calorie intake goal
  void setDailyCalorieIntakeGoal(double goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyCalorieIntakeGoal = goal;
      dailyCalorieIntakeGoalController.text = goal.toString();
      markDirty();
    }
  }

  // Method to update daily steps goal
  void setDailyStepsGoal(int goal) {
    if (authService.appUser.value.zoneSettings != null) {
      authService.appUser.value.zoneSettings!.dailyStepsGoal = goal;
      dailyStepsGoalController.text = goal.toString();
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
