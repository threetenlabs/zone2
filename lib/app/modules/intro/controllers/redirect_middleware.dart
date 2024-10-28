import 'package:zone2/app/routes/app_pages.dart';
import 'package:zone2/app/services/forced_update_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class RedirectMiddleware extends GetMiddleware {
  final remoteConfig = Get.find<FirebaseRemoteConfig>();
  final logger = Get.find<Logger>();

  @override
  RouteSettings? redirect(String? route) {
    final sharedPrefs = Get.find<SharedPreferencesService>();
    final forcedUpdateService = Get.find<ForcedUpdateService>();

    // Lot of if's,
    // if the user is below the minimum version the only screen they will see is forced update
    // if they are logged in they should see either the home or intro depending if they've seen it already
    // if they are not logged in they should see the login screen

    if (forcedUpdateService.isAboveMinimumSupportedVersion) {
      // if (FirebaseAuth.instance.currentUser != null) {
      if (sharedPrefs.isIntroductionFinished) {
        return const RouteSettings(name: Routes.home);
      } else {
        return const RouteSettings(name: Routes.intro);
      }
      // } else {
      //   return const RouteSettings(name: Routes.login);
      // }
    } else {
      return const RouteSettings(name: Routes.forcedUpdate);
    }
  }
}
