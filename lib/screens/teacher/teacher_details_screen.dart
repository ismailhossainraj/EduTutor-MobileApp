import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final UserModel teacher;

  const TeacherDetailsScreen({Key? key, required this.teacher})
      : super(key: key);

  void _launchWhatsApp(BuildContext context, String phoneNumber) async {
    final url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teacher.fullName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subjects:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            if (teacher.subjects != null)
              for (final subject in teacher.subjects!)
                Text(
                  '${subject['subject']} (Class ${subject['class_from']} - ${subject['class_to']}) - Fee: ${subject['fee']}',
                ),
            const SizedBox(height: 20),
            if (teacher.phoneNumber != null)
              ElevatedButton(
                onPressed: () {
                  _launchWhatsApp(context, teacher.phoneNumber!);
                },
                child: const Text('Chat on WhatsApp'),
              ),
          ],
        ),
      ),
    );
  }
}
