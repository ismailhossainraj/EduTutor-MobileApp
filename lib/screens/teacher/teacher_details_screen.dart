import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherDetailsScreen extends StatefulWidget {
  final String teacherUid;

  const TeacherDetailsScreen({Key? key, required this.teacherUid})
      : super(key: key);

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
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

  Future<void> _createEnrollment(
      String subject, String mode, String teacherUid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final enrollmentRef =
          FirebaseFirestore.instance.collection('enrollments').doc();
      final enrollment = {
        'uid': enrollmentRef.id,
        'studentId': user.uid,
        'teacherId': teacherUid,
        'subject': subject,
        'status': 'interested',
        'mode': mode,
        'createdAt': DateTime.now(),
      };
      await enrollmentRef.set(enrollment);
    }
  }

  void _showEnrollmentDialog(
      BuildContext context, String subject, String teacherUid) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedMode;
        return AlertDialog(
          title: const Text('Request to Enroll'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Mode'),
                items: const [
                  DropdownMenuItem(value: 'Online', child: Text('Online')),
                  DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                ],
                onChanged: (String? newValue) {
                  selectedMode = newValue;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedMode != null) {
                  _createEnrollment(subject, selectedMode!, widget.teacherUid);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enrollment request sent')),
                  );
                }
              },
              child: const Text('Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProfile(Map<String, dynamic> data) async {
    final firstNameCtrl = TextEditingController(text: data['firstName'] ?? '');
    final lastNameCtrl = TextEditingController(text: data['lastName'] ?? '');
    final phoneCtrl = TextEditingController(text: data['phoneNumber'] ?? '');
    final collegeCtrl = TextEditingController(text: data['college'] ?? '');
    final universityCtrl =
        TextEditingController(text: data['university'] ?? '');
    final genderCtrl = TextEditingController(text: data['gender'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: firstNameCtrl,
                    decoration: const InputDecoration(labelText: 'First name')),
                TextField(
                    controller: lastNameCtrl,
                    decoration: const InputDecoration(labelText: 'Last name')),
                TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone')),
                TextField(
                    controller: collegeCtrl,
                    decoration: const InputDecoration(labelText: 'College')),
                TextField(
                    controller: universityCtrl,
                    decoration: const InputDecoration(labelText: 'University')),
                TextField(
                    controller: genderCtrl,
                    decoration: const InputDecoration(labelText: 'Gender')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.teacherUid)
                      .update({
                    'firstName': firstNameCtrl.text.trim(),
                    'lastName': lastNameCtrl.text.trim(),
                    'phoneNumber': phoneCtrl.text.trim(),
                    'college': collegeCtrl.text.trim(),
                    'university': universityCtrl.text.trim(),
                    'gender': genderCtrl.text.trim(),
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Update failed: ${e.toString()}')));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value.isNotEmpty ? value : '—')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.teacherUid)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final doc = snap.data!;
        if (!doc.exists) {
          return const Scaffold(body: Center(child: Text('Teacher not found')));
        }
        final data = doc.data() as Map<String, dynamic>;
        final fullName =
            '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
        final currentUid = FirebaseAuth.instance.currentUser?.uid;
        final isSelf = currentUid != null && currentUid == widget.teacherUid;

        return Scaffold(
          appBar:
              AppBar(title: Text(fullName.isNotEmpty ? fullName : 'Teacher')),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      child: Text(
                          fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(fullName.isNotEmpty ? fullName : 'Unnamed',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  _buildInfoRow('Email', data['email'] ?? ''),
                  _buildInfoRow('Phone', data['phoneNumber'] ?? ''),
                  _buildInfoRow('College', data['college'] ?? ''),
                  _buildInfoRow('University', data['university'] ?? ''),
                  _buildInfoRow('Gender', data['gender'] ?? ''),
                  _buildInfoRow('Role', data['role'] ?? ''),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isSelf)
                        ElevatedButton(
                          onPressed: () {
                            final phone =
                                (data['phoneNumber'] ?? '').toString();
                            if (phone.isNotEmpty) {
                              _launchWhatsApp(context, phone);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('No phone number available')));
                            }
                          },
                          child: const Text('Chat on WhatsApp'),
                        ),
                      if (isSelf)
                        ElevatedButton(
                          onPressed: () => _editProfile(data),
                          child: const Text('Edit Profile'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Subjects listing and enrollment request should only be visible to students viewing this teacher
                  if (!isSelf) ...[
                    Text('Subjects:',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    if (data['subjects'] != null)
                      for (final subject in (data['subjects'] as List<dynamic>))
                        ListTile(
                          title: Text(subject['subject'] ?? ''),
                          subtitle: Text(
                              'Class: ${subject['class_from'] ?? ''} - ${subject['class_to'] ?? ''}, Fee: ${subject['fee'] ?? ''}'),
                          trailing: ElevatedButton(
                            onPressed: () => _showEnrollmentDialog(context,
                                subject['subject'] ?? '', widget.teacherUid),
                            child: const Text('Request to Enroll'),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
