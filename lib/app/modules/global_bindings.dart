import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/modules/loading_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/services/food_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/services/openai_service.dart';
import 'package:zone2/app/services/theme_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:timezone/data/latest.dart' as tz;

class GlobalBindings extends Bindings {
  final Palette palette;
  final FirebaseService firebaseService;
  final Zone2User? initialUser;

  GlobalBindings({required this.palette, required this.firebaseService, required this.initialUser});

  @override
  dependencies() {
    //This should remain first as many things will log to Analytics
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);
    // Initialize timezone data
    tz.initializeTimeZones();

    // Firebase Analytics
    Get.put<FirebaseAnalytics>(FirebaseAnalytics.instance, permanent: true);

    // Notification service
    Get.lazyPut(() => NotificationService(), fenix: true);

    // Super tooltip controller
    Get.lazyPut(() => SuperTooltipController(), fenix: true);

    // Theme service
    Get.put(ThemeService(), permanent: true);

    // Food service
    Get.put<FoodService>(FoodService(), permanent: true);
    Get.put<HealthService>(HealthService(), permanent: true);
    // Get.put<FcmService>(FcmService(), permanent: true);

    // Firebase service
    Get.put<FirebaseService>(firebaseService, permanent: true);

    Get.put<OpenAIService>(OpenAIService(), permanent: true);

    Get.put<BusyIndicatorService>(BusyIndicatorService(), permanent: true);

    // Palette needed by Settings to get theme information
    Get.lazyPut<Palette>(() => palette, fenix: true);
  }
}
