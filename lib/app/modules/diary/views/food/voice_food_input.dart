import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';

class VoiceFoodInputView extends GetView<DiaryController> {
  const VoiceFoodInputView({Key? key}) : super(key: key);

  Widget _buildSuggestionCard(BuildContext context,
      {required String title,
      required String example,
      required VoidCallback onTap,
      List<String>? results}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForMeal(title),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Try saying:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                example,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (results != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Will extract:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                ...results.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForMeal(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.apple;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildErrorState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        Text(
          'Speech Recognition Failed',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          controller.lastError.value?.errorMsg ?? 'Unknown error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Try these instead:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSuggestionCard(
                  context,
                  title: 'Breakfast',
                  example: 'For breakfast I had two eggs with toast and coffee',
                  onTap: () => controller
                      .extractFoodItemsOpenAI('For breakfast I had two eggs with toast and coffee'),
                  results: [
                    '2 eggs (scrambled)',
                    '1 slice toast',
                    '1 cup black coffee',
                  ],
                ),
                _buildSuggestionCard(
                  context,
                  title: 'Lunch',
                  example: 'I ate a grilled chicken salad with avocado for lunch',
                  onTap: () => controller.extractFoodItemsOpenAI(
                      'I ate a grilled chicken salad with avocado for lunch'),
                  results: [
                    '1 grilled chicken breast',
                    '2 cups mixed salad',
                    '1/2 avocado',
                  ],
                ),
                _buildSuggestionCard(
                  context,
                  title: 'Dinner',
                  example: 'My dinner was salmon with rice and broccoli',
                  onTap: () => controller
                      .extractFoodItemsOpenAI('My dinner was salmon with rice and broccoli'),
                  results: [
                    '6 oz salmon (baked)',
                    '1 cup brown rice',
                    '1 cup steamed broccoli',
                  ],
                ),
                _buildSuggestionCard(
                  context,
                  title: 'Snack',
                  example: 'Had an apple with peanut butter as a snack',
                  onTap: () => controller
                      .extractFoodItemsOpenAI('Had an apple with peanut butter as a snack'),
                  results: [
                    '1 medium apple',
                    '2 tbsp peanut butter',
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.cancelListening();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Voice Input'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller.cancelListening();
                controller.hasError.value = false;
                controller.matchedFoods.clear();
                controller.recognizedWords.value = '';
                Get.until((route) => route.settings.name == '/landing');
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.cancelListening();
              controller.hasError.value = false;
              controller.matchedFoods.clear();
              controller.recognizedWords.value = '';
              Get.until((route) => route.settings.name == '/landing');
            },
          ),
        ),
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top section with suggestions
                if (!controller.isListening.value && controller.matchedFoods.isEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Try saying something like:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildQuickSuggestion(
                            context,
                            title: 'Quick Breakfast',
                            phrase: 'I had two eggs and toast for breakfast',
                            onTap: () {
                              controller
                                  .extractFoodItemsOpenAI('I had two eggs and toast for breakfast');
                            },
                            expectedResults: [
                              '2 eggs (scrambled)',
                              '1 slice toast',
                            ],
                          ),
                          _buildQuickSuggestion(
                            context,
                            title: 'Simple Lunch',
                            phrase: 'Chicken salad with avocado',
                            onTap: () {
                              controller.extractFoodItemsOpenAI('Chicken salad with avocado');
                            },
                            expectedResults: [
                              '1 grilled chicken breast',
                              '2 cups mixed greens',
                              '1/2 avocado',
                            ],
                          ),
                          _buildQuickSuggestion(
                            context,
                            title: 'Easy Dinner',
                            phrase: 'Salmon with rice and vegetables',
                            onTap: () {
                              controller.extractFoodItemsOpenAI('Salmon with rice and vegetables');
                            },
                            expectedResults: [
                              '6 oz salmon (baked)',
                              '1 cup brown rice',
                              '1 cup mixed vegetables',
                            ],
                          ),
                          _buildQuickSuggestion(
                            context,
                            title: 'Healthy Snack',
                            phrase: 'Apple and almonds',
                            onTap: () {
                              controller.extractFoodItemsOpenAI('Apple and almonds');
                            },
                            expectedResults: [
                              '1 medium apple',
                              '1 oz almonds (about 23)',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Results section (when foods are matched)
                if (controller.matchedFoods.isNotEmpty)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Found Items',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          if (controller.recognizedWords.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                '"${controller.recognizedWords.value}"',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.matchedFoods.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    leading: const Icon(Icons.check_circle),
                                    title: Text(controller.matchedFoods[index]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        controller
                                            .selectFoodFromVoice(controller.matchedFoods[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Voice input button always at bottom
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTapDown: (_) => controller.startListening(),
                        onTapUp: (_) => controller.stopListening(),
                        onTapCancel: () => controller.cancelListening(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: controller.isListening.value ? 100 : 80,
                              height: controller.isListening.value ? 100 : 80,
                              decoration: BoxDecoration(
                                color: controller.isListening.value
                                    ? Colors.green
                                    : Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.mic,
                                size: controller.isListening.value ? 50 : 40,
                                color: Colors.white,
                              ),
                            ),
                            if (controller.isProcessing.value)
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.isListening.value ? 'Listening...' : 'Hold to speak',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickSuggestion(
    BuildContext context, {
    required String title,
    required String phrase,
    required VoidCallback onTap,
    required List<String> expectedResults,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"$phrase"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                ),
              ),
              const Divider(),
              const Text(
                'Will extract:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              ...expectedResults.map((result) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(result),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
