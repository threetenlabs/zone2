import 'package:zone2/app/modules/zone/views/zone_portrait_small.dart';
import 'package:zone2/app/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/zone_controller.dart';

class ZoneView extends GetView<ZoneController> {
  const ZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Get.find<Logger>();
    logger.i('Zone View is Built');
    return ResponsiveLayout(
      renderSmallPortrait: () => const ZonePortraitSmall(),
      renderMediumPortrait: () => const ZonePortraitSmall(),
      renderLargePortrait: () => const ZonePortraitSmall(),
      renderSmallLandscape: () => const ZonePortraitSmall(),
      renderMediumLandscape: () => const ZonePortraitSmall(),
      renderLargeLandscape: () => const ZonePortraitSmall(),
    );
  }
}
