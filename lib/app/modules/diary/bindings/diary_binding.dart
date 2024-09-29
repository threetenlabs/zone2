import 'package:get/get.dart';

import '../controllers/diary_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiaryController>(
      () => DiaryController(),
    );
  }
}
