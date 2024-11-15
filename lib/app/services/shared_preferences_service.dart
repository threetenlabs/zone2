import 'dart:async';

import 'persistence/local_storage_settings_persistence.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class SharedPreferencesService {
  static SharedPreferencesService get to => Get.find();
  final logger = Get.find<Logger>();
  final remoteConfig = Get.find<FirebaseRemoteConfig>();
  final _isAboveMinimumSupportedVersion = true.obs;

  final _userHasRemovedAds = false.obs;
  final darkMode = false.obs;
  final zone2ProteinTarget = 0.0.obs;
  final zone2CarbsTarget = 0.0.obs;
  final zone2FatTarget = 0.0.obs;
  final openAIKey = ''.obs;

  final GetStoragePersistence _persistence;

  final StreamController<bool> _userRemovedAdsStreamController = StreamController<bool>.broadcast();

  /// Creates a new instance of [SharedPreferencesService] backed by [persistence].
  SharedPreferencesService() : _persistence = GetStoragePersistence() {
    _persistence.box.listenKey(_persistence.userHasRemovedAdsKey, (value) {
      _userRemovedAdsStreamController.add(value ?? false);
    });
    _persistence.box.listenKey(_persistence.darkModeKey, (value) {
      logger.i('Dark mode: $value');
      darkMode.value = value ?? false;
    });
    _persistence.box.listenKey(_persistence.zone2ProteinTargetKey, (value) {
      zone2ProteinTarget.value = value ?? 0.0;
    });
    _persistence.box.listenKey(_persistence.zone2CarbsTargetKey, (value) {
      zone2CarbsTarget.value = value ?? 0.0;
    });
    _persistence.box.listenKey(_persistence.zone2FatTargetKey, (value) {
      zone2FatTarget.value = value ?? 0.0;
    });
    _persistence.box.listenKey(_persistence.openAIKey, (value) {
      openAIKey.value = value ?? '';
    });
  }

  /// Loads the state from persistence.
  Future<void> loadStateFromPersistence() async {
    // implementation goes here

    _userHasRemovedAds.value = _persistence.getUserHasRemovedAds() || _userHasRemovedAds.value;
    darkMode.value = _persistence.getDarkMode() || darkMode.value;
    zone2ProteinTarget.value = _persistence.getZone2ProteinTarget();
    zone2CarbsTarget.value = _persistence.getZone2CarbsTarget();
    zone2FatTarget.value = _persistence.getZone2FatTarget();
    openAIKey.value = _persistence.getOpenAIKey();
  }

  void resetPersistedSettings() {
    _persistence.erase();
    loadStateFromPersistence();
  }

  bool get userRemovedAds => _getUserHasRemovedAds();

  bool _getUserHasRemovedAds() {
    return _persistence.getUserHasRemovedAds();
  }

  Future<void> setUserRemovedAds(bool value) async {
    _userHasRemovedAds.value = value;
    await _persistence.saveUserHasRemovedAds(_userHasRemovedAds.value);
  }

  Future<void> setZone2ProteinTarget(double value) async {
    await _persistence.saveZone2ProteinTarget(value);
  }

  Future<void> setZone2CarbsTarget(double value) async {
    await _persistence.saveZone2CarbsTarget(value);
  }

  Future<void> setZone2FatTarget(double value) async {
    await _persistence.saveZone2FatTarget(value);
  }

  Future<void> setOpenAIKey(String value) async {
    openAIKey.value = value;
    await _persistence.saveOpenAIKey(value);
  }

  //On Logout delete all shared preferences
  Future<void> deleteAll() async {
    await _persistence.box.erase();
    logger.i('All shared preferences deleted');
  }

  Future<void> toggleDarkMode() async {
    darkMode.value = !darkMode.value;
    await _persistence.saveDarkMode(darkMode.value);
  }

  bool get isDarkMode => _getIsDarkMode();

  bool _getIsDarkMode() {
    final dm = _persistence.box.read(_persistence.darkModeKey);
    logger.i('Dark mode: $dm');
    return dm ?? false;
  }

  Future<bool> setIsAboveMinimumSupportedVersion() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      final Version currentVersion = Version.parse(info.version);
      final String appVersion = "${info.version}+${info.buildNumber}";
      logger.i('Current app version: $appVersion');

      final Version minimumSupportedVersion =
          Version.parse(remoteConfig.getString('minimum_supported_version'));

      logger.i('Last fetch time: ${remoteConfig.lastFetchTime}');
      logger.i('Minimum supported version: $minimumSupportedVersion');

      if (currentVersion < minimumSupportedVersion) {
        logger.e('Current app version is below minimum supported version');
        _isAboveMinimumSupportedVersion.value = false;
        _persistence.saveIsAboveMinimumSupportedVersion(false);
        return false;
      }
    } on Exception catch (e) {
      logger.e('Error checking app version: $e');
      _isAboveMinimumSupportedVersion.value = false;
      _persistence.saveIsAboveMinimumSupportedVersion(false);
      return false;
    }
    _isAboveMinimumSupportedVersion.value = true;
    _persistence.saveIsAboveMinimumSupportedVersion(true);
    return true;
  }

  bool get isAboveMinimumSupportedVersion => _isAboveMinimumSupportedVersion.value;
}
