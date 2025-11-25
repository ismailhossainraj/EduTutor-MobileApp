import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _createEnrollment(String subject) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final enrollmentRef =
          FirebaseFirestore.instance.collection('enrollments').doc();
      final enrollment = {
        'uid': enrollmentRef.id,
        'studentId': user.uid,
        'teacherId': teacher.uid,
        'subject': subject,
        'status': 'interested',
        'createdAt': DateTime.now(),
      };
      await enrollmentRef.set(enrollment);
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
                ListTile(
                  title: Text(subject['subject']),
                  subtitle: Text(
                    'Class: ${subject['class_from']} - ${subject['class_to']}, Fee: ${subject['fee']}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _createEnrollment(subject['subject']);
                      _launchWhatsApp(context, teacher.phoneNumber!);
                    },
                    child: const Text('Contact'),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
