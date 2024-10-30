import 'package:flutter/material.dart';
import 'package:zone2/app/models/food.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/widgets/nutritional_card.dart';

enum ConversionType {
  openfoodfacts,
  health,
}

class FoodDetailBottomSheet extends GetView<DiaryController> {
  final ConversionType conversionType;
  const FoodDetailBottomSheet({super.key, required this.conversionType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context), // Close the bottom sheet
                    ),
                  ),
                  Text(controller.selectedZone2Food.value?.name ?? '',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Text('Brand: ${controller.selectedMeal.value?.n ?? ''}',
                  //     style: const TextStyle(fontSize: 18)),
                  // const SizedBox(height: 16),
                  Obx(() => _buildNutritionalCard()),
                  const SizedBox(height: 16),
                  _buildAddToMealSection(context, controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionalCard() {
    final meal = conversionType == ConversionType.openfoodfacts
        ? Zone2Food.fromOpenFoodFactsFood(
            controller.selectedOpenFoodFactsFood.value!, controller.selectedMealType.value)
        : Zone2Food.fromHealthDataPoint(controller.selectedPlatformHealthFood.value!);

    controller.selectedZone2Food.value = meal;

    return const NutritionalCard();
  }

  Widget _buildAddToMealSection(BuildContext context, DiaryController controller) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Serving(s)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Numeric input for serving count
                Obx(
                  () => SizedBox(
                    width: 100,
                    child: TextField(
                      enabled: controller.selectedZone2Food.value?.startTime == null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Qty',
                      ),
                      controller: controller.foodServingController,
                      // onChanged: (value) {
                      //   controller.foodServingQty.value = double.tryParse(value) ?? 0.0;
                      // },
                    ),
                  ),
                ),
                // Read-only label for serving size
                Obx(
                  () => Text(
                    controller.selectedZone2Food.value?.servingLabel.isNotEmpty ?? false
                        ? controller.selectedZone2Food.value!.servingLabel
                        : 'Serving',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.selectedZone2Food.value?.startTime == null)
              ElevatedButton(
                onPressed: controller.foodServingController.text.isNotEmpty
                    ? () {
                        controller.saveMealToHealth();
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Add to Meal'),
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Food'),
                      content: const Text('Are you sure you want to delete this food?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteFood(controller.selectedZone2Food.value!.startTime!,
                                controller.selectedZone2Food.value!.endTime!);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                label: const Text('Delete Food'),
              ),
          ],
        ),
      ),
    );
  }
}
