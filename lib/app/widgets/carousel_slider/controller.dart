import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class BedlamCarouselController extends GetxController with GetSingleTickerProviderStateMixin {
  late Duration autoPlayInterval;
  Timer? timer;

  // Reactive variables
  final initialPage = 0.obs;
  final itemCount = 0.obs;
  final items = RxList<Widget>();
  final Rxn<PageController> pageController = Rxn<PageController>();
  final logger = Get.find<Logger>();

  // Future callback variable
  Future<void> Function()? onCurrentStoryComplete;

  BedlamCarouselController(this.autoPlayInterval, {this.onCurrentStoryComplete}) {
    logger.w('BedlamCarouselController constructor');
    ever(items, (_) {
      log('items changed');
      itemCount.value = items.length;
      initialPage.value = 0;
      update();
    });
  }

  get getPageController {
    logger.i('getting page controller');

    if (pageController.value == null) {
      logger.w('initializing page controller');
      pageController.value = PageController(initialPage: 0, keepPage: false);
    }

    return pageController.value;
  }

  Timer? _getTimer() {
    logger.i('getTimer');

    return Timer.periodic(autoPlayInterval, (_) async {
      if (pageController.value == null) {
        logger.w('pageController.value.page is null');
        return;
      }
      logger.w('timer fired');
      final nextPage = pageController.value!.page!.round() + 1;

      if (nextPage >= itemCount.value) {
        _clearTimer();
        if (onCurrentStoryComplete != null) {
          await onCurrentStoryComplete!();
          pageController.value = null;
        }
      } else {
        logger.w('animating to page $nextPage');
        await pageController.value!
            .animateToPage(nextPage, duration: const Duration(milliseconds: 300), curve: Curves.ease);
        update();
      }
    });
  }

  resetController() {
    // pageController.value.dispose();
    // pageController.value = PageController(initialPage: 0);
    logger.w('resetController');
    if (pageController.value != null) {
      pageController.value!.jumpToPage(0);
    }
    update();
  }

  void _clearTimer() {
    timer?.cancel();
    timer = null;
  }

  void _resumeTimer() {
    timer ??= _getTimer();
  }

  void startShow() {
    logger.w('startShow');
    resetController();
    _resumeTimer();
  }

  @override
  void onClose() {
    _clearTimer();
    pageController.value?.dispose();
    super.onClose();
  }
}
