import 'package:zone2/app/modules/profile/views/widgets/settings_tab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import 'widgets/zone_settings_tab.dart';

class ProfileViewPortraitSmall extends GetWidget<ProfileController> {
  const ProfileViewPortraitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Zone Settings'),
              Tab(text: 'App Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ZoneSettingsTab(),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}
