import 'package:app/app/modules/settings/controllers/settings_controller.dart';
import 'package:app/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPortraitSmall extends GetWidget<SettingsController> {
  const SettingsPortraitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    return PopScope(
      onPopInvoked: (bool value) {
        return;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GetBuilder<SettingsController>(
            builder: (controller) => Theme(
              data: palette.primaryTheme,
              child: PopScope(
                canPop: false,
                child: Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<PackageInfo>(
                              future: PackageInfo.fromPlatform(),
                              builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                      'Version: ${snapshot.data?.version}(${snapshot.data?.buildNumber})');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
