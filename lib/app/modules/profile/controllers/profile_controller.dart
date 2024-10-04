import 'package:zone2/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';

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

    settings.darkModeStream.listen((value) {
      logger.i('darkMode: $value');
      update();
    });

    // if (authService.appUser.value.svgString.isEmpty) {
    //   logger.i('No SVG String found, setting default Fluttermoji');
    //   //fluttermojiController.setFluttermoji(fluttermojiNew: json.encode(defaultFluttermoji));
    // } else {
    //   logger.i('SVG String found, setting Fluttermoji from SVG');
    //   //fluttermojiController.setFluttermoji(
    //   //fluttermojiNew: json.encode(authService.bedlamUser.value.svgString));
    // }

    // logger.i('fluttermojiController: ${fluttermojiController.fluttermoji}');
  }

  void increment() => count.value++;

  void updateUsername(String userName) {
    logger.i('updating User Name: $userName');

    authService.appUser.update((user) {
      user?.name = userNameController.text;
      logger.i('updating User Name: ${user?.name}');
    });
    authService.updateUserDetails(authService.appUser.value);
  }
}
