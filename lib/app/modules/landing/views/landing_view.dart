import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LandingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LandingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
