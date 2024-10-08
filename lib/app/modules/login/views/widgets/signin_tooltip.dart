import 'package:get/get.dart';
import 'package:zone2/app/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class SignInToolTip extends StatelessWidget {
  const SignInToolTip({super.key, required this.ttController});

  final SuperTooltipController ttController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // await controller.tooltipController.showTooltip();
      },
      child: SuperTooltip(
        showBarrier: true,
        showDropBoxFilter: true,
        sigmaX: 10,
        sigmaY: 10,
        controller: ttController,
        popupDirection: TooltipDirection.up,
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
                      'Zone 2 uses your platform account in order to securly access data in ${GetPlatform.isAndroid ? 'Google Health Connect' : 'Apple Health'}.\n',
                  style: context.boldStyle?.copyWith(
                    color: Colors.black,
                  ),
                ),
                const TextSpan(text: 'Read & Write Exercise Data\n'),
                const TextSpan(text: 'Read & Write Nutrition Data\n'),
                const TextSpan(text: 'Read & Write Water Intake Data\n'),
                const TextSpan(text: 'Read Heart Rate Data\n'),
                const TextSpan(text: 'Read & Write Weight Data\n'),
                TextSpan(
                  text: '\nWe respect your privacy and will not sell your data.',
                  style: context.italicStyle,
                ),
              ],
            ),
          ),
        ),
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[800],
          ),
          child: Icon(
            Icons.help_outline,
            color: Colors.blue[400],
          ),
        ),
      ),
    );
  }
}
