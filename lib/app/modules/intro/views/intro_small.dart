import 'package:zone2/app/modules/intro/controllers/intro_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zone2/app/modules/intro/views/widgets/birthdate_formatter.dart';
import 'package:zone2/gen/assets.gen.dart';

class IntroSmall extends GetWidget<IntroController> {
  const IntroSmall({super.key});

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Obx(
      () => IntroductionScreen(
        globalBackgroundColor: Colors.black,
        allowImplicitScrolling: false,
        infiniteAutoScroll: false,
        showSkipButton: false,
        showNextButton: controller.showNextButton.value,
        freeze: true,
        pages: [
          PageViewModel(
            title: "Weight Loss Democratized",
            body: "Losing weight is hard enough, we are here to make it easier",
            image: CommonAssets.images.undraw.undrawConnectedWorldWuay.svg(
              width: 200,
              height: 200,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "What is your reason?",
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
              ),
            ),
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonAssets.images.undraw.undrawPersonalGoalsReIow7.svg(
                  width: 200,
                  height: 200,
                ),
                const Text(
                  "You're more likely to stick to your goals if you have a motivating force",
                  style: bodyStyle,
                ),
                const SizedBox(height: 20),
                // Column of OutlinedButtons with padding
                ...['Health', 'Appearance', 'Fitness', 'Confidence', 'Other'].map((reason) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Add padding between buttons
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: controller.zone2Reason.value == reason
                              ? Theme.of(context).colorScheme.tertiary // Selected color
                              : const Color.fromARGB(255, 198, 193, 193), // Default color
                        ),
                        minimumSize: const Size(double.infinity, 48), // Full width
                      ),
                      onPressed: () {
                        controller.setReason(reason); // Update the selected reason
                      },
                      child: Text(
                        reason,
                        style: TextStyle(
                          color: controller.zone2Reason.value == reason
                              ? Theme.of(context).colorScheme.tertiary // Selected text color
                              : const Color.fromARGB(255, 198, 193, 193), // Default text color
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Let's gather some details",
            bodyWidget: Column(
              children: [
                const Text(
                  "Please enter your birthdate and select your gender",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20),
                // TextField for Birthdate with formatting
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Birthdate (MM-DD-YYYY)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    DateInputFormatter(), // Use the custom formatter
                  ],
                  onChanged: (value) {
                    controller.setBirthdate(value);
                  },
                ),
                const SizedBox(height: 20),
                // DropdownButton for Gender
                DropdownButton<String>(
                  hint: const Text('Select Gender'),
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    controller.setGender(newValue ?? '');
                  },
                  value: controller.zone2Gender.value,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    controller.invalidAge.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 19),
                  ),
                ),
              ],
            ),
            image: CommonAssets.images.undraw.undrawTextFieldHtlv.svg(
              width: 200,
              height: 200,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: controller.showDoneButton.value
                ? "All set! Let's get started"
                : "Allow Health Permissions",
            bodyWidget: Column(
              children: [
                Text(
                  controller.showDoneButton.value
                      ? "We have everything we need, click done to begin your journey!"
                      : "We need to access your health data to provide you with the best experience",
                  style: bodyStyle,
                ),
                controller.showDoneButton.value
                    ? const SizedBox.shrink()
                    : OutlinedButton(
                        onPressed: () => controller.requestHealthPermissions(),
                        child: const Text('Allow Permissions'),
                      ),
              ],
            ),
            image: controller.showDoneButton.value
                ? CommonAssets.images.undraw.undrawCompletedM9ci.svg(
                    width: 200,
                    height: 200,
                  )
                : CommonAssets.images.undraw.undrawCheckBoxesReV40f.svg(
                    width: 200,
                    height: 200,
                  ),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => controller.onFinish(),
        onChange: (index) => controller.onNext(index),
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: controller.showBackButton.value,
        showDoneButton: controller.showDoneButton.value,
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
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
      ),
    );
  }
}
