import 'package:zone2/app/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AITooltip extends StatelessWidget {
  const AITooltip(
      {super.key,
      required this.ttController,
      required this.child,
      this.direction = TooltipDirection.up});

  final SuperTooltipController ttController;
  final TooltipDirection direction;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      showBarrier: true,
      showDropBoxFilter: true,
      sigmaX: 10,
      sigmaY: 10,
      controller: ttController,
      popupDirection: direction,
      backgroundColor: Colors.grey[200],
      left: 30,
      right: 30,
      arrowTipDistance: 15.0,
      arrowBaseWidth: 20.0,
      arrowLength: 20.0,
      borderWidth: 2.0,
      showCloseButton: false,
      touchThroughAreaShape: ClipAreaShape.rectangle,
      touchThroughAreaCornerRadius: 30,
      barrierColor: const Color.fromARGB(26, 47, 45, 47),
      content: Center(
        heightFactor: 1.0,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: context.bodyMedium!,
            children: <TextSpan>[
              TextSpan(
                text:
                    'This feature is currently in beta and powered by OpenAI. In the future, it will be part of premium features. Until then, you may use this feature by you can use this feature if you save your OpenAI API key in MyZone App Settings to help us test beta features such as:\n',
                style: context.boldStyle?.copyWith(
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                  text: 'Add calorie information to food by taking a picture of the label\n'),
              const TextSpan(text: 'Speech to text to convert to multi-faceted food entry\n'),
              TextSpan(
                text: '\nYou OPEN AI Key is not stored on Zone 2 servers.',
                style: context.italicStyle,
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
