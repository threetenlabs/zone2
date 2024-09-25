import 'package:flutter/material.dart';

//Hides the overflow of a child, preventing the Flutter framework from throwing errors
class ClippedView extends StatelessWidget {
  final Widget? child;
  final Axis clipDirection;

  const ClippedView({super.key, this.child, this.clipDirection = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: clipDirection,
      child: child,
    );
  }
}
