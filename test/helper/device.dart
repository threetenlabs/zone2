import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  void setPortraitSmall() {
    view.physicalSize = const Size(599, 900);
    view.devicePixelRatio = 1.0;
  }

  void setPortraitMedium() {
    view.physicalSize = const Size(600, 900);
    view.devicePixelRatio = 1.0;
  }

  void setPortraitLarge() {
    view.physicalSize = const Size(1200, 1400);
    view.devicePixelRatio = 1.0;
  }

  void setLandscapeSmall() {
    view.physicalSize = const Size(900, 599);
    view.devicePixelRatio = 1.0;
  }

  void setLandscapeMedium() {
    view.physicalSize = const Size(900, 600);
    view.devicePixelRatio = 1.0;
  }

  void setLandscapeLarge() {
    view.physicalSize = const Size(1400, 1200);
    view.devicePixelRatio = 1.0;
  }

  void resetViewSize() {
    view.resetPhysicalSize(); // resets the screen to its original size after the test end
  }
}

class DeviceHelper {
  static void setAndroid() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }

  static void setIos() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  }

  static void setWeb() {
    // TODO: Implement
  }

  static void setMacOs() {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  }

  static void resetTargetPlatform() {
    debugDefaultTargetPlatformOverride = null;
  }
}
