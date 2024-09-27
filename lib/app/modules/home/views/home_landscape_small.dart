import 'package:app/app/style/palette.dart';
import 'package:app/app/widgets/skinner/animated_sidebar_nav/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeViewLandscapeSmall extends GetView<HomeController> {
  const HomeViewLandscapeSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<Palette>();

    return LayoutBuilder(builder: (context, constraints) {
      return GetBuilder<HomeController>(
        builder: (controller) => Theme(
          data: palette.primaryTheme,
          child: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: AnimatedSideBar(
                    items: controller.navBarItems,
                    itemTapped: (index) => controller.changePage(index),
                    currentIndex: controller.contentIndex.value,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Navigator(
                    key: Get.nestedKey(1),
                    initialRoute: '/games',
                    onGenerateRoute: controller.onGenerateRoute,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
