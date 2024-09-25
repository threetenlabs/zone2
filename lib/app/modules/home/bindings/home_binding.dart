import 'package:app/app/modules/landing/controllers/landing_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(
      () => LandingController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}

mixin GameMenuController {}
