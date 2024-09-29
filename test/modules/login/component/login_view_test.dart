import 'package:zone2/app/modules/login/controllers/login_controller.dart';
import 'package:zone2/app/modules/login/views/login_view.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../helper/device.dart';
import '../../../helper/firebase.dart';
import 'login_view_test.mocks.dart';

// class AuthenticationControllerMock extends GetxController with Mock implements AuthService {}

class TooltipControllerMock extends GetxController with Mock implements SuperTooltipController {}

class BedlamFirebaseServiceMock with Mock implements FirebaseService {}

class LoginControllerMock extends GetxController with Mock implements LoginController {}

@GenerateNiceMocks([MockSpec<AuthService>(onMissingStub: OnMissingStub.returnDefault)])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LoginController controller;
  late AuthService authService;

  group('Login View Tests', () {
    setUp(() {
      Get.put<Logger>(Logger());
      Get.put<FirebaseAuth>(FirebaseHelper.createMockFirebaseAuth());
      Get.put<FirebaseFirestore>(FirebaseHelper.createMockFirestore());
      Get.put<Palette>(Palette());

      Get.put<FirebaseService>(BedlamFirebaseServiceMock());
      authService = MockAuthService();
      when(authService.signInWithApple()).thenAnswer((realInvocation) async {});
      Get.put<AuthService>(authService);

      controller = LoginController();
      // Inject the controller into GetX
      Get.put<LoginController>(controller);
    });

    testWidgets('When Android, Portait, Small, Correct Button shown', (WidgetTester tester) async {
      // Set the device to Android
      DeviceHelper.setAndroid();
      // Set the device to Portrait Small
      tester.setPortraitSmall();

      await tester.runAsync(() async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: const LoginView(),
            builder: EasyLoading.init(),
          ),
          duration: const Duration(seconds: 5),
        );

        final googleButton = find.widgetWithText(ElevatedButton, 'Continue with Google');
        expect(googleButton, findsOneWidget); // Ensure the button is found

        // Tap the ElevatedButton
        await tester.tap(googleButton);
        await tester.pump(); // Rebuild the widget to reflect any changes due to the tap

        verify(controller.handleGoogleSignIn()).called(1);
      });

      DeviceHelper.resetTargetPlatform(); // <-- Reset the platform (necessary)
      tester.resetViewSize(); // resets the screen to its original size after the test end
    });

    testWidgets('When Ios, Portait, Small, Correct Button shown', (WidgetTester tester) async {
      // Set the device to Ios
      DeviceHelper.setIos();
      // Set the device to Portrait Small
      tester.setPortraitSmall();

      await tester.runAsync(() async {
        await tester.pumpWidget(
          const GetMaterialApp(
            home: LoginView(),
          ),
        );

        final appleSignInButton = find.byType(ElevatedButton);
        await tester.tap(appleSignInButton);

        expect(appleSignInButton, findsOneWidget);
        verify(controller.handleAppleSignIn()).called(1);
      });

      DeviceHelper.resetTargetPlatform(); // <-- Reset the platform (necessary)
      tester.resetViewSize(); // resets the screen to its original size after the test end
    });

    tearDown(() {
      Get.delete<SuperTooltipController>();
      Get.delete<LoginController>();
      Get.delete<AuthService>();
      Get.delete<FirebaseService>();
      Get.delete<Palette>();
      Get.delete<FirebaseFirestore>();
      Get.delete<FirebaseAuth>();
      Get.delete<Logger>();
    });
  });
}
