import 'package:zone2/app/routes/app_pages.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class RedirectMiddleware extends GetMiddleware {
  final logger = Get.find<Logger>();

  @override
  RouteSettings? redirect(String? route) {
    if (FirebaseAuth.instance.currentUser != null) {
      if (AuthService.to.appUser.value.onboardingComplete) {
        return const RouteSettings(name: Routes.home);
      } else {
        return const RouteSettings(name: Routes.intro);
      }
    } else {
      return const RouteSettings(name: Routes.login);
    }
  }
}
