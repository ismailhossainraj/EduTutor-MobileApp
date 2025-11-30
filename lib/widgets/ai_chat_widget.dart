import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/ai_service.dart';

class AiChatWidget extends StatefulWidget {
  const AiChatWidget({Key? key}) : super(key: key);

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final AiService _ai = AiService();
  final TextEditingController _ctrl = TextEditingController();
  final List<_Message> _messages = [];
  bool _loading = false;

  Future<void> _send() async {
    final prompt = _ctrl.text.trim();
    if (prompt.isEmpty) return;
    setState(() {
      _messages.add(_Message(text: prompt, sender: Sender.user));
      _loading = true;
      _ctrl.clear();
    });
    try {
      // Try to attach the current Firebase ID token, if available.
      String? idToken;
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          idToken = await user.getIdToken();
        }
      } catch (_) {
        // ignore token errors; continue without token
      }

      final resp = await _ai.sendPrompt(prompt, idToken: idToken);
      setState(() {
        _messages.add(_Message(text: resp, sender: Sender.ai));
      });
    } catch (e) {
      setState(() {
        _messages.add(_Message(
            text: 'Error calling AI: ${e.toString()}', sender: Sender.ai));
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final m = _messages[i];
                  final align = m.sender == Sender.user
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start;
                  final color = m.sender == Sender.user
                      ? Colors.blue[100]
                      : Colors.grey[200];
                  return Column(
                    crossAxisAlignment: align,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(m.text),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (_loading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                          hintText: 'Ask the assistant...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _send,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Sender { user, ai }

class _Message {
  final String text;
  final Sender sender;
  _Message({required this.text, required this.sender});
}
