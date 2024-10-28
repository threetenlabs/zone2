import 'package:intl/intl.dart';
import 'package:zone2/app/routes/app_pages.dart';
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

  Future<void> setReason(String reason) async {
    introLogger.i('setReason: $reason');
    zone2Reason.value = reason;
    showNextButton.value = await canAdvanceToToDeatils();
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

  Future<bool> canAdvanceToToDeatils() async {
    return zone2Reason.value.isNotEmpty;
  }

  Future<void> setBirthdate(String birthdate) async {
    introLogger.i('setBirthdate: $birthdate');
    zone2Birthdate.value = birthdate;
    showNextButton.value = await canAdvanceToPreferences();
  }

  Future<void> setGender(String gender) async {
    introLogger.i('setGender: $gender');
    zone2Gender.value = gender;
    showNextButton.value = await canAdvanceToPreferences();
  }

  Future<bool> canAdvanceToPreferences() async {
    return await isValidBirthdate() && zone2Gender.value != null;
  }

  Future<bool> canBeDone() async {
    return HealthService.to.hasPermissions.value ?? false;
  }

  Future<void> requestHealthPermissions() async {
    await HealthService.to.authorize();
    showDoneButton.value = await canBeDone();
  }

  Future<void> onNext(int index) async {
    introLogger.i('onNext: $index');
    showBackButton.value = index >= 1;

    switch (index) {
      case 0:
        showNextButton.value = true;
        break;
      case 1:
        showNextButton.value = await canAdvanceToToDeatils();
        break;
      case 2:
        showNextButton.value = await canAdvanceToPreferences();
        break;
      case 3:
        showNextButton.value = false;
        await requestHealthPermissions();
        break;
    }
  }



  //create a method called onFinish that saves a boolean called introFinished to sharedPreferences
  void onFinish() {
    _sharedPreferencesService.setIsIntroductionFinished(true);
    introLogger.i('Introduction Finished');
    Get.offNamed(Routes.home);
  }
}
