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

  Future<OpenAIChatCompletionModel> extractFoodsFromText(String prompt) async {
    try {
      final completion = await openAI.chat.create(
        model: 'gpt-4o-mini',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                """You are a food entity extraction system. Extract only the food items from the given text.
                       Return the response as a JSON array of strings containing only the food items.
                       Break down compound items into their main components.
                       Example: "I had a cheeseburger with french fries and a chocolate milkshake" 
                       -> ["cheeseburger", "french fries", "chocolate milkshake", "burger", "cheese"]""",
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
          ),
        ],
      );

      return completion;
    } catch (e) {
      logger.e('Error extracting food items with OpenAI: $e');
      rethrow;
    }
  }
}
