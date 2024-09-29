import 'package:zone2/app/modules/intro/controllers/intro_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroSmall extends GetWidget<IntroController> {
  const IntroSmall({super.key});

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.black,
      allowImplicitScrolling: true,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: "Choosing Games",
          body: "We have great games, chose them from the games menu",
          image: const Icon(
            Icons.accessibility_new,
            color: Colors.white,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Playing Games",
          body: "Ryan is bad at playing games, be better than Ryan",
          image: const Icon(
            Icons.accessibility_new,
            color: Colors.white,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Casting to Mecca",
          body:
              "You have a TV on the wall right? That big thing shaped like an iPad, our game will show up there",
          image: const Icon(
            Icons.accessibility_new,
            color: Colors.white,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Buying Bedlamites",
          body: "In app currencies??? You love em, we got em, buy them, spend them, love them",
          image: const Icon(
            Icons.accessibility_new,
            color: Colors.white,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Using Bedlamites",
          body: "Buy our in game currency so you can spend it, run out, and buy more",
          image: const Icon(
            Icons.accessibility_new,
            color: Colors.white,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => controller.onFinish(),
      onSkip: () => controller.onFinish(),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:
          kIsWeb ? const EdgeInsets.all(12.0) : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
