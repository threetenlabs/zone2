import 'package:flutter/material.dart';

extension TextStylingExt on Text {
  Text scaled(BuildContext context,
      {double scalePercent = 0.02,
      double minFontSize = 12.0,
      double maxFontSize = 48.0,
      double? minTextScaleFactor,
      double? maxTextScaleFactor}) {
    // Get current screen width from MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate clamped font size
    double calculatedFontSize = screenWidth * scalePercent;
    double clampedFontSize = calculatedFontSize.clamp(minFontSize, maxFontSize);

    // Optionally adjust the text scale factor
    // double currentTextScaleFactor = MediaQuery.of(context).textScaleFactor;

    final mediaQueryData = MediaQuery.of(context);

    final constrainedTextScaleFactor = mediaQueryData.textScaler.clamp(
      minScaleFactor: minTextScaleFactor ?? 1,
      maxScaleFactor: maxTextScaleFactor ?? 2.6,
    );

    // Create a new TextStyle or modify the existing one
    TextStyle textStyle = style ?? const TextStyle();
    textStyle = textStyle.copyWith(
      fontSize: clampedFontSize,
    );

    // Return a new Text widget with the adjusted TextStyle
    return Text(
      data ?? '',
      style: textStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: constrainedTextScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
