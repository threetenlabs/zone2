import 'package:zone2/app/utils/routes.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/intro/bindings/intro_binding.dart';
import '../modules/intro/controllers/redirect_middleware.dart';
import '../modules/intro/views/intro_view.dart';
import '../modules/diary/bindings/diary_binding.dart';
import '../modules/diary/views/diary_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/update/bindings/update_bindings.dart';
import '../modules/update/views/update_view.dart';
import '../modules/diary/views/food/voice_food_input.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String initialRoute =
      FirebaseAuth.instance.currentUser != null ? _Paths.introOrHome : _Paths.login;

  static final routes = [
    GetPage(
      name: _Paths.introOrHome,
      page: () => const SizedBox.shrink(), // This page won't be shown because of the redirect
      middlewares: [RedirectMiddleware()],
    ),
    GetPage(
      name: _Paths.forcedUpdate,
      page: () => const UpdateView(),
      binding: UpdateBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
        name: _Paths.intro,
        page: () => const IntroView(),
        binding: IntroBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.home,
        page: () => const HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.landing,
      page: () => const DiaryView(),
      binding: DiaryBinding(),
    ),
    GetPage(
      name: '/voice-input',
      page: () => const VoiceFoodInputView(),
      binding: DiaryBinding(),
    ),
  ];
}
