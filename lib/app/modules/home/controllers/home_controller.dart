import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:app_links/app_links.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:zone2/app/modules/diary/bindings/diary_binding.dart';
import 'package:zone2/app/modules/diary/views/diary_view.dart';
import 'package:zone2/app/modules/profile/bindings/profile_binding.dart';
import 'package:zone2/app/modules/profile/views/profile_view.dart';
import 'package:zone2/app/modules/track/bindings/track_binding.dart';
import 'package:zone2/app/modules/track/views/track_view.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  final contentIndex = 0.obs;
  final audioOn = false.obs;
  final palette = Get.find<Palette>();
  final logger = Get.find<Logger>();
  final firebaseService = Get.find<FirebaseService>();
  final NotchBottomBarController notchController = NotchBottomBarController(index: 0);

  RxList<BottomNavigationBarItem> navBarItems = RxList<BottomNavigationBarItem>();
  late AppLinks appLinks;
  StreamSubscription<Uri>? linkSubscription;

  @override
  void onInit() {
    super.onInit();

    navBarItems.value = [
      BottomNavigationBarItem(
        icon: Icon(
          Symbols.checklist,
        ),
        activeIcon: Icon(
          Symbols.checklist,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Symbols.monitoring),
        activeIcon: Icon(
          Symbols.monitoring,
        ),
        label: 'Tracking',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Symbols.account_circle,
        ),
        activeIcon: Icon(
          Symbols.account_circle,
        ),
        label: 'Coaching',
      ),
    ];

    ever(contentIndex, (_) {
      update();
    });
  }

  final pages = <String>['/home' '/tracking', '/coaching'];

  void changePage(int index) {
    contentIndex.value = index;
    String route = '/${navBarItems[index].label!.toLowerCase()}';
    if (route == '/home') {
      route = '/diary';
    }
    logger.d('Navigating to $route');
    Get.toNamed(route, id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/diary') {
      return GetPageRoute(
        settings: settings,
        page: () => const DiaryView(),
        binding: DiaryBinding(),
      );
    }

    if (settings.name == '/tracking') {
      return GetPageRoute(
        settings: settings,
        page: () => const TrackView(),
        binding: TrackBinding(),
      );
    }

    if (settings.name == '/coaching') {
      return GetPageRoute(
        settings: settings,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
      );
    }

    return null;
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // Future<void> initDeepLinks() async {
  //   appLinks = AppLinks();

  //   // Check initial link if app was in cold state (terminated)
  //   final appLink = await appLinks.getInitialLink();
  //   logger.w('Initial link: $appLink');

  //   if (appLink != null) {
  //     await Future.delayed(const Duration(milliseconds: 100)); // Gives the app time to initialize

  //     DeepLinkService.to.handleDeepLink(appLink, isInitialLink: true);
  //   }

  //   // Handle link when app is in warm state (front or background)
  //   linkSubscription = appLinks.uriLinkStream.listen((uri) {
  //     logger.w('Processing link: $uri');
  //     DeepLinkService.to.handleDeepLink(uri);
  //   });
  // }
}
