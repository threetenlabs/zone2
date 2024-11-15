import 'package:mocktail/mocktail.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/modules/home/controllers/home_controller.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';

class AuthServiceMock extends GetxController with Mock implements AuthService {
  @override
  final zone2User = Rxn<Zone2User>();
}

class SharedPreferencesServiceMock extends Mock implements SharedPreferencesService {
  @override
  final zone2ProteinTarget = 0.0.obs;
  @override
  final zone2CarbsTarget = 0.0.obs;
  @override
  final zone2FatTarget = 0.0.obs;
}

class HomeControllerMock extends GetxController with Mock implements HomeController {}

class FirebaseServiceMock extends Mock implements FirebaseService {}

class HealthServiceMock extends GetxService with Mock implements HealthService {
  @override
  Future<void> onInit() async => super.onInit();

  @override
  Future<void> onClose() async => super.onClose();

  @override
  final isAuthorized = false.obs;
}

class FoodServiceMock extends GetxService with Mock implements FoodService {
  @override
  Future<void> onInit() async => super.onInit();
}
