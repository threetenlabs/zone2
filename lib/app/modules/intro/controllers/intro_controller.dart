import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/routes/app_pages.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class IntroController extends GetxController {
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  final introLogger = Get.find<Logger>();
  final showNextButton = true.obs;
  final showBackButton = false.obs;
  final showDoneButton = false.obs;
  final zone2Reason = ''.obs;
  final zone2Birthdate = ''.obs;
  final RxnString zone2Gender = RxnString(null);
  final invalidAge = ''.obs;
  final RxInt heightFeet = 3.obs; // Default height in feet
  final RxInt heightInches = 0.obs; // Default height in inches
  final weightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final suggestedWeightLossLowerBound = 0.0.obs;
  final suggestedWeightLossUpperBound = 0.0.obs;
  final suggestedWeightLossTarget = ''.obs;
  final zone2TargetWeight = 0.0.obs;
  final RxInt dailyWaterGoalInOz = 100.obs;
  final RxInt dailyZonePointsGoal = 100.obs;
  final RxInt dailyCalorieIntakeGoal = 1700.obs;
  final RxInt dailyCaloriesBurnedGoal = 0.obs;
  final RxInt dailyStepsGoal = 10000.obs;

  final suggestedWeightLossMessage =
      "We'll use your progress to predict when you'll hit your target as you follow your custom plan and adopting a healthy lifestyle. Your results cannot be guaranteed, but users typically lose 1-2 lb per week."
          .obs;

  @override
  void onInit() {
    super.onInit();
    //Don't show the introduction screen if the user has already seen it
    if (_sharedPreferencesService.isIntroductionFinished) {
      introLogger.i('Skipping Introduction Screen');
      Future.delayed(Duration.zero, () {
        Get.offNamed(Routes.home);
      });
    }
  }

  Future<bool> isValidDate(String date) async {
    try {
      DateFormat('MM-dd-yyyy').parse(date);
      return true; // Date is valid
    } catch (e) {
      return false; // Date is invalid
    }
  }

  Future<bool> isValidAge(DateTime birthdate) async {
    int age = DateTime.now().year - birthdate.year;
    // Adjust age if the birthday hasn't occurred yet this year
    if (DateTime.now().isBefore(DateTime(DateTime.now().year, birthdate.month, birthdate.day))) {
      age--;
    }
    final validAge = age > 13 && age < 90; // Check if age is between 14 and 89
    invalidAge.value =
        validAge ? '' : 'Please consult with your doctor if you are under 14 or over 89';
    return validAge;
  }

  Future<bool> isValidBirthdate() async {
    if (await isValidDate(zone2Birthdate.value)) {
      DateTime birthdate = DateFormat('MM-dd-yyyy').parse(zone2Birthdate.value);
      return await isValidAge(birthdate);
    }
    return false; // Birthdate is invalid
  }

  Future<bool> haveTheMotivatingFactor() async {
    return zone2Reason.value.isNotEmpty;
  }

  Future<void> setBirthdate(String birthdate) async {
    introLogger.i('setBirthdate: $birthdate');
    zone2Birthdate.value = birthdate;
    showNextButton.value = await haveAllDemographics();
  }

  Future<void> setGender(String gender) async {
    introLogger.i('setGender: $gender');
    zone2Gender.value = gender;
    showNextButton.value = await haveAllDemographics();
  }

  // Method to set height in feet
  Future<void> setHeightFeet(int feet) async {
    heightFeet.value = feet;
    showNextButton.value = await haveAllDemographics();
  }

  // Method to set height in inches
  Future<void> setHeightInches(int inches) async {
    heightInches.value = inches;
    showNextButton.value = await haveAllDemographics();
  }

  Future<void> setWeight(String weight) async {
    weightController.text = weight;
    showNextButton.value = await haveAllDemographics();
  }

  Future<void> setTargetWeight(String targetWeight) async {
    targetWeightController.text = targetWeight;
    showNextButton.value = await haveAllDemographics();
  }

  Future<bool> haveAllDemographics() async {
    return await isValidBirthdate() &&
        zone2Gender.value != null &&
        weightController.text.isNotEmpty &&
        heightFeet.value != 0 &&
        heightInches.value != 0;
  }

  Future<bool> haveGoals() async {
    return targetWeightController.text.isNotEmpty;
  }

  Future<void> setDailyWaterGoal(int goal) async {
    dailyWaterGoalInOz.value = goal;
    showNextButton.value = await haveAllGoals();
  }

  Future<void> setDailyZonePointsGoal(int goal) async {
    dailyZonePointsGoal.value = goal;
    showNextButton.value = await haveAllGoals();
  }

  Future<void> setDailyCalorieIntakeGoal(int goal) async {
    dailyCalorieIntakeGoal.value = goal;
    showNextButton.value = await haveAllGoals();
  }

  Future<void> setDailyCaloriesBurnedGoal(int goal) async {
    dailyCaloriesBurnedGoal.value = goal;
    showNextButton.value = await haveAllGoals();
  }

  Future<void> setDailyStepsGoal(int goal) async {
    dailyStepsGoal.value = goal;
    showNextButton.value = await haveAllGoals();
  }

  Future<bool> haveAllGoals() async {
    return dailyWaterGoalInOz.value != 0 &&
        dailyZonePointsGoal.value != 0 &&
        dailyCalorieIntakeGoal.value != 0 &&
        dailyCaloriesBurnedGoal.value != 0 &&
        dailyStepsGoal.value != 0;
  }

  Future<void> setReason(String reason) async {
    introLogger.i('setReason: $reason');
    zone2Reason.value = reason;
    showNextButton.value = await haveTheMotivatingFactor();
  }

  Future<bool> canBeDone() async {
    // TODO: Revisit this - IOS will always return null
    return HealthService.to.hasPermissions.value ?? true;
  }

  Future<void> requestHealthPermissions() async {
    await HealthService.to.authorize();
    showDoneButton.value = await canBeDone();
  }

  Future<void> onNext(int index) async {
    introLogger.i('onNext: $index');
    showBackButton.value = index >= 1;

    switch (index) {
      case 0: // Democratized Weight Loss
        showNextButton.value = true;
        break;
      case 1: // Demographic Profile
        showNextButton.value = await haveAllDemographics();
        break;
      case 2: // Suggest Weight Loss Target
        suggestWeightLossTarget();
        showNextButton.value = await haveGoals();
        break;
      case 3:
        showNextButton.value = await haveAllGoals();
        break;
      case 4:
        showNextButton.value = await haveTheMotivatingFactor();
        break;
      case 5:
        showNextButton.value = false;
        await requestHealthPermissions();
        break;
    }
  }

  //create a method called onFinish that saves a boolean called introFinished to sharedPreferences
  void onFinish() {
    _sharedPreferencesService.setIsIntroductionFinished(true);
    introLogger.i('Introduction Finished');
    FirebaseService.to.updateUserZoneSettings(ZoneSettings(
        journeyStartDate: Timestamp.now(),
        dailyWaterGoalInOz: dailyWaterGoalInOz.value,
        dailyZonePointsGoal: dailyZonePointsGoal.value,
        dailyCalorieIntakeGoal: dailyCalorieIntakeGoal.value,
        dailyCaloriesBurnedGoal: dailyCaloriesBurnedGoal.value,
        dailyStepsGoal: dailyStepsGoal.value,
        reasonForStartingJourney: zone2Reason.value,
        initialWeightInLbs: double.parse(weightController.text),
        targetWeightInLbs: double.parse(targetWeightController.text),
        heightInInches: heightInches.value.toDouble(),
        heightInFeet: heightFeet.value.toInt(),
        birthDate: zone2Birthdate.value,
        gender: zone2Gender.value!));

    introLogger.i('Introduction Finished');
    Get.offNamed(Routes.home);
  }

  // Method to calculate BMI
  double calculateBMI() {
    double heightInMeters = (heightFeet.value * 0.3048) + (heightInches.value * 0.0254);
    double weightInPounds = double.tryParse(weightController.text) ?? 0;
    double weightInKg = lbsToKg(weightInPounds); // Convert pounds to kilograms
    return weightInKg / (heightInMeters * heightInMeters);
  }

  // Method to convert kilograms to pounds
  double kgToPounds(double kg) {
    return kg * 2.20462; // 1 kg = 2.20462 pounds
  }

  double lbsToKg(double lbs) {
    return lbs / 2.20462; // 1 pound = 2.20462 kilograms
  }

  // Method to suggest weight loss target based on BMI
  void suggestWeightLossTarget() {
    double currentWeight = double.tryParse(weightController.text) ?? 0;
    double bmi = calculateBMI();

    // Calculate target weight for BMI range of 18.5 - 25
    double targetLowerBound = 0;
    double targetUpperBound = 0;
    const double heightInMeters = (5 * 0.3048) + (10 * 0.0254); // 5'10" in meters
    const double bmiLowerBound = 18.5;
    const double bmiUpperBound = 25;

    if (bmi > bmiLowerBound) {
      targetLowerBound =
          bmiLowerBound * (heightInMeters * heightInMeters) * 2.20462; // Convert kg to lbs
      targetUpperBound =
          bmiUpperBound * (heightInMeters * heightInMeters) * 2.20462; // Convert kg to lbs
    } else {
      suggestedWeightLossLowerBound.value = currentWeight;
      suggestedWeightLossUpperBound.value = currentWeight;
      suggestedWeightLossMessage.value =
          "We recommend working with your doctor to pursue weight loss when your BMI is below 18.5.";
      return;
    }

    // Calculate maximum allowable weight loss
    double maxWeightLoss = currentWeight * 0.30;
    double suggestedWeightLoss = currentWeight - targetLowerBound;

    // Adjust suggested weight loss if it exceeds 30%
    if (suggestedWeightLoss > maxWeightLoss) {
      targetLowerBound = currentWeight - (currentWeight * 0.29);
      targetUpperBound = currentWeight - (currentWeight * 0.25);
      suggestedWeightLossLowerBound.value = targetLowerBound;
      suggestedWeightLossUpperBound.value = targetUpperBound;
    } else {
      suggestedWeightLossLowerBound.value = targetLowerBound;
      suggestedWeightLossUpperBound.value = targetUpperBound;
    }
    suggestedWeightLossTarget.value =
        "(Recommended: ${targetLowerBound.toStringAsFixed(0)} - ${targetUpperBound.toStringAsFixed(0)} lbs)";
  }
}
