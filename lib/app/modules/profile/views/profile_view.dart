import 'package:zone2/app/modules/profile/views/profile_landscape_small.dart';
import 'package:zone2/app/modules/profile/views/profile_portrait_small.dart';
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
      renderSmallLandscape: () => const ProfileViewLandscapeSmall(),
      renderMediumLandscape: () => const ProfileViewLandscapeSmall(),
      renderLargeLandscape: () => const ProfileViewLandscapeSmall(),
    );
  }
}
