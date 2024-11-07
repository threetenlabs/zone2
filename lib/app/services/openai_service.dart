import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class OpenAIService extends GetxService {
  static OpenAIService get to => Get.find();
  final logger = Get.find<Logger>();

  OpenAIService() {
    OpenAI.apiKey = const String.fromEnvironment('OPENAI_API_KEY');
    OpenAI.organization = const String.fromEnvironment('OPENAI_ORG_ID');
    // Enable logs for debugging
    OpenAI.showLogs = true;
    OpenAI.showResponsesLogs = true;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<Map<String, dynamic>> extractFoodsFromText(String text) async {
    try {
      // Create the function definition
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
                        name: "item",
                        description: "The food item name",
                      ),
                      OpenAIFunctionProperty.string(
                        name: "quantity",
                        description: "The quantity or portion size",
                      ),
                      OpenAIFunctionProperty.string(
                        name: "preparation",
                        description: "How the food was prepared",
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
