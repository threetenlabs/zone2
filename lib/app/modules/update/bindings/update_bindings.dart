import 'package:zone2/app/modules/update/controllers/update_controller.dart';
import 'package:get/get.dart';

class UpdateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateController>(
      () => UpdateController(),
    );
  }
}
