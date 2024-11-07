import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  static PermissionService get to => Get.find();
  final logger = Get.find<Logger>();

  final hasMicPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkMicrophonePermission();
  }

  Future<bool> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      hasMicPermission.value = status.isGranted;
      return status.isGranted;
    } catch (e) {
      logger.e('Error requesting microphone permission: $e');
      return false;
    }
  }

  Future<bool> checkMicrophonePermission() async {
    try {
      final status = await Permission.microphone.status;
      hasMicPermission.value = status.isGranted;
      return status.isGranted;
    } catch (e) {
      logger.e('Error checking microphone permission: $e');
      return false;
    }
  }
}
