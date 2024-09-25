import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BusyIndicatorService {
  static BusyIndicatorService get to => Get.find();

  Future<void> showBusyIndicator(String status) async {
    await EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.black,
    );
  }

  void hideBusyIndicator() {
    EasyLoading.dismiss();
  }
}
