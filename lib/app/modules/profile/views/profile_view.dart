import 'package:zone2/app/modules/profile/views/profile_portrait_small.dart';
import 'package:zone2/app/widgets/not_implemented.dart';
import 'package:zone2/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      renderSmallPortrait: () => const ProfileViewPortraitSmall(),
      renderMediumPortrait: () => const ProfileViewPortraitSmall(),
      renderLargePortrait: () => const ProfileViewPortraitSmall(),
      renderSmallLandscape: () => const NotImplementedWidget(),
      renderMediumLandscape: () => const NotImplementedWidget(),
      renderLargeLandscape: () => const NotImplementedWidget(),
    );
  }
}
