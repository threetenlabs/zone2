import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/add_food.dart';
import 'package:zone2/app/modules/diary/views/food/food_detail.dart';
import 'package:zone2/app/modules/diary/widgets/food_card.dart';

class ShowFoodBottomSheet extends GetView<DiaryController> {
  const ShowFoodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFoodBottomSheet(context), // Call search method
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height, // Full screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Close button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // Close the bottom sheet
                ),
              ),
              Text(
                controller.selectedMealType.value.toString().split('.').last,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 100,
                child: Card(
                  elevation: 8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Protein'),
                          SizedBox(
                            width: 75, // Set a fixed width
                            child: LinearProgressIndicator(
                              value: 0.5, // Example value
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          Text('50%'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Carbs'),
                          SizedBox(
                            width: 75, // Set a fixed width
                            child: LinearProgressIndicator(
                              value: 0.7, // Example value
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                          Text('70%'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Fat'),
                          SizedBox(
                            width: 75, // Set a fixed width
                            child: LinearProgressIndicator(
                              value: 0.3, // Example value
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                          Text('30%'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Calories'),
                          SizedBox(
                            width: 75, // Set a fixed width
                            child: LinearProgressIndicator(
                              value: 0.6, // Example value
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                            ),
                          ),
                          Text('60%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildFoodCarousel(context), // Keep the meal list here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCarousel(BuildContext context) {
    RxList<HealthDataPoint> mealList;
    switch (controller.selectedMealType.value) {
      case MealType.BREAKFAST:
        mealList = controller.breakfastData;
        break;
      case MealType.LUNCH:
        mealList = controller.lunchData;
        break;
      case MealType.DINNER:
        mealList = controller.dinnerData;
        break;
      case MealType.SNACK:
        mealList = controller.snackData;
        break;
      default:
        mealList = controller.breakfastData;
        break;
    }
    return Obx(() {
      if (mealList.isNotEmpty) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: CarouselView(
              itemExtent: 330,
              shrinkExtent: 200,
              onTap: (index) {
                // controller.selectedPlatformHealthFood.value = mealList[index];
                controller.selectedZone2Food.value = Zone2Food.fromHealthDataPoint(mealList[index]);
                controller.foodServingController.text =
                    controller.selectedZone2Food.value?.servingQuantity.toStringAsFixed(1) ?? '';
                _showFoodDetail(context);
              },
              children: List<Widget>.generate(mealList.length, (int index) {
                final item = mealList[index];
                final nutritionHealthValue = item.value as NutritionHealthValue;
                return FoodCarouselCard(
                    index: index,
                    label: nutritionHealthValue.name?.split(' | ')[0] ?? '',
                    calories: nutritionHealthValue.calories ?? 0.0,
                    protein: nutritionHealthValue.protein ?? 0.0,
                    fat: nutritionHealthValue.fat ?? 0.0,
                    carbs: nutritionHealthValue.carbs ?? 0.0);
              }),
            ),
          ),
        );
      } else {
        return const Text('No meals logged');
      }
    });
  }

  void _showAddFoodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      enableDrag: false,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      builder: (context) {
        return const AddFoodBottomSheet();
      },
    );
  }

  void _showFoodDetail(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      isScrollControlled: true, // Allow full screen
      useSafeArea: true,
      context: context,
      builder: (context) {
        return const FoodDetailBottomSheet();
      },
    );
  }
}
