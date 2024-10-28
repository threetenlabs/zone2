import 'package:zone2/app/extensions/extensions.dart';
import 'package:zone2/app/modules/login/views/widgets/apple_signin.dart';
import 'package:zone2/app/modules/login/views/widgets/google_signin.dart';
import 'package:zone2/app/modules/login/views/widgets/login_avatar.dart';
import 'package:zone2/app/modules/login/views/widgets/signin_tooltip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../controllers/login_controller.dart';

class LoginViewLandscapeSmall extends GetWidget<LoginController> {
  const LoginViewLandscapeSmall({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    SuperTooltipController tooltipController = SuperTooltipController();

    return LayoutBuilder(builder: (context, constraints) {
      return GetBuilder<LoginController>(
        builder: (controller) => PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 42, 42, 42),
            body: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoginAvatar(
                      width: constraints.responsiveWidth(0.5),
                      height: constraints.responsiveWidth(0.5)),
                  const SizedBox(width: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (defaultTargetPlatform == TargetPlatform.iOS)
                        AppleSignIn(
                            onPressed: () async {
                              // controller.handleAppleSignIn();
                            },
                            imageHeight: constraints.responsiveHeight(0.025)),
                      if (defaultTargetPlatform == TargetPlatform.android)
                        GoogleSignInButton(
                            onPressed: () async {
                              // controller.handleGoogleSignIn();
                            },
                            imageHeight: constraints.responsiveHeight(0.03)),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Why sign in?',
                          style: context.boldStyle,
                        ).scaled(context, scalePercent: 0.02),
                      ),
                      const SizedBox(height: 8),
                      SignInToolTip(
                        ttController: tooltipController,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
