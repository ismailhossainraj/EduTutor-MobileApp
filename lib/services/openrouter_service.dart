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
    final response =
        await http.post(Uri.parse(endpoint), headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    } else {
      throw Exception(
          'OpenRouter error: ${response.statusCode} ${response.body}');
    }
  }
}
