import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/food_detail.dart';
import 'package:zone2/app/modules/diary/widgets/food_card.dart';

class FoodCarousel extends GetView<DiaryController> {
  const FoodCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filteredMeals.isNotEmpty) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: CarouselView(
              itemExtent: 330,
              shrinkExtent: 200,
              onTap: (index) {
                controller.selectedZone2Food.value =
                    Zone2Food.fromHealthDataPoint(controller.filteredMeals[index]);
                controller.foodServingController.text =
                    controller.selectedZone2Food.value?.servingQuantity.toStringAsFixed(1) ?? '';
                _showFoodDetail(context);
              },
              children: List<Widget>.generate(controller.filteredMeals.length, (int index) {
                final item = controller.filteredMeals[index];
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
