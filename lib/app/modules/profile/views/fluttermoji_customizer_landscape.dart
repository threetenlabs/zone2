import 'dart:math';

import 'package:app/app/modules/profile/controllers/profile_controller.dart';
import 'package:app/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttermoji/fluttermoji.dart';

class FluttermojiCustomizerLandscape extends GetWidget<ProfileController> {
  final Palette palette = Palette();
  FluttermojiCustomizerLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(onPopInvoked: (bool value) {
      controller.saveFluttermoji();
      return;
    }, child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Customize"),
          ),
          body: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: FluttermojiCircleAvatar(
                    radius: min(70, height * 0.15),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: FluttermojiCustomizer(
                      scaffoldWidth: width * 0.50,
                      scaffoldHeight: min(300, height * 0.65),
                      autosave: true,
                      theme: FluttermojiThemeData(
                          boxDecoration: const BoxDecoration(boxShadow: [BoxShadow()])),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
