import 'dart:async';

import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:logger/logger.dart';
import 'package:username_gen/username_gen.dart';

class AuthService {
  static AuthService to = Get.find();
  final Logger logger = Get.find();
  final FirebaseAuth auth = Get.find();
  final FirebaseFirestore db = Get.find();
  final GoogleSignIn googleSignIn = Get.find();
  Rxn<User> firebaseUser = Rxn<User>();
  final zone2User = Rxn<Zone2User>();
  // final fcmService = Get.find<FcmService>();

  final appUser = Zone2User(
      uid: '',
      email: '',
      name: '',
      onboardingComplete: false,
      zoneSettings: ZoneSettings.fromJson({})).obs;

  final isAuthenticatedUser = false.obs;

  AuthService(Zone2User? z2User) {
    // If the user is provided from main.dart, set the appUser
    if (z2User != null) {
      appUser.value = z2User;
    }

    // Bind the firebaseUser to the user stream
    ever(firebaseUser, handleUserChanged);
    firebaseUser.bindStream(user);
  }

  handleUserChanged(User? updatedUser) async {
    logger.i('handleUserChanged: $updatedUser');

    if (updatedUser?.uid != null) {
      try {
        appUser.value = await getUser();
        zone2User.value = appUser.value;
        listenForUserChanges();
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        if (e is FirebaseException) {
          NotificationService.to
              .showError('Authentication Error', 'Error connecting to application backend');
        }
      }
    } else {
      appUser.value = Zone2User(
          uid: '',
          email: '',
          name: '',
          onboardingComplete: false,
          zoneSettings: ZoneSettings.fromJson({}));
      zone2User.value = appUser.value;
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
    }
  }

  // Firebase user a realtime stream
  Stream<User?> get user => auth.authStateChanges();

  // get the firestore user from the firestore collection
  Future<Zone2User> getUser() {
    return db.collection('users').doc(auth.currentUser!.uid).get().then((documentSnapshot) {
      return getOrCreateUser(documentSnapshot);
    });
  }

  updateUserDetails(Zone2User appUser) async {
    if (firebaseUser.value!.uid.isNotEmpty) {
      logger.i('updateUserDetails: $appUser');
      db.collection('users').doc(appUser.uid).set(appUser.toJson());
    }
  }

  Future<void> listenForUserChanges() async {
    if (auth.currentUser == null) {
      return;
    }

    // Listen for user changes
    db.collection('users').doc(auth.currentUser!.uid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        Zone2User updatedUser = Zone2User.fromJson(snapshot.data()!);
        zone2User.value = updatedUser;
      }
    });
  }

  Zone2User getOrCreateUser(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if ((documentSnapshot.data() != null)) {
      return Zone2User.fromJson(documentSnapshot.data()!);
    } else {
      return createUser();
    }
  }

  String generateRandomName() {
    return UsernameGen().generate();
  }

  Zone2User createUser() {
    Map<String, dynamic> data = {
      "uid": firebaseUser.value!.uid,
      "email": firebaseUser.value!.email,
      "name": (firebaseUser.value?.displayName ?? '').isEmpty
          ? generateRandomName()
          : firebaseUser.value!.displayName,
      "onboardingComplete": false,
      "zoneSettings": {}
    };
    Zone2User user = Zone2User.fromJson(data);
    db.doc('/users/${firebaseUser.value!.uid}').set(data);

    return user;
  }

  // Sign out
  Future<void> signOut() async {
    if ((GetPlatform.isAndroid || GetPlatform.isWeb) &&
        FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.isAnonymous) {
      await googleSignIn.signOut();
    }

    await auth.signOut();
    firebaseUser.value = null;
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
