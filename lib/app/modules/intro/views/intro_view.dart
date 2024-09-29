import 'package:zone2/app/modules/intro/controllers/intro_controller.dart';
import 'package:zone2/app/modules/intro/views/intro_small.dart';
import 'package:zone2/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class IntroView extends GetWidget<IntroController> {
  const IntroView({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      renderSmallPortrait: () => const IntroSmall(),
      renderMediumPortrait: () => const IntroSmall(),
      renderLargePortrait: () => const IntroSmall(),
      renderSmallLandscape: () => const IntroSmall(),
      renderMediumLandscape: () => const IntroSmall(),
      renderLargeLandscape: () => const IntroSmall(),
    );
  }
}
