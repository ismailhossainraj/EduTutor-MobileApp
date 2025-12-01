import 'package:edututormobile/services/openrouter_service.dart';

class AiService {
  // OpenRouter API key is set below
  static const String _apiKey =
      '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';
  final OpenRouterService _openRouter = OpenRouterService(apiKey: _apiKey);

  Future<String> sendPrompt(String prompt, {String? idToken}) async {
    // Optionally, you can use idToken for user context or pass as systemPrompt
    return await _openRouter.sendMessage(prompt);
  }
}
