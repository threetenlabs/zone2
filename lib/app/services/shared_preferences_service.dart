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
  final _soundsOn = true.obs;
  final _darkMode = false.obs;
  final _isIntroductionFinished = true.obs;

  final GetStoragePersistence _persistence;

  final StreamController<bool> _userRemovedAdsStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _soundsOnStreamController = StreamController<bool>.broadcast();
  final StreamController<bool> _darkModeStreamController = StreamController<bool>.broadcast();

  /// Creates a new instance of [SharedPreferencesService] backed by [persistence].
  SharedPreferencesService() : _persistence = GetStoragePersistence() {
    _persistence.box.listenKey(_persistence.userHasRemovedAdsKey, (value) {
      _userRemovedAdsStreamController.add(value ?? false);
    });
    _persistence.box.listenKey(_persistence.soundOnKey, (value) {
      _soundsOnStreamController.add(value ?? false);
    });
    _persistence.box.listenKey(_persistence.darkModeKey, (value) {
      logger.i('Dark mode: $value');
      _darkModeStreamController.add(value ?? false);
    });
  }

  /// Loads the state from persistence.
  Future<void> loadStateFromPersistence() async {
    // implementation goes here

    _userHasRemovedAds.value = _persistence.getUserHasRemovedAds() || _userHasRemovedAds.value;
    // On the web, sound can only start after user interaction, so
    // we need to prompt user.
    _soundsOn.value = _persistence.getSoundsOn() || _soundsOn.value;

    _darkMode.value = _persistence.getDarkMode() || _darkMode.value;
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

  bool get isSoundsOn => _getIsSoundsOn();

  bool _getIsSoundsOn() {
    return _persistence.getSoundsOn();
  }

  Future<void> setSoundsOn(bool value) async {
    _soundsOn.value = value;
    await _persistence.saveSoundsOn(_soundsOn.value);
  }

  bool get isIntroductionFinished => _getIsIntroductionFinished();

  bool _getIsIntroductionFinished() {
    return _persistence.box.read(_persistence.isIntroductionFinished) ?? false;
  }

  Future<void> setIsIntroductionFinished(bool value) async {
    _isIntroductionFinished.value = value;
    await _persistence.saveIsIntroductionFinished(value);
  }

  Future<void> setZone2Goals(
      double startingWeight, double targetWeight, String motivatingFactor, String birthdate, String gender) async {
    await _persistence.saveZone2StartingWeight(startingWeight);
    await _persistence.saveZone2TargetWeight(targetWeight);
    await _persistence.saveZone2MotivatingFactor(motivatingFactor);
    await _persistence.saveZone2Birthdate(birthdate);
    await _persistence.saveZone2Gender(gender);
  }

  Stream<bool> get soundsOnStream => _soundsOnStreamController.stream;
  Stream<bool> get darkModeStream => _darkModeStreamController.stream;

  //On Logout delete all shared preferences
  Future<void> deleteAll() async {
    await _persistence.box.erase();
    logger.i('All shared preferences deleted');
  }

  Future<void> toggleDarkMode() async {
    _darkMode.value = !_darkMode.value;
    await _persistence.saveDarkMode(_darkMode.value);
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
