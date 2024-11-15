// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true, obfuscate: true)
final class Env {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static String openaiApiKey = _Env.openaiApiKey; // Transformed to 'OPENAI_API_KEY'

  @EnviedField(varName: 'USDA_FOOD_API_KEY')
  static String usdaFoodApiKey = _Env.usdaFoodApiKey; // Transformed to 'USDA_FOOD_API_KEY'
}
