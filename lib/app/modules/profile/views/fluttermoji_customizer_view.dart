import 'package:app/app/modules/profile/views/fluttermoji_customizer.dart';
import 'package:app/app/modules/profile/views/fluttermoji_customizer_landscape.dart';
import 'package:app/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/profile_controller.dart';

class FlutterMojiCustomizerView extends GetView<ProfileController> {
  const FlutterMojiCustomizerView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Get.find<Logger>();
    logger.i('ProfileView Built');
    return ResponsiveLayout(
      renderSmallPortrait: () => FluttermojiCustomizerPage(),
      renderMediumPortrait: () => FluttermojiCustomizerPage(),
      renderLargePortrait: () => FluttermojiCustomizerPage(),
      renderSmallLandscape: () => FluttermojiCustomizerLandscape(),
      renderMediumLandscape: () => FluttermojiCustomizerLandscape(),
      renderLargeLandscape: () => FluttermojiCustomizerLandscape(),
    );
  }
}
