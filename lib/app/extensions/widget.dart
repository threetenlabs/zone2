import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Opacity setOpacity(double val) => Opacity(
        opacity: val,
        child: this,
      );

  Padding withPadding(EdgeInsets padding) => Padding(
        padding: padding,
        child: this,
      );

  SizedBox sized({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  Center center() => Center(
        child: this,
      );

  Widget onClick(Function() onClick) => InkWell(
        onTap: onClick,
        child: this,
      );

  RotatedBox rotate(int quarterTurns) => RotatedBox(
        quarterTurns: quarterTurns,
        child: this,
      );

  Text applyStyle(TextStyle style) => Text(
        toString(),
        style: style,
      );
}
