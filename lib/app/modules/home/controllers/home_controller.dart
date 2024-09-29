import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:zone2/app/modules/diary/bindings/diary_binding.dart';
import 'package:zone2/app/modules/diary/views/diary_view.dart';

import 'package:zone2/app/modules/profile/bindings/profile_binding.dart';
import 'package:zone2/app/modules/profile/views/profile_view.dart';
import 'package:zone2/app/modules/settings/bindings/settings_binding.dart';
import 'package:zone2/app/modules/settings/views/settings_view.dart';
import 'package:zone2/app/modules/store/bindings/store_binding.dart';
import 'package:zone2/app/modules/store/views/store_view.dart';
import 'package:zone2/app/services/firebase_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:zone2/app/widgets/skinner/animated_nav_bar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class HomeController extends GetxController {
  final contentIndex = 0.obs;
  final audioOn = false.obs;
  final palette = Get.find<Palette>();
  final logger = Get.find<Logger>();
  final firebaseService = Get.find<FirebaseService>();

  RxList<NavBarItemData> navBarItems = RxList<NavBarItemData>();
  late AppLinks appLinks;
  StreamSubscription<Uri>? linkSubscription;

  @override
  void onInit() {
    super.onInit();

    navBarItems.value = [
      NavBarItemData("Diary", OMIcons.book, 110, palette.mainMenuGames),
      NavBarItemData("Zone", OMIcons.trackChanges, 115, palette.mainMenuSettings),
      NavBarItemData("Track", OMIcons.barChart, 100, palette.mainMenuStore),
      NavBarItemData("Profile", OMIcons.accountCircle, 105, palette.mainMenuProfile),
    ];

    ever(contentIndex, (_) {
      update();
    });
  }

  final pages = <String>['/diary', '/zone', '/track', '/profile'];

  void changePage(int index) {
    contentIndex.value = index;
    Get.toNamed('/${navBarItems[index].title.toLowerCase()}', id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/diary') {
      return GetPageRoute(
        settings: settings,
        page: () => const DiaryView(),
        binding: LandingBinding(),
      );
    }

    if (settings.name == '/zone') {
      return GetPageRoute(
        settings: settings,
        page: () => const SettingsView(),
        binding: SettingsBinding(),
      );
    }

    if (settings.name == '/track') {
      return GetPageRoute(
        settings: settings,
        page: () => const StoreView(),
        binding: StoreBinding(),
      );
    }

    if (settings.name == '/profile') {
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
