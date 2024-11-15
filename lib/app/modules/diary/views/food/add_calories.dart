import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/diary/controllers/diary_controller.dart';
import 'package:zone2/app/modules/diary/views/food/food_detail.dart';

class AddCaloriesBottomSheet extends GetWidget<DiaryController> {
  const AddCaloriesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiaryController>(
      init: controller,
      builder: (c) {
        final food = controller.selectedZone2Food.value;

        if (food == null) {
          return Container();
        }

        final allFieldsPopulated = food.name.isNotEmpty &&
            food.totalCaloriesValue > 0 &&
            food.proteinValue > 0 &&
            food.totalCarbsValue > 0 &&
            food.totalFatValue > 0;

        return SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      onPressed: controller.pickAndProcessImage,
                      icon: const Icon(Icons.camera),
                      label: const Text("Capture With Camera"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controller.addCalorieNameTextController,
                      decoration: const InputDecoration(
                        labelText: 'Food Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter the name of the food',
                      ),
                      onChanged: (value) {
                        controller.updateFoodName(value);
                      },
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: controller.addCalorieCaloriesTextController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Calories',
                            suffixText: 'kcal',
                            border: OutlineInputBorder(),
                            hintText: 'Enter the value for Calories',
                          ),
                          onChanged: (value) {
                            String processedValue =
                                value.endsWith('.') ? value.substring(0, value.length - 1) : value;
                            controller.updateNutrient(
                                'calories', double.tryParse(processedValue) ?? 0);
                            controller.selectedZone2Food.value!.totalCaloriesLabel =
                                '$processedValue kcal';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: controller.addCalorieProteinTextController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Protein',
                            suffixText: 'g',
                            border: OutlineInputBorder(),
                            hintText: 'Enter the value for Protein',
                          ),
                          onChanged: (value) {
                            String processedValue =
                                value.endsWith('.') ? value.substring(0, value.length - 1) : value;
                            controller.updateNutrient(
                                'protein', double.tryParse(processedValue) ?? 0);
                            controller.selectedZone2Food.value!.proteinLabel = '$processedValue g';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: controller.addCalorieCarbohydratesTextController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Carbohydrates',
                            suffixText: 'g',
                            border: OutlineInputBorder(),
                            hintText: 'Enter the value for Carbohydrates',
                          ),
                          onChanged: (value) {
                            String processedValue =
                                value.endsWith('.') ? value.substring(0, value.length - 1) : value;
                            controller.updateNutrient(
                                'carbohydrates', double.tryParse(processedValue) ?? 0);
                            controller.selectedZone2Food.value!.totalCarbsLabel =
                                '$processedValue g';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: controller.addCalorieTotalFatTextController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Total Fat',
                            suffixText: 'g',
                            border: OutlineInputBorder(),
                            hintText: 'Enter the value for Total Fat',
                          ),
                          onChanged: (value) {
                            String processedValue =
                                value.endsWith('.') ? value.substring(0, value.length - 1) : value;
                            double parsedValue = double.tryParse(processedValue) ?? 0;
                            controller.updateNutrient('totalFat', parsedValue);
                            controller.selectedZone2Food.value!.totalFatLabel = '$processedValue g';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: allFieldsPopulated ? () => _showFoodDetail(context) : null,
                    child: const Text('Add Food to Meal'),
                  ),
                ],
              ),
            ),
          ),
        );
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
        return FoodDetailBottomSheet(
          onBack: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
