// ignore_for_file: dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:zone2/app/services/health_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zone2/app/modules/global_bindings.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/style/theme.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:zone2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:toastification/toastification.dart';
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
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  await GetStorage.init('food_data');
  await GetStorage.init('theme_data');

  // Application palette/colors
  final Palette palette = Palette();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Instantiate and register a Logger
  final logger = Logger(
      filter: null, printer: PrettyPrinter(), level: kDebugMode ? Level.debug : Level.warning);
  Get.lazyPut<Logger>(() => logger, fenix: true);

  // Disable persistence for Firestore
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

  // Firebase auth is registered from the firebase auth instance. Can be mocked in tests
  Get.put<FirebaseAuth>(FirebaseAuth.instance);

  // Firebase firestore is registered from the firebase firestore instance. Can be mocked in tests
  Get.put<FirebaseFirestore>(FirebaseFirestore.instance);

  // Firebase service is instantiated here to get the initial user if logged in to determine if onboarding is complete
  final firebaseService = FirebaseService();
  final initialUser = await firebaseService.getUser();
  // Google sign in
  Get.put<GoogleSignIn>(GoogleSignIn());
  // Auth service is instantiated with initial user if exists
  Get.put<AuthService>(AuthService(initialUser), permanent: true);

  // Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 6),
  ));
  await remoteConfig.fetchAndActivate();
  Get.put<FirebaseRemoteConfig>(remoteConfig, permanent: true);

  // Persisted settings service
  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.loadStateFromPersistence();
  Get.lazyPut(() => sharedPreferencesService, fenix: true);

  final GlobalBindings globalBindings =
      GlobalBindings(palette: palette, firebaseService: firebaseService, initialUser: initialUser);

  if (kDebugMode) {
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

  runApp(ToastificationWrapper(
    child: GetMaterialApp(
      title: "Zone 2",
      initialBinding: globalBindings,
      debugShowCheckedModeBanner: true,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: MaterialTheme.light(),
      darkTheme: MaterialTheme.darkHighContrast(),
      initialRoute: Routes.introOrHome,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
    ),
  ));
}
