import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeViewLandscapeSmall extends GetView<HomeController> {
  const HomeViewLandscapeSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GetBuilder<HomeController>(
        builder: (controller) => Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Navigator(
                  key: Get.nestedKey(1),
                  initialRoute: '/diary',
                  onGenerateRoute: controller.onGenerateRoute,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
