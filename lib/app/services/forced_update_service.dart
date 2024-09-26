import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class ForcedUpdateService {
  final remoteConfig = Get.find<FirebaseRemoteConfig>();
  final logger = Get.find<Logger>();

  bool _isAboveMinimumSupportedVersion = true;

  ForcedUpdateService();

  Future<void> setIsAboveMinimumSupportedVersion() async {
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
        _isAboveMinimumSupportedVersion = false;
      }
    } on Exception catch (e) {
      logger.e('Error checking app version: $e');
    }
  }

  get isAboveMinimumSupportedVersion => _isAboveMinimumSupportedVersion;
}
