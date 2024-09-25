import 'dart:math';

import 'package:app/app/modules/profile/controllers/profile_controller.dart';
import 'package:app/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttermoji/fluttermoji.dart';

class FluttermojiCustomizerPage extends GetWidget<ProfileController> {
  final Palette palette = Palette();
  FluttermojiCustomizerPage({super.key});

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
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: FluttermojiCircleAvatar(
                      radius: min(70, height * 0.1),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(
                    width: min(600, width * 0.85),
                    child: Row(
                      children: [
                        Text("Customize:", style: palette.primaryTheme.textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                    child: FluttermojiCustomizer(
                      scaffoldWidth: min(600, width * 0.85),
                      scaffoldHeight: min(300, height * 0.35),
                      autosave: true,
                      theme: FluttermojiThemeData(
                          boxDecoration: const BoxDecoration(boxShadow: [BoxShadow()])),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
