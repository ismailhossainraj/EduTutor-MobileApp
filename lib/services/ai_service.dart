import 'openrouter_service.dart';

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
