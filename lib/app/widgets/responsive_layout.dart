import 'package:zone2/app/extensions/extensions.dart';
import 'package:flutter/material.dart';

// Define a class that encapsulates responsive layout logic
class ResponsiveLayout extends StatelessWidget {
  final Widget Function() renderSmallPortrait;
  final Widget Function() renderMediumPortrait;
  final Widget Function() renderLargePortrait;
  final Widget Function() renderSmallLandscape;
  final Widget Function() renderMediumLandscape;
  final Widget Function() renderLargeLandscape;

  const ResponsiveLayout({
    super.key,
    required this.renderSmallPortrait,
    required this.renderMediumPortrait,
    required this.renderLargePortrait,
    required this.renderSmallLandscape,
    required this.renderMediumLandscape,
    required this.renderLargeLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        return context.responsiveAction(
          renderSmallPortait: () => renderSmallPortrait(),
          renderMediumPortait: () => renderMediumPortrait(),
          renderLargePortait: () => renderLargePortrait(),
          renderSmallLandscape: () => renderSmallLandscape(),
          renderMediumLandscape: () => renderMediumLandscape(),
          renderLargeLandscape: () => renderLargeLandscape(),
        );
      });
    });
  }
}
