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
