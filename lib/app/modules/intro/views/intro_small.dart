import 'package:zone2/app/modules/intro/controllers/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zone2/app/modules/intro/views/widgets/birthdate_formatter.dart';
import 'package:zone2/app/style/theme.dart';
import 'package:zone2/gen/assets.gen.dart';

class IntroSmall extends GetWidget<IntroController> {
  const IntroSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 19,
            color: Theme.of(context).colorScheme.tertiary) ??
        const TextStyle(fontWeight: FontWeight.w700, color: Colors.black);
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: Theme.of(context).colorScheme.primary) ??
        const TextStyle(fontWeight: FontWeight.w700, color: Colors.black);

    final buttonStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700, fontSize: 16, color: MaterialTheme.coolBlue.value) ??
        const TextStyle(fontWeight: FontWeight.w400, color: Colors.black);
    final pageDecoration = PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).colorScheme.surface,
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
            body:
                "Losing weight is not easy, but it should not cost a fortune in order to be successful",
            image: CommonAssets.images.undraw.undrawConnectedWorldWuay.svg(
              width: 300,
              height: 300,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                "Demographic Profile",
                style: titleStyle,
              ),
            ),
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonAssets.images.undraw.undrawPersonalInfoReUr1n.svg(
                  width: 200,
                  height: 200,
                ),
                Text(
                  "Let's gather some information about you so that we can provide you with a personalized experience",
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select Gender:'),
                    ToggleButtons(
                      isSelected: [
                        controller.zone2Gender.value == 'Male',
                        controller.zone2Gender.value == 'Female',
                        controller.zone2Gender.value == 'Intersexual',
                      ],
                      onPressed: (int index) {
                        controller.setGender(['Male', 'Female', 'Intersexual'][index]);
                      },
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Male'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Female'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Intersexual'),
                        ),
                      ],
                    ),
                  ],
                ),
                // New Row for Height in Feet and Inches
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Height:'),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 50,
                            height: 75,
                            child: DropdownButton<int>(
                              value: controller.heightFeet.value,
                              iconSize: 24,
                              elevation: 16,
                              itemHeight: 75,
                              isExpanded: true,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary, fontSize: 20.0),
                              items: List.generate(
                                      7, (index) => index + 2) // Generates values from 3 to 8
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                controller.setHeightFeet(newValue ?? 2);
                              },
                            ),
                          ),
                          const Text('(ft)'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20), // Space between feet and inches
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Height (in):'),
                          const SizedBox(width: 8), // Space between label and dropdown
                          SizedBox(
                            width: 50,
                            height: 75,
                            child: DropdownButton<int>(
                              value: controller.heightInches.value,
                              iconSize: 24,
                              elevation: 16,
                              itemHeight: 75,
                              isExpanded: true,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary, fontSize: 20.0),
                              items: List.generate(12, (index) => index)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                controller.setHeightInches(newValue ?? 0);
                              },
                            ),
                          ),
                          const Text('(in)'),
                        ],
                      ),
                    ),
                  ],
                ),
                // New TextField for Weight
                const SizedBox(height: 20),
                TextField(
                  controller: controller.weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (lbs)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.setWeight(value);
                  },
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
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                "Weight Loss Goals",
                style: titleStyle,
              ),
            ),
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonAssets.images.undraw.undrawAWholeYearVnfm.svg(
                  width: 200,
                  height: 200,
                ),
                Text(
                  "The hardest part is taking the first step, and now that you've done that, let's set some goals",
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.targetWeightController,
                  decoration: const InputDecoration(
                    labelText: 'TargetWeight (lbs)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.setTargetWeight(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.suggestedWeightLossTarget.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromARGB(255, 167, 167, 167), fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                // Wrap the Text widget with a Material Surface

                Material(
                  elevation: 4, // Adjust elevation as needed
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0), // Rounded corners
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0), // Padding inside the container
                    decoration: BoxDecoration(
                      // Added decoration for rounded edges
                      color: const Color.fromARGB(255, 238, 232, 179),
                      borderRadius:
                          BorderRadius.circular(32.0), // Match the Material's border radius
                    ),
                    child: Text(
                      controller.suggestedWeightLossMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color.fromARGB(255, 51, 51, 50), fontSize: 19),
                    ),
                  ),
                ),
              ],
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                "Additional Targets",
                style: titleStyle,
              ),
            ),
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonAssets.images.undraw.undrawHealthyLifestyleReIfwg.svg(
                  width: 200,
                  height: 200,
                ),
                Text(
                  "These can be changed later from the settings menu",
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Daily Water Goal (oz)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '100'),
                  onChanged: (value) => controller.setDailyWaterGoal(int.tryParse(value) ?? 100),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Daily Zone Points Goal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '100'),
                  onChanged: (value) =>
                      controller.setDailyZonePointsGoal(int.tryParse(value) ?? 100),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Daily Calorie Intake Goal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.setDailyCalorieIntakeGoal(double.tryParse(value) ?? 0),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Daily Calories Burned Goal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      controller.setDailyCaloriesBurnedGoal(double.tryParse(value) ?? 0),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Daily Steps Goal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '10000'),
                  onChanged: (value) => controller.setDailyStepsGoal(int.tryParse(value) ?? 10000),
                ),
              ],
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
                Text(
                  "You're more likely to stick to your goals if you focus on a motivating force",
                  style: bodyStyle, // Removed const
                ),
                const SizedBox(height: 20),
                // Column of OutlinedButtons with padding
                ...[
                  'Vacation',
                  'Wedding',
                  'Summer',
                  'Overall Health',
                  'Self Confidence',
                  'Training',
                  'Other'
                ].map((reason) {
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
                ? CommonAssets.images.undraw.undrawAgreeReHor9.svg(
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
        back: Text('Back', style: buttonStyle),
        skip: Text('Skip', style: buttonStyle),
        next: Text('Next', style: buttonStyle),
        done: Text('Done', style: buttonStyle),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: MaterialTheme.coolBlue.value.withOpacity(0.5),
          activeColor: MaterialTheme.coolBlue.value,
          activeSize: const Size(22.0, 10.0),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        // dotsContainerDecorator: const ShapeDecoration(
        //   color: Colors.black87,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //   ),
        // ),
      ),
    );
  }
}
