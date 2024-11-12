import 'package:flutter/material.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/widgets/nutritional_card.dart';
import 'package:zone2/app/services/health_service.dart';

enum ConversionType {
  openfoodfacts,
  health,
}

class FoodDetailBottomSheet extends GetView<DiaryController> {
  final VoidCallback onBack;
  const FoodDetailBottomSheet({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<DiaryController>(
          init: controller,
          builder: (c) {
            return SingleChildScrollView(
              child: IntrinsicHeight(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
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
                      const NutritionalCard(),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Serving(s)',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Numeric input for serving count
                                  Obx(
                                    () => SizedBox(
                                      width: 100,
                                      child: TextField(
                                        enabled:
                                            controller.selectedZone2Food.value?.startTime == null,
                                        readOnly:
                                            controller.selectedZone2Food.value?.startTime != null,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Qty',
                                        ),
                                        controller: controller.foodServingController,
                                        onChanged: (value) {
                                          // Enable/disable save button based on valid input
                                          if (value.isNotEmpty && double.tryParse(value) != null) {
                                            controller.foodServingQty.value =
                                                double.tryParse(value);
                                          } else {
                                            controller.foodServingQty.value = null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  // Read-only label for serving size
                                  Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        controller.selectedZone2Food.value?.servingLabel
                                                    .isNotEmpty ??
                                                false
                                            ? controller.selectedZone2Food.value!.servingLabel
                                            : 'Serving',
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text('Meal Type',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Obx(() {
                                final isEditable =
                                    controller.selectedZone2Food.value?.startTime == null;
                                final selectedValue = isEditable
                                    ? HealthService.to.convertMealthTypeToDouble(
                                        controller.selectedMealType.value)
                                    : controller.selectedZone2Food.value?.mealTypeValue;

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio<double>(
                                        value: 1.0,
                                        groupValue: selectedValue,
                                        onChanged: isEditable
                                            ? (value) {
                                                controller.selectedMealType.value = HealthService.to
                                                    .convertDoubleToMealType(value!);
                                                controller.selectedZone2Food.value!.mealTypeValue =
                                                    value;
                                              }
                                            : null,
                                      ),
                                      const Text('Breakfast'),
                                      Radio<double>(
                                        value: 2.0,
                                        groupValue: selectedValue,
                                        onChanged: isEditable
                                            ? (value) {
                                                controller.selectedMealType.value = HealthService.to
                                                    .convertDoubleToMealType(value!);
                                                controller.selectedZone2Food.value!.mealTypeValue =
                                                    value;
                                              }
                                            : null,
                                      ),
                                      const Text('Lunch'),
                                      Radio<double>(
                                        value: 3.0,
                                        groupValue: selectedValue,
                                        onChanged: isEditable
                                            ? (value) {
                                                controller.selectedMealType.value = HealthService.to
                                                    .convertDoubleToMealType(value!);
                                                controller.selectedZone2Food.value!.mealTypeValue =
                                                    value;
                                              }
                                            : null,
                                      ),
                                      const Text('Dinner'),
                                      Radio<double>(
                                        value: 4.0,
                                        groupValue: selectedValue,
                                        onChanged: isEditable
                                            ? (value) {
                                                controller.selectedMealType.value = HealthService.to
                                                    .convertDoubleToMealType(value!);
                                                controller.selectedZone2Food.value!.mealTypeValue =
                                                    value;
                                              }
                                            : null,
                                      ),
                                      const Text('Snack'),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),
                              if (controller.selectedZone2Food.value?.startTime == null)
                                Obx(() => ElevatedButton(
                                      onPressed: controller.foodServingQty.value != null
                                          ? () {
                                              controller.saveMealToHealth();
                                              onBack?.call();
                                            }
                                          : null,
                                      child: const Text('Add to Meal'),
                                    ))
                              else
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Delete Food'),
                                        content: const Text(
                                            'Are you sure you want to delete this food?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              controller.deleteFood();
                                              Get.back();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Confirm',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                        .withOpacity(.5))),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    iconColor: Theme.of(context).colorScheme.error.withOpacity(.5),
                                  ),
                                  label: Text('Delete Food',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).colorScheme.error.withOpacity(.5))),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
