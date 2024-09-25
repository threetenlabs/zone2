import 'package:flutter/material.dart';


enum CenterPageEnlargeStrategy { scale, height, zoom }

class BedlamCarouselOptions {
  final double? height;
  final double aspectRatio;
  final double viewportFraction;
  final int initialPage;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Curve autoPlayCurve;
  final bool enlargeCenterPage;
  final Axis scrollDirection;
  final ValueChanged<double?>? onScrolled;
  final ScrollPhysics? scrollPhysics;
  final bool pageSnapping;
  final PageStorageKey? pageViewKey;
  final CenterPageEnlargeStrategy enlargeStrategy;
  final double enlargeFactor;
  final bool padEnds;
  final Clip clipBehavior;

  BedlamCarouselOptions({
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.enlargeCenterPage = false,
    this.onScrolled,
    this.scrollPhysics,
    this.pageSnapping = true,
    this.scrollDirection = Axis.horizontal,
    this.pageViewKey,
    this.enlargeStrategy = CenterPageEnlargeStrategy.scale,
    this.enlargeFactor = 0.3,
    this.padEnds = true,
    this.clipBehavior = Clip.hardEdge,
  });

  BedlamCarouselOptions copyWith({
    double? height,
    double? aspectRatio,
    double? viewportFraction,
    int? initialPage,
    bool? enableInfiniteScroll,
    bool? reverse,
    bool? autoPlay,
    Duration? autoPlayInterval,
    Duration? autoPlayAnimationDuration,
    Curve? autoPlayCurve,
    bool? enlargeCenterPage,
    ValueChanged<double?>? onScrolled,
    ScrollPhysics? scrollPhysics,
    bool? pageSnapping,
    PageStorageKey? pageViewKey,
    CenterPageEnlargeStrategy? enlargeStrategy,
    double? enlargeFactor,
    Clip? clipBehavior,
    bool? padEnds,
  }) =>
      BedlamCarouselOptions(
        height: height ?? this.height,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        viewportFraction: viewportFraction ?? this.viewportFraction,
        initialPage: initialPage ?? this.initialPage,
        autoPlayInterval: autoPlayInterval ?? this.autoPlayInterval,
        autoPlayAnimationDuration: autoPlayAnimationDuration ?? this.autoPlayAnimationDuration,
        autoPlayCurve: autoPlayCurve ?? this.autoPlayCurve,
        enlargeCenterPage: enlargeCenterPage ?? this.enlargeCenterPage,
        onScrolled: onScrolled ?? this.onScrolled,
        scrollPhysics: scrollPhysics ?? this.scrollPhysics,
        pageSnapping: pageSnapping ?? this.pageSnapping,
        scrollDirection: scrollDirection,
        pageViewKey: pageViewKey ?? this.pageViewKey,
        enlargeStrategy: enlargeStrategy ?? this.enlargeStrategy,
        enlargeFactor: enlargeFactor ?? this.enlargeFactor,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        padEnds: padEnds ?? this.padEnds,
      );
}
