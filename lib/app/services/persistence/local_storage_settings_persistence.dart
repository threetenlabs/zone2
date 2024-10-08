// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class GetStoragePersistence {
  final box = GetStorage();
  final logger = Get.find<Logger>();

  final String userHasRemovedAdsKey = 'userHasRemovedAdsKey';
  final String isIntroductionFinished = 'isIntroductionFinishedKey';
  final String soundOnKey = 'soundsOnKey';
  final String isAboveMinimumSupportedVersionKey = 'isAboveMinimumSupportedVersionKey';
  final String darkModeKey = 'darkModeKey';

  bool getUserHasRemovedAds() {
    return box.read(userHasRemovedAdsKey) ?? false;
  }

  Future<void> saveUserHasRemovedAds(bool value) async {
    await box.write(userHasRemovedAdsKey, value);
  }

  bool getSoundsOn() {
    return box.read(soundOnKey) ?? true;
  }

  Future<void> saveSoundsOn(bool value) async {
    await box.write(soundOnKey, value);
  }

  Future<void> saveIsIntroductionFinished(bool value) async {
    await box.write(isIntroductionFinished, value);
  }

  Future<void> saveIsAboveMinimumSupportedVersion(bool value) async {
    await box.write(isAboveMinimumSupportedVersionKey, value);
  }

  Future<void> saveDarkMode(bool value) async {
    await box.write(darkModeKey, value);
  }

  bool getDarkMode() {
    return box.read(darkModeKey) ??
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  void erase() {
    box.erase();
  }
}
