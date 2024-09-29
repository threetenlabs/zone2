import 'package:zone2/app/extensions/extensions.dart';
import 'package:zone2/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed, required this.imageHeight});

  final double imageHeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: CommonAssets.images.platform.googleLogo.provider(),
                height: imageHeight,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Continue with Google',
                  style: context.whiteTitle,
                ).scaled(context, scalePercent: 0.02),
              )
            ],
          ),
        ));
  }
}
