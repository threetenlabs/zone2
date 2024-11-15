import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:zone2/app/services/notification_service.dart';
import 'package:zone2/app/utils/env.dart';

class OpenAIService extends GetxService {
  static OpenAIService get to => Get.find();
  final logger = Get.find<Logger>();

  final client = OpenAIClient(
    apiKey: Env.openaiApiKey,
  );

  @override
  void onClose() {
    // Clean up resources here
    super.onClose();
  }

  Future<Map<String, dynamic>> extractFoodsFromText(String text) async {
    try {
      final sumNumbersTool = ChatCompletionTool(
        type: ChatCompletionToolType.function,
        function: FunctionObject(
          name: "extract_foods",
          description: "Extract food items from user speech input",
          parameters: {
            'type': 'object',
            'properties': {
              'foods': {
                'type': 'array',
                'description': 'Array of food items with details',
                'items': {
                  'type': 'object',
                  'properties': {
                    'label': {'type': 'string', 'description': 'Display label for the food item'},
                    'searchTerm': {
                      'type': 'string',
                      'description': 'Simple search term for the food database'
                    },
                    'quantity': {'type': 'number', 'description': 'Numeric quantity of the food'},
                    'unit': {'type': 'string', 'description': 'Unit of measurement'},
                    'mealType': {
                      'type': 'string',
                      'description': 'Type of meal (BREAKFAST, LUNCH, DINNER, SNACK)',
                      'enumValues': ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK']
                    },
                  },
                },
              },
            },
            'required': ['foods'],
          },
        ),
      );

      final chat = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content:
                  '''Extract food items from user's speech, normalizing portions and combining similar items.
                Include quantity and preparation method when mentioned.''',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(text),
            ),
          ],
          temperature: 0,
          tools: [sumNumbersTool],
        ),
      );

      // Handle the response
      final message = chat.choices.first.message;

      if (message.toolCalls != null && message.toolCalls!.isNotEmpty) {
        final call = message.toolCalls!.first;
        if (call.function.name == "extract_foods") {
          final decodedArgs = jsonDecode(call.function.arguments);
          logger.d('OpenAI Response: $decodedArgs');
          return decodedArgs;
        }
      }

      logger.w('No valid tool calls in response');
      return {
        'foods': {'items': []}
      };
    } catch (e) {
      logger.e('Error calling OpenAI: $e');
      return {
        'foods': {'items': []}
      };
    }
  }

  Future<Map<String, dynamic>?> extractNutritionFromImage(String imagePath) async {
    try {
      final nutritionTool = ChatCompletionTool(
        type: ChatCompletionToolType.function,
        function: FunctionObject(
          name: "extract_nutrition",
          description: "Extract nutrition facts from the image",
          parameters: {
            'type': 'object',
            'properties': {
              'nutrition': {
                'type': 'object',
                'description': "Nutrition facts values",
                'properties': {
                  'calories': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["kcal"]
                      },
                    },
                  },
                  'totalFat': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["g"]
                      },
                    },
                  },
                  'saturatedFat': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["g"]
                      },
                    },
                  },
                  'sodium': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["mg"]
                      },
                    },
                  },
                  'carbohydrates': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["g"]
                      },
                    },
                  },
                  'protein': {
                    'properties': {
                      'value': {'type': 'number'},
                      'unit': {
                        'type': 'string',
                        'enumValues': ["g"]
                      },
                    },
                  },
                },
              },
            },
          },
        ),
      );

      final chat = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(content: '''Extract nutrition facts from the image. 
                  Return structured data with values and units. 
                  Focus on the most important nutrients 
                  Calories, Total Fat, Saturated Fat, Sodium, Carbohydrates, and Protein. '''),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts([
                ChatCompletionMessageContentPart.text(
                    text: 'Extract the nutrition information from this image:'),
                ChatCompletionMessageContentPart.image(
                  imageUrl: ChatCompletionMessageImageUrl(url: imagePath),
                ),
              ]),
            ),
          ],
          tools: [nutritionTool],
          temperature: 0,
        ),
      );

      final message = chat.choices.first.message;

      if (message.toolCalls != null && message.toolCalls!.isNotEmpty) {
        final call = message.toolCalls!.first;
        if (call.function.name == "extract_nutrition") {
          final decodedArgs = jsonDecode(call.function.arguments);
          logger.d('GPT-4 Vision Response: $decodedArgs');

          // Helper function to extract numeric value and unit from string
          Map<String, dynamic> extractValueAndUnit(String valueWithUnit, String defaultUnit) {
            final match = RegExp(r'(\d+)([a-zA-Z]*)').firstMatch(valueWithUnit);
            if (match != null) {
              final value = double.parse(match.group(1)!);
              final unit = match.group(2)!.isNotEmpty ? match.group(2)! : defaultUnit;
              return {'value': value, 'unit': unit};
            }
            return {'value': 0.0, 'unit': defaultUnit}; // Default to double
          }

          // Convert mg to g if necessary
          Map<String, dynamic> convertToGramsIfNeeded(Map<String, dynamic> nutrition) {
            if (nutrition['unit'] == 'mg') {
              nutrition['value'] = nutrition['value'] / 1000.0;
              nutrition['unit'] = 'g';
            }
            return nutrition;
          }

          // Extract and convert each nutrient
          final calories =
              extractValueAndUnit(decodedArgs['nutrition']['calories'].toString(), 'kcal');
          final totalFat = extractValueAndUnit(decodedArgs['nutrition']['totalFat'], 'g');
          final saturatedFat = extractValueAndUnit(decodedArgs['nutrition']['saturatedFat'], 'g');
          final sodium =
              convertToGramsIfNeeded(extractValueAndUnit(decodedArgs['nutrition']['sodium'], 'mg'));
          final carbohydrates = extractValueAndUnit(decodedArgs['nutrition']['carbohydrates'], 'g');
          final protein = extractValueAndUnit(decodedArgs['nutrition']['protein'], 'g');

          // Format the response to match the desired JSON structure
          return {
            'calories': calories,
            'totalFat': totalFat,
            'saturatedFat': saturatedFat,
            'sodium': sodium,
            'carbohydrates': carbohydrates,
            'protein': protein,
          };
        }
      }

      logger.w('No valid tool calls in response');
      NotificationService.to
          .showWarning('Error extracting nutrition', 'No valid tool calls in response');
      return null;
    } catch (e) {
      logger.e('Error calling GPT-4 Vision: $e');
      NotificationService.to.showError('Error extracting nutrition', 'Error calling AI Service');
      return null;
    }
  }
}
