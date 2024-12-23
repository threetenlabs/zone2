import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/add_calories.dart';
import 'package:zone2/app/modules/diary/views/food/ai_food.dart';
import 'package:zone2/app/modules/diary/views/food/food_search.dart';
import 'package:zone2/app/modules/diary/views/food/scanner/scan_food_bottomsheet.dart';

class AddFoodBottomSheet extends GetView<DiaryController> {
  const AddFoodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height, // Full screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // Close the bottom sheet
                ),
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            onPressed: () => _showSearchBottomSheet(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const Text('Search'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.barcode_reader),
                            onPressed: () => _showScanFoodBottomSheet(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const Text('Scan Barcode'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              controller.initializeZone2Food();
                              _showAddCaloriesBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const Text('Add Calories'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.speaker_notes_outlined),
                            onPressed: () => _showAIBottomSheet(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            label: const Text('Tell Me'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildMealList()), // Keep the meal list here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealList() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Frequent'),
              Tab(text: 'Favorites'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Frequent items tab
                _buildMockList(const [
                  {
                    'name': 'Chicken Breast',
                    'calories': 165,
                    'protein': 31,
                    'fat': 3.6,
                    'carbs': 0
                  },
                  {'name': 'Protein Shake', 'calories': 120, 'protein': 24, 'fat': 1, 'carbs': 3},
                  {'name': 'Banana', 'calories': 105, 'protein': 1.3, 'fat': 0.4, 'carbs': 27},
                ]),

                // Favorites tab
                _buildMockList(const [
                  {'name': 'Oatmeal', 'calories': 150, 'protein': 5, 'fat': 3, 'carbs': 27},
                  {'name': 'Greek Yogurt', 'calories': 130, 'protein': 12, 'fat': 4, 'carbs': 9},
                  {'name': 'Almonds', 'calories': 164, 'protein': 6, 'fat': 14, 'carbs': 6},
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text('Food: ${item['name']}'),
          subtitle: Text(
            'Calories: ${item['calories']} | Protein: ${item['protein']}g | '
            'Fat: ${item['fat']}g | Carbs: ${item['carbs']}g',
          ),
          onTap: () {
            // TODO: Implement quick add functionality
          },
        );
      },
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const FoodSearchWidget(); // Use the new widget here
      },
    );
  }

  void _showAIBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AISearchBottomSheet(); // Use the new widget here
      },
    );
  }

  void _showScanFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const ScanFoodBottomSheet(); // Use the new widget here
      },
    );
  }

  void _showAddCaloriesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AddCaloriesBottomSheet(); // Use the new widget here
      },
    );
  }
}
