import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileViewPortraitSmall extends GetWidget<ProfileController> {
  const ProfileViewPortraitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    final AuthService authService = Get.find<AuthService>();
    return PopScope(
      onPopInvokedWithResult: (bool value, Object? result) {
        return; // Updated to use onPopInvokedWithResult
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: height * 0.1,
                              child: Obx(() {
                                return SvgPicture.string(
                                  authService.appUser.value.svgString,
                                  width: height * 0.2,
                                  fit: BoxFit.cover,
                                );
                              }),
                            ),
                            //FluttermojiCircleAvatar(
                            //  radius: min(80, height * 0.1),
                            //  backgroundColor: Colors.grey[200],
                            //),
                          ),
                          OutlinedButton(
                            style: palette.primaryTheme.outlinedButtonTheme.style?.copyWith(
                                side: WidgetStateProperty.all<BorderSide>(
                                    BorderSide(color: palette.mainMenuProfile))),
                            onPressed: () {},
                            child: Text('Change Profile Picture',
                                style: palette.primaryTheme.textTheme.bodyMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                controller: controller.userNameController,
                                onChanged: (text) {},
                                validator: (value) {
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Display Name',
                                  labelStyle: TextStyle(color: palette.mainMenuProfile),
                                  hintText: 'Enter your display name',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  errorStyle: const TextStyle(color: Colors.red),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: palette.mainMenuProfile, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: palette.mainMenuProfile, width: 2.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: palette.mainMenuProfile, width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: palette.mainMenuProfile, width: 2.5),
                                  ),
                                ),
                                // decoration: InputDecoration(
                                //   labelText: "Username",
                                //   labelStyle: palette.mobilePrimaryTheme.textTheme.bodyMedium,
                                //   hintStyle: palette.mobilePrimaryTheme.textTheme.bodyMedium,
                                //   errorStyle: TextStyle(color: Colors.red),
                                // ),
                                style: palette.primaryTheme.textTheme.bodyMedium,
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
