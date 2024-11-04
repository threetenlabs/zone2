import 'package:dart_openai/dart_openai.dart';
import 'package:zone2/app/modules/loading_service.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/services/openai_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:super_tooltip/super_tooltip.dart';

class GlobalBindings extends Bindings {
  final Palette palette;
  final Logger logger;
  final SharedPreferencesService sharedPreferencesService;

  GlobalBindings(
      {required this.palette, required this.logger, required this.sharedPreferencesService});

  @override
  dependencies() {
    //This should remain first as many things will log to Analytics
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

    Get.put<FirebaseAnalytics>(FirebaseAnalytics.instance, permanent: true);

    Get.lazyPut(() => NotificationService(), fenix: true);
    Get.lazyPut(() => SuperTooltipController(), fenix: true);

    Get.put<FirebaseAuth>(FirebaseAuth.instance);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance);
    Get.put<GoogleSignIn>(GoogleSignIn());

    Get.put<FoodService>(FoodService(), permanent: true);
    Get.put<HealthService>(HealthService(), permanent: true);
    // Get.put<FcmService>(FcmService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);

    Get.put<OpenAI>(OpenAI.instance);
    Get.put<OpenAIService>(OpenAIService(), permanent: true);

    Get.put<FirebaseService>(FirebaseService(), permanent: true);

    Get.put<BusyIndicatorService>(BusyIndicatorService(), permanent: true);

    // Palette needed by Settings to get theme information
    Get.lazyPut<Palette>(() => palette, fenix: true);
  }
}
