import 'package:zone2/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginAvatar extends StatelessWidget {
  const LoginAvatar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // final palette = Get.find<Palette>();

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(top: 14.0, bottom: 4.0),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.black26,
        shape: BoxShape.circle,
      ),
      child: CommonAssets.images.app.appAvatar.image(),
    )
        .animate(onPlay: (animateController) => animateController.repeat())
        .shimmer(duration: 4000.ms, color: Colors.blue)
        .animate()
        .fadeIn(duration: 1200.ms, curve: Curves.slowMiddle);
  }
}
