import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/style/palette.dart';
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
    return PopScope(
      canPop: false,
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
                                onPressed: () {},
                                child: Text('Change Profile Picture',
                                    style: palette.primaryTheme.textTheme.bodyMedium),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (authService.isAuthenticatedUser.value == true ||
                                  authService.firebaseUser.value != null)
                                OutlinedButton(
                                  onPressed: () => {authService.signOut()},
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
