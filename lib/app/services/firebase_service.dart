import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/user.dart';

class FirebaseService {
  static FirebaseService get to => FirebaseService();
  final logger = Get.find<Logger>();

  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  // Future<FirebaseFunctionResult<CreateGameResponse>> createGame(String gameType) async {
  //   try {
  //     var callable = await FirebaseFunctions.instance
  //         .httpsCallable('bedlam-createGame', options: HttpsCallableOptions())
  //         .call(<String, dynamic>{
  //       "userId": AuthService.to.bedlamUser.value.uid,
  //       "name": AuthService.to.bedlamUser.value.name,
  //       "svgString": AuthService.to.bedlamUser.value.svgString,
  //       "gameType": gameType
  //     });

  //     return FirebaseFunctionResult<CreateGameResponse>.success(
  //         CreateGameResponse.fromJson(callable.data));
  //   } on FirebaseFunctionsException catch (e) {
  //     return FirebaseFunctionResult.failure(
  //         FirebaseUtils.handleFirebaseException(e, action: 'creating game'));
  //   } on Exception {
  //     return FirebaseFunctionResult.failure("An unknown error occurred while creating the game");
  //   }
  // }

  Future<void> updateUserOnboardingComplete() async {
    await userCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'onboardingComplete': true});
  }

  Future<void> updateUserZoneSettings(ZoneSettings zoneSettings) async {
    await userCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'zoneSettings': zoneSettings.toJson()});
  }

  Future<Zone2User?> getUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }

    final documentSnapshot =
        await userCollectionReference.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      return Zone2User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    }

    return null;
  }
}
