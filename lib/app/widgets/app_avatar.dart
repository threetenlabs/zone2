import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {required this.svgString,
      required this.width,
      required this.height,
      this.backgroundColor,
      super.key});

  final String svgString;
  final double width;
  final double height;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      child: CircleAvatar(
        radius: width / 1.8,
        backgroundColor: backgroundColor ?? Colors.white,
        child: SvgPicture.string(
          svgString,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
