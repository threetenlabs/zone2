import 'dart:async';

import 'package:app/app/modules/profile/views/fluttermoji_customizer_view.dart';
import 'package:app/app/services/auth_service.dart';
import 'package:app/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileViewLandscapeSmall extends GetWidget<ProfileController> {
  const ProfileViewLandscapeSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    final AuthService authService = Get.find<AuthService>();
    Timer? debounce;
    return PopScope(
      onPopInvoked: (bool value) {
        return;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var height = MediaQuery.of(context).size.height;
          return GetBuilder<ProfileController>(
            builder: (controller) => Theme(
              data: palette.primaryTheme,
              child: PopScope(
                canPop: false,
                child: Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: height * 0.15,
                                  child: Obx(() {
                                    return SvgPicture.string(
                                      authService.appUser.value.svgString,
                                      width: height * 0.3,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                                ),
                              ),
                              OutlinedButton(
                                style: palette.primaryTheme.outlinedButtonTheme.style?.copyWith(
                                    side: WidgetStateProperty.all<BorderSide>(
                                        BorderSide(color: palette.mainMenuProfile))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FlutterMojiCustomizerView()),
                                  );
                                },
                                child: Text('Change Profile Picture',
                                    style: palette.primaryTheme.textTheme.bodyMedium),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: TextFormField(
                                        controller: controller.userNameController,
                                        onChanged: (text) {
                                          if (debounce?.isActive ?? false) debounce?.cancel();
                                          debounce = Timer(const Duration(milliseconds: 500), () {
                                            if (controller.isUsernameValid(text)) {
                                              controller.updateUsername(text);
                                            }
                                          });
                                        },
                                        validator: (value) {
                                          return controller.isUsernameValid(value)
                                              ? null
                                              : 'Invalid username';
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Display Name',
                                          labelStyle: TextStyle(color: palette.mainMenuProfile),
                                          hintText: 'Enter your display name',
                                          hintStyle: const TextStyle(color: Colors.grey),
                                          errorStyle: const TextStyle(color: Colors.red),
                                          border: const OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: palette.mainMenuProfile, width: 2.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: palette.mainMenuProfile, width: 2.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: palette.mainMenuProfile, width: 2.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: palette.mainMenuProfile, width: 2.5),
                                          ),
                                        ),
                                        style: palette.primaryTheme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (authService.isAuthenticatedUser.value == true ||
                                  authService.firebaseUser.value != null)
                                OutlinedButton(
                                  onPressed: () => {authService.signOut()},
                                  style: palette.primaryTheme.outlinedButtonTheme.style?.copyWith(
                                      side: WidgetStateProperty.all<BorderSide>(
                                          BorderSide(color: palette.mainMenuProfile))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.logout_outlined),
                                      Text('Sign Out',
                                          style: palette.primaryTheme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
