import 'package:app/app/modules/update/controllers/update_controller.dart';
import 'package:get/get.dart';

class UpdateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateController>(
      () => UpdateController(),
    );
  }
}
