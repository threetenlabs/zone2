import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zone2/app/models/user.dart';
import 'package:zone2/app/services/services.dart';
import 'package:zone2/app/utils/firebase.dart';
import 'package:zone2/gen/assets.gen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService get to => FirebaseService();
  final logger = Get.find<Logger>();
  final storage = Get.find<FirebaseStorage>();

  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

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

  Future<String> getDownloadURL(String path) async {
    try {
      logger.w('getDownloadURL: $path');
      final url = await FirebaseStorage.instance.ref(path).getDownloadURL();
      logger.d('Download URL: $url');
      return url;
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  Future<Image?> getImageFromMemory(String path) async {
    try {
      // attempt to load from firebase storage
      final bytes = (await FirebaseStorage.instance.ref(path).getData())!;
      return Image.memory(bytes);
    } catch (e) {
      if (e is FirebaseException) {
        logger.e(e);
        final message = FirebaseUtils.handleFirebaseException(e);

        NotificationService.to.showError('Error retrieving image', message);
      }
      return null;
    }
  }

  Future<String?> uploadImage(Uint8List imageData, String imagePath) async {
    try {
      final imageRef = storage.ref(imagePath);
      await imageRef.putData(imageData);
      final url = await imageRef.getDownloadURL();
      logger.i('uploadImage: $imagePath');
      return url;
    } catch (e) {
      if (e is FirebaseException) {
        logger.e(e);
        final message = FirebaseUtils.handleFirebaseException(e);

        NotificationService.to.showError('Error saving image', message);
      }
      return null;
    }
  }
}
