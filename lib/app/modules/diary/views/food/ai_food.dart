import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class AISearchBottomSheet extends GetView<DiaryController> {
  const AISearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed:
              controller.isListening.value ? controller.stopListening : controller.startListening,
          child: Icon(controller.isListening.value ? Icons.mic_off : Icons.mic),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    controller.isListening.value ? 'Listening...' : 'Tap the microphone to start',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.recognizedWords.value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (controller.isProcessing.value)
              const CircularProgressIndicator()
            else
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: controller.matchedFoods.length,
                    itemBuilder: (context, index) {
                      final foodMatch = controller.matchedFoods[index];
                      return ListTile(
                        title: Text(foodMatch),
                        onTap: () {
                          // Handle selection of specific food item
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        )));
  }
}
