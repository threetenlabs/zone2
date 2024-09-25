import 'dart:async';
import 'dart:convert';

import 'package:app/app/models/user.dart';
import 'package:app/app/services/fcm_service.dart';
import 'package:app/app/services/notification_service.dart';
import 'package:app/app/services/shared_preferences_service.dart';
import 'package:app/app/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttermoji/fluttermoji.dart';

import 'package:logger/logger.dart';
import 'package:username_gen/username_gen.dart';

class AuthService {
  static AuthService to = Get.find();
  final Logger logger = Get.find();
  final FirebaseAuth auth = Get.find();
  final FirebaseFirestore db = Get.find();
  final GoogleSignIn googleSignIn = Get.find();
  Rxn<User> firebaseUser = Rxn<User>();
  final fcmService = Get.find<FcmService>();
  final fluttermojiController = FluttermojiController();
  final sharedPrefs = Get.find<SharedPreferencesService>();

  final Map<String, dynamic> defaultFluttermoji = {
    "topType": 0,
    "accessoriesType": 0,
    "hairColor": 9,
    "facialHairType": 0,
    "facialHairColor": 0,
    "clotheType": 2,
    "eyeType": 0,
    "eyebrowType": 0,
    "mouthType": 7,
    "skinColor": 5,
    "clotheColor": 14,
    "style": 0,
    "graphicType": 0
  };

  final appUser =
      UserModel(uid: '', email: '', name: '', svgString: '', svgConfig: '', fcmTokenMap: {}).obs;
  final isAuthenticatedUser = false.obs;

  AuthService() {
    ever(firebaseUser, handleUserChanged);
    firebaseUser.bindStream(user);
  }

  handleUserChanged(User? updatedUser) async {
    //get user data from firestore
    logger.i('handleUserChanged: $updatedUser');
    if (updatedUser?.uid != null) {
      try {
        appUser.value = await getUser();
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        if (e is FirebaseException) {
          NotificationService.to
              .showError('Authentication Error', 'Error connecting to application backend');
        }
      }
    }

    isAuthenticatedUser.value = updatedUser != null && updatedUser.isAnonymous == false;

    if (updatedUser == null || appUser.value.uid == '') {
      // logger.i('User is not logged in - routing to /login');
      Get.offAllNamed(introOrHomeRoute);
    } else {
      // logger.i('User is logged in - routing to /home');
      if (Get.currentRoute != homeRoute && Get.currentRoute != introRoute) {
        Get.offAllNamed(introOrHomeRoute);
      }

      //If the user has no fcmTokenMap, then update the user with the fcmTokenMap acquired at startup
      //TODO implement better TTL management
      if (appUser.value.fcmTokenMap.isEmpty) {
        await db.collection('users').doc(appUser.value.uid).update({
          'fcmTokenMap': fcmService.tokenMap,
        });
      } else {
        //If the user has an fcmTokenMap, throw away the one we collected at startup
        fcmService.tokenMap.clear();
      }

      //if the user has no SVG string, then create a default SVG string
      if (appUser.value.svgString.isEmpty) {
        logger.i('No SVG String found, setting default Fluttermoji');

        String svgConfig = jsonEncode(defaultFluttermoji);
        String svgString = FluttermojiFunctions().decodeFluttermojifromString(
          jsonEncode(defaultFluttermoji),
        );
        updateUserSvg(svgString, svgConfig);
      }
    }
  }

  // Firebase user a realtime stream
  Stream<User?> get user => auth.authStateChanges();

  //get the firestore user from the firestore collection
  Future<UserModel> getUser() {
    return db.collection('users').doc(firebaseUser.value!.uid).get().then((documentSnapshot) {
      return getOrCreateUser(documentSnapshot);
    });
  }

  updateUserDetails(UserModel appUser) async {
    if (appUser.uid.isNotEmpty) {
      logger.i('updateUserDetails: $appUser');
      db.collection('users').doc(appUser.uid).set(appUser.toJson());
    }
  }

  updateUserSvg(String svgString, String svgConfig) async {
    appUser.update((user) {
      user?.svgString = svgString;
    });
    db
        .collection('users')
        .doc(appUser.value.uid)
        .update({'svgString': svgString, 'svgConfig': svgConfig});
    logger.i('updateUserSvg');
  }

  UserModel getOrCreateUser(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if ((documentSnapshot.data() != null)) {
      return UserModel.fromJson(documentSnapshot.data()!);
    } else {
      return createUser();
    }
  }

