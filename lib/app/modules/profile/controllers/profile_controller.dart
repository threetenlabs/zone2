import 'package:zone2/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/services/theme_service.dart';

class ProfileController extends GetxController {
  final logger = Get.find<Logger>();
  final authService = Get.find<AuthService>();
  final count = 0.obs;

  late final TextEditingController userNameController;

  final settings = SharedPreferencesService.to;

  @override
  void onInit() async {
    logger.i('ProfileController onInit');
    super.onInit();

    userNameController = TextEditingController(text: authService.appUser.value.name);

    ever(ThemeService.to.isDarkMode, (value) {
      logger.i('darkMode: $value');
      update();
    });

    settings.darkMode.stream.listen((value) {
      logger.i('darkMode: $value');
      update();
    });
  }

  void increment() => count.value++;
}
