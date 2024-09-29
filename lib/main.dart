// ignore_for_file: dead_code

import 'package:health/health.dart';
import 'package:zone2/app/modules/global_bindings.dart';
import 'package:zone2/app/services/forced_update_service.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:zone2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final Palette palette = Palette();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final logger = Logger(
      filter: null, printer: PrettyPrinter(), level: kDebugMode ? Level.debug : Level.warning);

  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

  Get.lazyPut<Logger>(() => logger, fenix: true);

  // configure the health plugin before use.
  Health().configure();

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 6),
  ));
  await remoteConfig.fetchAndActivate();
  Get.put<FirebaseRemoteConfig>(remoteConfig, permanent: true);

  final GlobalBindings globalBindings = GlobalBindings(palette: palette, logger: logger);

  final forcedUpdateService = ForcedUpdateService();
  await forcedUpdateService.setIsAboveMinimumSupportedVersion();
  Get.put(forcedUpdateService, permanent: true);

  Get.put(HealthService(), permanent: true);

  if (kDebugMode && !kIsWeb) {
    bool useEmulator = false;
    final info = NetworkInfo();

    final wifiIP = await info.getWifiIP();

    logger.w(
        'Running in debug mode on ${GetPlatform.isAndroid ? 'android' : 'ios'} so pointing to local emulator with wifiIP: $wifiIP');

    if (useEmulator) {
      // Connect to local Functions emulator from emulator
      FirebaseFunctions.instance.useFunctionsEmulator("192.168.86.28", 5001,
          automaticHostMapping:
              true); // use your local IP (ipconfig getifaddr en0) for android device
      // FirebaseFunctions.instance.useFunctionsEmulator("127.0.0.1", 5001, automaticHostMapping: true); // for android emulator
    }
  }

  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      debugPrint('FlutterError.onError: $errorDetails');
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('PlatformDispatcher.instance.onError: $error');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(
    GetMaterialApp(
      title: "Zone 2",
      initialBinding: globalBindings,
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.light,
      theme: palette.primaryTheme,
      initialRoute: Routes.introOrHome,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
    ),
  );
}
