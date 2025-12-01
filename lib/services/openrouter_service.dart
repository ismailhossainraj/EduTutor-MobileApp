import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  final String apiKey;
  final String endpoint;

  OpenRouterService(
      {required this.apiKey,
      this.endpoint = 'https://openrouter.ai/api/v1/chat/completions'});

  Future<String> sendMessage(String message, {String? systemPrompt}) async {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'model': 'openrouter/auto',
      'messages': [
        if (systemPrompt != null) {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': message},
      ],
    });
    http.Response response;
    try {
      response =
          await http.post(Uri.parse(endpoint), headers: headers, body: body);
    } catch (e) {
      throw Exception('Network error calling OpenRouter: ${e.toString()}');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'OpenRouter error: ${response.statusCode} ${response.body}');
    }

    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception('OpenRouter returned invalid JSON: ${e.toString()}');
    }

    // Try several common response shapes to extract assistant text.
    // 1) choices[0].message.content (Chat-style)
    try {
      final choices = data['choices'];
      if (choices is List && choices.isNotEmpty) {
        final first = choices[0];
        if (first is Map) {
          final message = first['message'];
          if (message is Map && message['content'] != null) {
            return message['content'].toString();
          }
          // fallback: some implementations put text in 'text' or 'content'
          if (first['text'] != null) return first['text'].toString();
          if (first['content'] != null) return first['content'].toString();
        }
      }
    } catch (_) {}

    // 2) top-level 'output' or 'response' fields
    if (data is Map) {
      if (data['output'] != null) return data['output'].toString();
      if (data['response'] != null) return data['response'].toString();
    }

    // 3) as a last resort, return the raw body
    return response.body;
  }
}
