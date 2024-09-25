import 'package:app/app/modules/profile/controllers/spicy_words.dart';
import 'package:app/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProfileController extends GetxController {
  final logger = Get.find<Logger>();
  final authService = Get.find<AuthService>();
  final count = 0.obs;

  final FluttermojiController fluttermojiController = FluttermojiController();
  late final TextEditingController userNameController;

  @override
  void onInit() async {
    logger.i('ProfileController onInit');
    super.onInit();

    userNameController = TextEditingController(text: authService.appUser.value.name);

    if (authService.appUser.value.svgString.isEmpty) {
      logger.i('No SVG String found, setting default Fluttermoji');
      //fluttermojiController.setFluttermoji(fluttermojiNew: json.encode(defaultFluttermoji));
    } else {
      logger.i('SVG String found, setting Fluttermoji from SVG');
      //fluttermojiController.setFluttermoji(
      //fluttermojiNew: json.encode(authService.bedlamUser.value.svgString));
    }

    logger.i('fluttermojiController: ${fluttermojiController.fluttermoji}');
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

  bool isUsernameValid(String? userName) {
    final NaughtyWordChecker checker = NaughtyWordChecker();

    if (userName == null ||
        userName.isEmpty ||
        userName.length < 3 ||
        userName.length > 20 ||
        checker.doesContainBadWords(userName)) {
      logger.i('Username is invalid');
      return false;
    }

    return true;
  }

  void saveFluttermoji() async {
    String svgConfig = await FluttermojiFunctions().encodeMySVGtoString();
    String svgString = FluttermojiFunctions().decodeFluttermojifromString(
      svgConfig,
    );
    authService.updateUserSvg(svgString, svgConfig);
  }
}
