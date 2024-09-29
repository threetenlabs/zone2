import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DiaryController>(
      DiaryController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}

mixin GameMenuController {}
