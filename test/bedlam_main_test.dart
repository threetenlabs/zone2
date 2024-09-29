import 'package:zone2/app/modules/home/controllers/home_controller.dart';
import 'package:zone2/app/modules/home/views/home_view.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

import 'helper/firebase.dart';

class AuthenticationControllerMock extends GetxController with Mock implements AuthService {}

class HomeControllerMock extends GetxController with Mock implements HomeController {}

class BedlamFirebaseServiceMock with Mock implements FirebaseService {}

void main() {
  testWidgets('Validations of the text widget in Content detail page', (WidgetTester tester) async {
    Get.put<Logger>(Logger());

    Get.put<FirebaseAuth>(FirebaseHelper.createMockFirebaseAuth());
    Get.put<FirebaseFirestore>(FirebaseHelper.createMockFirestore());
    Get.put<FirebaseService>(BedlamFirebaseServiceMock());
    Get.put<Palette>(Palette());

    Get.put<DiaryController>(DiaryController());
    Get.put<Palette>(Palette());
    final home = HomeController();
    // when(home.onInit()).thenAnswer((_) async {
    //   home.count.value = 1;
    // });

    Get.put<AuthService>(AuthenticationControllerMock());
    Get.put<HomeController>(home);

    await tester.pumpWidget(const GetMaterialApp(
      home: HomeView(),
    ));
    expect(home.contentIndex.value, 0);
    // verify(home.onInit()).called(1);
  });
}
