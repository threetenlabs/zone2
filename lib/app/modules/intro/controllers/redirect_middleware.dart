import 'package:zone2/app/routes/app_pages.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    if (FirebaseAuth.instance.currentUser != null) {
      if (sharedPrefs.isIntroductionFinished) {
        return const RouteSettings(name: Routes.home);
      } else {
        return const RouteSettings(name: Routes.intro);
      }
    } else {
      return const RouteSettings(name: Routes.login);
    }
    // } else {
    //   return const RouteSettings(name: Routes.login);
    // }
  }
}
