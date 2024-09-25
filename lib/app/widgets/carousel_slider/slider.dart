// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart'; // Ensure you have the correct import path
import 'options.dart'; // Ensure you have the correct import path

class BedlamCarouselSlider extends StatelessWidget {
  final BedlamCarouselOptions options;
  final BedlamCarouselController controller;

  const BedlamCarouselSlider({
    super.key,
    required this.options,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BedlamCarouselController>(
      init: controller,
      builder: (c) {
        return PageView.builder(
          controller: c.getPageController,
          scrollDirection: options.scrollDirection,
          itemCount: c.itemCount.value,
          physics: options.scrollPhysics,
          itemBuilder: (context, idx) {
            return AnimatedBuilder(
              animation: c.getPageController,
              builder: (context, child) {
                double distortionValue = 1.0;
                double itemOffset = 0;
                if (options.enlargeCenterPage) {
                  itemOffset = c.getPageController.page! - idx;
                  final enlargeFactor = options.enlargeFactor.clamp(0.0, 1.0);
                  final distortionRatio = (1 - (itemOffset.abs() * enlargeFactor)).clamp(0.0, 1.0);
                  distortionValue = Curves.easeOut.transform(distortionRatio);
                }

                final double height =
                    options.height ?? MediaQuery.of(context).size.width * (1 / options.aspectRatio);

                return options.scrollDirection == Axis.horizontal
                    ? _getCenterWrapper(_getEnlargeWrapper(
                        child,
                        height: distortionValue * height,
                        scale: distortionValue,
                        itemOffset: itemOffset,
                        options: options,
                      ))
                    : _getCenterWrapper(_getEnlargeWrapper(
                        child,
                        width: distortionValue * MediaQuery.of(context).size.width,
                        scale: distortionValue,
                        itemOffset: itemOffset,
                        options: options,
                      ));
              },
              child: c.items.isNotEmpty ? c.items[idx] : Container(),
            );
          },
        );
      },
    );
  }
}

class _getCenterWrapper extends StatelessWidget {
  const _getCenterWrapper(this.child);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(child: child);
  }
}

class _getEnlargeWrapper extends StatelessWidget {
  const _getEnlargeWrapper(
    this.child, {
    this.width,
    this.height,
    this.scale,
    required this.itemOffset,
    required this.options,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final double? scale;
  final double itemOffset;
  final BedlamCarouselOptions options;

  @override
  Widget build(BuildContext context) {
    if (options.enlargeStrategy == CenterPageEnlargeStrategy.height) {
      return SizedBox(width: width, height: height, child: child);
    }
    if (options.enlargeStrategy == CenterPageEnlargeStrategy.zoom) {
      late Alignment alignment;
      final bool horizontal = options.scrollDirection == Axis.horizontal;
      if (itemOffset > 0) {
        alignment = horizontal ? Alignment.centerRight : Alignment.bottomCenter;
      } else {
        alignment = horizontal ? Alignment.centerLeft : Alignment.topCenter;
      }
      return Transform.scale(scale: scale!, alignment: alignment, child: child);
    }
    return Transform.scale(
      scale: scale!,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
