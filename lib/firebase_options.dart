// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvuthiZVuGwFUgwlDfQuXU1zR3yeVSNRA',
    appId: '1:260007377833:android:48485da0a82d5283c562b8',
    messagingSenderId: '260007377833',
    projectId: 'zone2-prod',
    storageBucket: 'zone2-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgbcrEO335n3uL2aY5h-TGFAF3RxB2t10',
    appId: '1:260007377833:ios:3aa922d998605c50c562b8',
    messagingSenderId: '260007377833',
    projectId: 'zone2-prod',
    storageBucket: 'zone2-prod.firebasestorage.app',
    androidClientId: '260007377833-5f6ouohq4n4uouit719lp106qbf7q9ce.apps.googleusercontent.com',
    iosClientId: '260007377833-un7fpgngv8cbpdh42rgbtuimganesasb.apps.googleusercontent.com',
    iosBundleId: 'com.threetenlabs.zone2',
  );
}
