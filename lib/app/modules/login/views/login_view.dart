import 'package:app/app/modules/login/views/login_landscape_small.dart';
import 'package:app/app/modules/login/views/login_portait_small.dart';
import 'package:app/app/widgets/not_implemented.dart';
import 'package:app/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      renderSmallPortrait: () => const LoginViewPortaitSmall(),
      renderMediumPortrait: () => const LoginViewPortaitSmall(),
      renderLargePortrait: () => const NotImplementedWidget(),
      renderSmallLandscape: () => const LoginViewLandscapeSmall(),
      renderMediumLandscape: () => const LoginViewLandscapeSmall(),
      renderLargeLandscape: () => const NotImplementedWidget(),
    );
  }
}
