import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NotImplementedWidget extends GetView {
  const NotImplementedWidget({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Text(
                  'Not Implemented',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
