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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: SizedBox(
                height: 100,
                child: BottomNavigationBar(
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  onTap: (index) => controller.changePage(index),
                  items: controller.navBarItems,
                  currentIndex: controller.contentIndex.value,
                ),
              ),
            ),
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
