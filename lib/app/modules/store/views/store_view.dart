import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text('StoreView'),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Text(
          'StoreView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
