import 'package:flutter/material.dart';

extension ConstraintExt on BoxConstraints {
  double get maxWidth => this.maxWidth;
  double get maxHeight => this.maxHeight;
  double get minWidth => this.minWidth;
  double get minHeight => this.minHeight;
  double get biggestWidth => biggest.width;
  double get biggestHeight => biggest.height;
  double get smallestWidth => smallest.width;
  double get smallestHeight => smallest.height;

  double get blockSizeHorizontal => biggest.width / 100;
  double get blockSizeVertical => biggest.height / 100;

  double widthBasedPadding(double percent) => biggest.width * percent;
  double heightBasedPadding(double percent) => biggest.height * percent;

  double widthBasedFont(double percent, {double minFontSize = 12.0, double maxFontSize = 48.0}) {
    double calculatedSize = biggest.width * percent;
    return calculatedSize.clamp(minFontSize, maxFontSize);
  }

  double heightBasedFont(double percent, {double minFontSize = 12.0, double maxFontSize = 48.0}) {
    double calculatedSize = biggest.height * percent;
    return calculatedSize.clamp(minFontSize, maxFontSize);
  }

  double responsiveWidth(double percent) => maxWidth * percent;
  double responsiveHeight(double percent) => maxHeight * percent;
}
