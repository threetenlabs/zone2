import 'package:app/app/utils/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

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

      //TODO: Subscribe to topics
      await FirebaseMessaging.instance.subscribeToTopic('bedlam_general');

      FirebaseAnalytics.instance.logEvent(name: LOG_FCM_PERMISSION_GRANTED);
    } else {
      fcmLogger.d('User declined or has not accepted permission');
      FirebaseAnalytics.instance.logEvent(name: LOG_FCM_PERMISSION_DECLINED);
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    //create a map for the fcmToken and a timestamp
    //add two properties to TokenMap
  }

  Future<void> _backgroundHandler(RemoteMessage message) async {
    fcmLogger.d('Handling a background message: ${message.messageId}');
  }
}
