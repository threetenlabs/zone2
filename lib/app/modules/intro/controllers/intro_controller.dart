import 'package:zone2/app/routes/app_pages.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class IntroController extends GetxController {
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  final introLogger = Get.find<Logger>();

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

  //create a method called onFinish that saves a boolean called introFinished to sharedPreferences
  void onFinish() {
    _sharedPreferencesService.setIsIntroductionFinished(true);
    introLogger.i('Introduction Finished');
    Get.offNamed(Routes.home);
  }
}
