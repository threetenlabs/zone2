// import 'package:zone2/app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoginController extends GetxController {
  final logger = Get.find<Logger>();

  // void handleGoogleSignIn() => AuthService.to.signInWithGoogle();

  void handleAnonymousSignIn() => () {
        logger.w('Anonymous Sign In Not Implemented');
      }();

  // void handleAppleSignIn() => AuthService.to.signInWithApple();

  // void handleWebSignin() => AuthService.to.webSignInWithGoogle();
}
