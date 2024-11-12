import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/food_detail.dart';

class AISearchBottomSheet extends GetView<DiaryController> {
  const AISearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Examples section when no results
                if (!controller.isListening.value && controller.voiceResults.isEmpty)
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

                // Results section
                if (controller.voiceResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.voiceResults.length,
                      itemBuilder: (context, index) {
                        final voiceResult = controller.voiceResults[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(voiceResult.label),
                              subtitle: Text('${voiceResult.quantity} ${voiceResult.unit}'),
                              trailing: Text(voiceResult.mealType.toString().split('.').last),
                              onTap: () => controller.selectFoodFromVoice(voiceResult.searchTerm),
                            ),
                            // Horizontal search results
                            Obx(() {
                              final searchResults = controller.foodSearchResults.value;
                              if (searchResults != null &&
                                  controller.selectedVoiceFood == voiceResult.searchTerm) {
                                return SizedBox(
                                  height: 160,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: searchResults.foods.length,
                                    itemBuilder: (context, foodIndex) {
                                      final food = searchResults.foods[foodIndex];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: InkWell(
                                          onTap: () {
                                            controller.selectedOpenFoodFactsFood.value = food;
                                            controller.selectedZone2Food.value =
                                                Zone2Food.fromOpenFoodFactsFood(food);
                                            controller.selectedMealType.value =
                                                voiceResult.mealType;
                                            controller.foodServingController.text =
                                                voiceResult.quantity.toString();

                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (_) => FoodDetailBottomSheet(
                                                onBack: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ).then((_) {
                                              if (context.mounted && controller.voiceResults.isEmpty) {
                                                Navigator.pop(context);
                                              }
                                            });
                                          },
                                          child: Card(
                                            child: SizedBox(
                                              width: 200,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      food.description,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Brand: ${food.brand}',
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                    Text(
                                                      'Serving: ${food.servingSize} ${food.servingSizeUnit}',
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                    Text(
                                                      'Calories: ${food.description}',
                                                      style: Theme.of(context).textTheme.bodySmall,
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
                              return const SizedBox.shrink();
                            }),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),

                // Voice input button
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
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
