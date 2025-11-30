import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple AI service that calls a server-side proxy.
/// Configure `AI_PROXY_URL` at compile time using `--dart-define` or
/// replace the fallback below with your deployed endpoint.
class AiService {
  // Fallback placeholder; set a real URL via `--dart-define=AI_PROXY_URL="https://..."`
  static const String _fallbackProxy =
      'https://YOUR_AI_PROXY_ENDPOINT.example.com/ai';

  // Use a dart-define so the URL is not hard-coded in VCS for production keys.
  static const String aiProxyUrl = String.fromEnvironment(
    'AI_PROXY_URL',
    defaultValue: _fallbackProxy,
  );

  /// Sends a prompt to the server proxy and returns the AI response string.
  /// Optionally pass an [idToken] (Firebase ID token) to the proxy so it can
  /// authenticate the caller. The proxy should verify the token server-side.
  ///
  /// Throws a descriptive Exception when the proxy URL is not configured or
  /// when the network/proxy returns an error.
  Future<String> sendPrompt(String prompt,
      {String? uid, String? idToken}) async {
    if (aiProxyUrl.contains('YOUR_AI_PROXY_ENDPOINT')) {
      // Provide a non-throwing demo fallback so the UI remains usable during
      // local testing. This returns a harmless simulated response and an
      // instruction so testers can enable a real proxy when ready.
      const demo =
          'Demo reply — AI proxy is not configured.\nTo enable real AI, deploy the proxy and run the app with:\nflutter run --dart-define=AI_PROXY_URL="https://<your-url>/ai"';
      return Future.value('Demo: $demo\n\nYou asked: $prompt');
    }

    final uri = Uri.parse(aiProxyUrl);
    final body = jsonEncode({
      'prompt': prompt,
      if (uid != null) 'uid': uid,
    });

    final headers = <String, String>{'Content-Type': 'application/json'};
    if (idToken != null && idToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $idToken';
    }

    http.Response resp;
    try {
      resp = await http.post(uri, headers: headers, body: body).timeout(
            const Duration(seconds: 30),
          );
    } catch (e) {
      throw Exception(
          'Failed to contact AI proxy at $aiProxyUrl. Ensure the proxy is deployed and reachable. Error: ${e.toString()}');
    }

    if (resp.statusCode != 200) {
      throw Exception('AI proxy error: ${resp.statusCode} ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return (data['response'] ?? '').toString();
  }
}
