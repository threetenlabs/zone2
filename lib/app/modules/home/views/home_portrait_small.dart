import 'package:zone2/app/style/palette.dart';
import 'package:zone2/app/widgets/skinner/animated_nav_bar/navbar.dart';
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
            bottomNavigationBar: AnimatedNavBar(
              items: controller.navBarItems,
              itemTapped: (index) => controller.changePage(index),
              currentIndex: controller.contentIndex.value,
            ),
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
