import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get aspectRatio => MediaQuery.of(this).size.aspectRatio;
  double get longestSide => MediaQuery.of(this).size.longestSide;
  double get shortestSide => MediaQuery.of(this).size.shortestSide;
  Orientation get orientation => MediaQuery.of(this).orientation;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  bool get isMacOS => Theme.of(this).platform == TargetPlatform.macOS;
  bool get isWindows => Theme.of(this).platform == TargetPlatform.windows;
  bool get isLinux => Theme.of(this).platform == TargetPlatform.linux;
  bool get isWeb => kIsWeb;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get whiteTitle => titleMedium!.copyWith(color: Colors.white);
  TextStyle? get boldStyle =>
      bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle? get italicStyle => bodyMedium?.copyWith(fontStyle: FontStyle.italic);

  T responsiveAction<T>(
      {required T Function() renderSmallPortait,
      required T Function() renderMediumPortait,
      required T Function() renderLargePortait,
      required T Function() renderSmallLandscape,
      required T Function() renderMediumLandscape,
      required T Function() renderLargeLandscape}) {
    if (MediaQuery.of(this).orientation == Orientation.landscape) {
      // First we check the orientation of the device
      // debugPrint('Landscape');
      // debugPrint(width.toString());
      // If the device is in landscape mode, we check the width
      // Mobile (smaller than 600px)
      // Tablet (600px - 1200px)
      // Desktop (greater than 1200px)
      if (height < 600) {
        return renderSmallLandscape();
      } else if (height >= 600 && height < 1200) {
        return renderMediumLandscape();
      } else {
        return renderLargeLandscape();
      }
    } else {
      // If the device is in portrait mode, we check the height
      // Mobile (smaller than 600px)
      // Tablet (600px - 1200px)
      // Desktop (greater than 1200px)

      // debugPrint('Portrait');
      // debugPrint(width.toString());
      if (width < 600) {
        return renderSmallPortait();
      } else if (width >= 600 && width < 1200) {
        return renderMediumPortait();
      } else {
        return renderLargePortait();
      }
    }
  }
}
