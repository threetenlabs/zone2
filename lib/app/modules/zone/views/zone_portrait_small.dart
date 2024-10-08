import 'package:zone2/app/modules/zone/controllers/zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ZonePortraitSmall extends GetWidget<ZoneController> {
  const ZonePortraitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool value, Object? result) {
        return;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GetBuilder<ZoneController>(
            builder: (controller) => PopScope(
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
          );
        },
      ),
    );
  }
}
