import 'package:app/app/modules/update/controllers/update_controller.dart';
import 'package:app/app/modules/update/views/update_small.dart';
import 'package:app/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UpdateView extends GetWidget<UpdateController> {
  const UpdateView({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      renderSmallPortrait: () => const UpdateSmall(),
      renderMediumPortrait: () => const UpdateSmall(),
      renderLargePortrait: () => const UpdateSmall(),
      renderSmallLandscape: () => const UpdateSmall(),
      renderMediumLandscape: () => const UpdateSmall(),
      renderLargeLandscape: () => const UpdateSmall(),
    );
  }
}
