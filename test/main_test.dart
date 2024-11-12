import 'package:health/health.dart';
import 'package:zone2/app/modules/home/controllers/home_controller.dart';
import 'package:zone2/app/modules/home/views/home_view.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import 'helper/firebase.dart';
import 'helper/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(TimeFrame.day);
    registerFallbackValue(WeightUnit.pound);
    registerFallbackValue(WaterUnit.ounce);
  });

  testWidgets('Validations of the text widget in Content detail page', (WidgetTester tester) async {
    Get.put<Logger>(Logger());

    final healthServiceMock = HealthServiceMock();
    final firebaseAuthMock = FirebaseHelper.createMockFirebaseAuth();
    final firebaseFirestoreMock = FirebaseHelper.createMockFirestore();
    final firebaseServiceMock = FirebaseServiceMock();
    final authServiceMock = AuthServiceMock();
    final foodServiceMock = FoodServiceMock();
    final sharedPreferencesServiceMock = SharedPreferencesServiceMock();

    sharedPreferencesServiceMock.zone2ProteinTarget.value = 100.0;
    sharedPreferencesServiceMock.zone2CarbsTarget.value = 100.0;
    sharedPreferencesServiceMock.zone2FatTarget.value = 100.0;

    when(() => healthServiceMock.getWeightData(
            timeFrame: any(named: 'timeFrame'), seedDate: any(named: 'seedDate')))
        .thenAnswer((_) async => [
              HealthDataPoint(
                uuid: "b9f088c4-05ee-3058-b223-c2f8deab02af",
                value: NumericHealthValue(numericValue: 250.7),
                type: HealthDataType.WEIGHT,
                unit: HealthDataUnit.KILOGRAM,
                dateFrom: DateTime.parse("2024-11-06T05:52:30.000"),
                dateTo: DateTime.parse("2024-11-06T05:52:30.000"),
                sourcePlatform: HealthPlatformType.googleHealthConnect,
                sourceDeviceId: "AP3A.241005.015",
                sourceId: "",
                sourceName: "com.fitbit.FitbitMobile",
                recordingMethod: RecordingMethod.unknown,
              )
            ]);

    when(() => healthServiceMock.getMealData(
            timeFrame: any(named: 'timeFrame'), seedDate: any(named: 'seedDate')))
        .thenAnswer((_) async => [
              HealthDataPoint(
                uuid: "8285f360-2100-46bd-bc24-5eb84264ebcf",
                value: NutritionHealthValue(
                  name: "Large White Eggs | Great Value | 1.0 | 1 egg (50 g)",
                  calories: 70.0,
                  protein: 6.0,
                  fat: 5.0,
                  carbs: 0.0,
                  cholesterol: 0.0,
                  fiber: 0.0,
                  manganese: 1.0,
                  sodium: 0.07,
                  sugar: 0.0,
                  zinc: 1.0,
                ),
                type: HealthDataType.NUTRITION,
                unit: HealthDataUnit.NO_UNIT,
                dateFrom: DateTime.parse("2024-11-06T03:56:22.617"),
                dateTo: DateTime.parse("2024-11-06T03:57:22.617"),
                sourcePlatform: HealthPlatformType.googleHealthConnect,
                sourceDeviceId: "AP3A.241005.015",
                sourceId: "",
                sourceName: "com.threetenlabs.zone2",
                recordingMethod: RecordingMethod.unknown,
              )
            ]);

    when(() => healthServiceMock.getActivityData(
            timeFrame: any(named: 'timeFrame'), seedDate: any(named: 'seedDate')))
        .thenAnswer((_) async => [
              HealthDataPoint(
                uuid: "b0401744-fae8-4979-9afc-cf4b34f5fa4b",
                value: NumericHealthValue(numericValue: 21.109180000000002),
                type: HealthDataType.TOTAL_CALORIES_BURNED,
                unit: HealthDataUnit.KILOCALORIE,
                dateFrom: DateTime.parse("2024-11-06T00:15:00.000"),
                dateTo: DateTime.parse("2024-11-06T00:30:00.000"),
                sourcePlatform: HealthPlatformType.googleHealthConnect,
                sourceDeviceId: "AP3A.241005.015",
                sourceId: "",
                sourceName: "com.fitbit.FitbitMobile",
                recordingMethod: RecordingMethod.unknown,
              )
            ]);

    when(() => healthServiceMock.getWaterData(
            timeFrame: any(named: 'timeFrame'), seedDate: any(named: 'seedDate')))
        .thenAnswer((_) async => [
              HealthDataPoint(
                uuid: "bbf478e8-d685-493a-ad57-14e7a99f1a52",
                value: NumericHealthValue(numericValue: 0.3548825930088129),
                type: HealthDataType.WATER,
                unit: HealthDataUnit.LITER,
                dateFrom: DateTime.parse("2024-11-06T08:47:11.842"),
                dateTo: DateTime.parse("2024-11-06T08:48:11.842"),
                sourcePlatform: HealthPlatformType.googleHealthConnect,
                sourceDeviceId: "AP3A.241005.015",
                sourceId: "",
                sourceName: "com.threetenlabs.zone2",
                recordingMethod: RecordingMethod.manual,
              )
            ]);

    when(() => healthServiceMock.convertWeightUnit(any(), any())).thenAnswer((_) async => 100.0);
    when(() => healthServiceMock.convertWaterUnit(any(), any())).thenAnswer((_) async => 1.0);

    Get.put<SharedPreferencesService>(sharedPreferencesServiceMock);
    Get.put<FirebaseAuth>(firebaseAuthMock);
    Get.put<FirebaseFirestore>(firebaseFirestoreMock);
    Get.put<FirebaseService>(firebaseServiceMock);
    Get.put<HealthService>(healthServiceMock);
    Get.put<AuthService>(authServiceMock);
    Get.put<FoodService>(foodServiceMock);
    Get.put<Palette>(Palette());

    Get.put<DiaryController>(DiaryController());
    Get.put<Palette>(Palette());
    final home = HomeController();
    // when(home.onInit()).thenAnswer((_) async {
    //   home.count.value = 1;
    // });

    Get.put<HomeController>(home);

    await tester.pumpWidget(const GetMaterialApp(
      home: HomeView(),
    ));
    expect(home.contentIndex.value, 0);
  });
}
