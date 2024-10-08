import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeViewPortaitSmall extends GetWidget<HomeController> {
  const HomeViewPortaitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GetBuilder<HomeController>(
        builder: (controller) => Scaffold(
          bottomNavigationBar: AnimatedNotchBottomBar(
            notchBottomBarController: controller.notchController,
            bottomBarItems: controller.navBarItems,
            onTap: (index) => controller.changePage(index),
            kIconSize: 24,
            kBottomRadius: 12,
            color: Get.isDarkMode
                ? Theme.of(context).colorScheme.surfaceBright
                : Theme.of(context).colorScheme.surfaceDim,
          ),
          extendBody: false,
          body: Navigator(
            key: Get.nestedKey(1),
            initialRoute: '/diary',
            onGenerateRoute: controller.onGenerateRoute,
          ),
        ),
      );
    });
  }
}
