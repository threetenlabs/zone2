import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class OpenAIService extends GetxService {
  static OpenAIService get to => Get.find();
  final logger = Get.find<Logger>();

  final OpenAI openAI = Get.find<OpenAI>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Called after onInit when the service is ready
  }

  @override
  void onClose() {
    // Clean up resources here
    super.onClose();
  }

  Future<OpenAICompletionModelChoice> getCompletion(String prompt) async {
    final completion = await OpenAI.instance.completion.create(
      model: 'gpt-4o-mini',
      prompt: prompt,
    );
    return completion.choices.first;
  }

  Future<Map<String, dynamic>> extractFoodsFromText(String text) async {
    try {
      final sumNumbersTool = OpenAIToolModel(
        type: "function",
        function: OpenAIFunctionModel.withParameters(
          name: "extract_foods",
          description: "Extract food items from user speech input",
          parameters: [
            OpenAIFunctionProperty.object(
              name: "foods",
              description: "Array of food items with details",
              properties: [
                OpenAIFunctionProperty.array(
                  name: "items",
                  description: "List of food items",
                  items: OpenAIFunctionProperty.object(
                    name: "food",
                    properties: [
                      OpenAIFunctionProperty.string(
                        name: "label",
                        description: "Display label for the food item",
                      ),
                      OpenAIFunctionProperty.string(
                        name: "searchTerm",
                        description: "Simple search term for the food database",
                      ),
                      OpenAIFunctionProperty.number(
                        name: "quantity",
                        description: "Numeric quantity of the food",
                      ),
                      OpenAIFunctionProperty.string(
                        name: "unit",
                        description: "Unit of measurement",
                      ),
                      OpenAIFunctionProperty.string(
                        name: "mealType",
                        description: "Type of meal (BREAKFAST, LUNCH, DINNER, SNACK)",
                        enumValues: ["BREAKFAST", "LUNCH", "DINNER", "SNACK"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      // Create the chat completion
      final chat = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  '''Extract food items from user's speech, normalizing portions and combining similar items.
                Include quantity and preparation method when mentioned.'''),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(text),
            ],
          ),
        ],
        tools: [sumNumbersTool],
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
}
