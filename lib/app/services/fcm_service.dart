import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/utils/constants.dart';

class FcmService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final fcmLogger = Get.find<Logger>();
  final analytics = Get.find<FirebaseAnalytics>();
  final Map<String, dynamic> tokenMap = {};

  FcmService() {
    requestPermission();
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      fcmLogger.d('User granted permission');

      String? token = await FirebaseMessaging.instance.getToken();
      tokenMap['fcmToken'] = token;
      tokenMap['timestamp'] = DateTime.now().toUtc().toIso8601String();
      // fcmLogger.e('TokenMap: $tokenMap');

      await FirebaseMessaging.instance.subscribeToTopic('bedlam_general');

      FirebaseAnalytics.instance.logEvent(name: logFcmPermissionGranted);
    } else {
      fcmLogger.d('User declined or has not accepted permission');
      FirebaseAnalytics.instance.logEvent(name: logFcmPermissionDeclined);
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    //create a map for the fcmToken and a timestamp
    //add two properties to TokenMap
  }
}
