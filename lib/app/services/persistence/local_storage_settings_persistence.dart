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
  final String zone2ProteinTargetKey = 'zone2ProteinTargetKey';
  final String zone2CarbsTargetKey = 'zone2CarbsTargetKey';
  final String zone2FatTargetKey = 'zone2FatTargetKey';

  bool getUserHasRemovedAds() {
    return box.read(userHasRemovedAdsKey) ?? false;
  }

  Future<void> saveUserHasRemovedAds(bool value) async {
    await box.write(userHasRemovedAdsKey, value);
  }

  Future<void> saveIsAboveMinimumSupportedVersion(bool value) async {
    await box.write(isAboveMinimumSupportedVersionKey, value);
  }

  bool getDarkMode() {
    return box.read(darkModeKey) ??
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  Future<void> saveDarkMode(bool value) async {
    await box.write(darkModeKey, value);
  }

  double getZone2ProteinTarget() {
    return box.read(zone2ProteinTargetKey) ?? 0.0;
  }

  Future<void> saveZone2ProteinTarget(double value) async {
    await box.write(zone2ProteinTargetKey, value);
  }

  double getZone2CarbsTarget() {
    return box.read(zone2CarbsTargetKey) ?? 0.0;
  }

  Future<void> saveZone2CarbsTarget(double value) async {
    await box.write(zone2CarbsTargetKey, value);
  }

  double getZone2FatTarget() {
    return box.read(zone2FatTargetKey) ?? 0.0;
  }

  Future<void> saveZone2FatTarget(double value) async {
    await box.write(zone2FatTargetKey, value);
  }

  void erase() {
    box.erase();
  }
}
