import 'package:zone2/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'home_portrait_small.dart';
import 'home_landscape_small.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      renderSmallPortrait: () => const HomeViewPortaitSmall(),
      renderMediumPortrait: () => const HomeViewPortaitSmall(),
      renderLargePortrait: () => const HomeViewPortaitSmall(),
      renderSmallLandscape: () => const HomeViewLandscapeSmall(),
      renderMediumLandscape: () => const HomeViewLandscapeSmall(),
      renderLargeLandscape: () => const HomeViewLandscapeSmall(),
    );
  }
}