  String generateRandomName() {
    return UsernameGen().generate();
  }

  UserModel createUser() {
    Map<String, dynamic> data = {
      "uid": firebaseUser.value!.uid,
      "email": firebaseUser.value!.email,
      "name": (firebaseUser.value?.displayName ?? '').isEmpty
          ? generateRandomName()
          : firebaseUser.value!.displayName,
      "svgString": "{}"
    };
    UserModel user = UserModel.fromJson(data);
    db.doc('/users/${firebaseUser.value!.uid}').set(data);

    return user;
  }

  // Sign out
  Future<void> signOut() async {
    // await SolitaireController.to.cancelSubscriptions();
    if ((GetPlatform.isAndroid || GetPlatform.isWeb) &&
        FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.isAnonymous) {
      await googleSignIn.signOut();
    }

    sharedPrefs.deleteAll();
    return await auth.signOut();
  }

  Future<void> signInAnonymously() async {
    logger.w('signing in anonymously - should be mecca');
    UserCredential authResult = await auth.signInAnonymously();
    firebaseUser.value = authResult.user;
    logger.w('user: ${authResult.user?.displayName}');
    assert(await firebaseUser.value?.getIdToken() != null);
  }

  Future<bool> convertWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    try {
      final result = await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      final user = result?.user;
      UserModel bUser = UserModel(
          uid: user?.uid ?? '',
          email: user?.email ?? '',
          name: user?.providerData[0].displayName ?? '',
          svgString: '',
          svgConfig: "{}",
          fcmTokenMap: {});
      await updateUserDetails(bUser);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          UserCredential authResult = await auth.signInWithCredential(credential);
          firebaseUser.value = authResult.user;
          logger.i("Already linked, just sign in");
          return true;
        case "invalid-credential":
          logger.i("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          logger.i("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          UserCredential authResult = await auth.signInWithCredential(credential);
          firebaseUser.value = authResult.user;
          logger.i("Already linked, just sign in");
          return true;
        // See the API reference for the full list of error codes.
        default:
          logger.i("Unknown error.");
      }
    }
    return false;
  }

  Future<bool> convertWithApple() async {
    final appleProvider = AppleAuthProvider();
    try {
      FirebaseAuth.instance.currentUser?.linkWithProvider(appleProvider);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          UserCredential authResult = await FirebaseAuth.instance.signInWithProvider(appleProvider);

          firebaseUser.value = authResult.user;
          firebaseUser.value = authResult.user;
          logger.i("Already linked, just sign in");
          return true;
        case "invalid-credential":
          logger.i("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          logger.i("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          UserCredential authResult = await FirebaseAuth.instance.signInWithProvider(appleProvider);

          firebaseUser.value = authResult.user;
          logger.i("Already linked, just sign in");
          return true;
        // See the API reference for the full list of error codes.
        default:
          logger.i("Unknown error.");
      }
    }
    return false;
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential authResult = await auth.signInWithCredential(credential);
    firebaseUser.value = authResult.user;
    logger.i('user: ${authResult.user?.displayName}');
    assert(!firebaseUser.value!.isAnonymous);
    assert(await firebaseUser.value?.getIdToken() != null);
    User currentUser = auth.currentUser!;
    assert(firebaseUser.value?.uid == currentUser.uid);
  }

  Future<void> webSignInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Once signed in, return the UserCredential
    final authResult = await FirebaseAuth.instance.signInWithPopup(googleProvider);

    firebaseUser.value = authResult.user;
    logger.i('user: ${authResult.user?.displayName}');
    assert(!firebaseUser.value!.isAnonymous);
    assert(await firebaseUser.value?.getIdToken() != null);
    User currentUser = auth.currentUser!;
    assert(firebaseUser.value?.uid == currentUser.uid);
  }

  Future<void> signInWithApple() async {
    logger.i('signInWithApple() has been invoked');
    try {
      final appleProvider = AppleAuthProvider();

      UserCredential authResult = await FirebaseAuth.instance.signInWithProvider(appleProvider);

      firebaseUser.value = authResult.user;
      assert(!firebaseUser.value!.isAnonymous);
      assert(await firebaseUser.value?.getIdToken() != null);
      User currentUser = auth.currentUser!;
      assert(firebaseUser.value?.uid == currentUser.uid);
      logger.i("User Name: ${firebaseUser.value?.displayName}");
    } catch (e) {
      logger.e('Error signing in  with Apple: $e');
    }
  }
}
