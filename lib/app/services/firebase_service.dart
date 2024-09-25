import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  static FirebaseService get to => FirebaseService();
  final logger = Get.find<Logger>();

  final CollectionReference meccaCollectionReference =
      FirebaseFirestore.instance.collection('meccas');

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
}
