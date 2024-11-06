import 'package:mocktail/mocktail.dart';
import 'package:zone2/app/modules/home/controllers/home_controller.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:get/get.dart';

class AuthServiceMock extends GetxController with Mock implements AuthService {}

class HomeControllerMock extends GetxController with Mock implements HomeController {}

class FirebaseServiceMock extends Mock implements FirebaseService {}

class HealthServiceMock extends GetxService with Mock implements HealthService {
  @override
  Future<void> onInit() async => super.onInit();

  @override
  final isAuthorized = false.obs;
}

class FoodServiceMock extends GetxService with Mock implements FoodService {
  @override
  Future<void> onInit() async => super.onInit();
}
