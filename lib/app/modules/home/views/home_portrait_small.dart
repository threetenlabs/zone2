import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeViewPortaitSmall extends GetWidget<HomeController> {
  const HomeViewPortaitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<Palette>();

    return LayoutBuilder(builder: (context, constraints) {
      return GetBuilder<HomeController>(
        builder: (controller) => Theme(
          data: palette.primaryTheme,
          child: Scaffold(
            bottomNavigationBar: AnimatedNotchBottomBar(
              notchBottomBarController: controller.notchController,
              bottomBarItems: controller.navBarItems,
              onTap: (index) => controller.changePage(index),
              kIconSize: 24,
              kBottomRadius: 12,
            ),
            extendBody: false,
            body: Navigator(
              key: Get.nestedKey(1),
              initialRoute: '/diary',
              onGenerateRoute: controller.onGenerateRoute,
            ),
          ),
        ),
      );
    });
  }
}
