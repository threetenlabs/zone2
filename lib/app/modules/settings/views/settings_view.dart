import 'package:zone2/app/modules/settings/views/settings_portrait_small.dart';
import 'package:zone2/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Get.find<Logger>();
    logger.i('SettingsView is Built');
    return ResponsiveLayout(
      renderSmallPortrait: () => const SettingsPortraitSmall(),
      renderMediumPortrait: () => const SettingsPortraitSmall(),
      renderLargePortrait: () => const SettingsPortraitSmall(),
      renderSmallLandscape: () => const SettingsPortraitSmall(),
      renderMediumLandscape: () => const SettingsPortraitSmall(),
      renderLargeLandscape: () => const SettingsPortraitSmall(),
    );
  }
}
