import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherProfileSetupScreen extends StatefulWidget {
  const TeacherProfileSetupScreen({Key? key}) : super(key: key);

  @override
  TeacherProfileSetupScreenState createState() =>
      TeacherProfileSetupScreenState();
}

class TeacherProfileSetupScreenState extends State<TeacherProfileSetupScreen> {
  final List<String> _subjects = [
    'Math',
    'English',
    'Physics',
    'Chemistry',
    'Higher Math',
    'Biology'
  ];

  final List<Map<String, dynamic>> _teacherSubjects = [];

  void _addSubject() {
    String? selectedSubject;
    final classFromController = TextEditingController();
    final classToController = TextEditingController();
    final feeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Subject'),
                items: _subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedSubject = newValue;
                },
              ),
              TextField(
                controller: classFromController,
                decoration: const InputDecoration(labelText: 'Class From'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: classToController,
                decoration: const InputDecoration(labelText: 'Class To'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: feeController,
                decoration: const InputDecoration(labelText: 'Estimated Fee'),
                keyboardType: TextInputType.number,
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
                if (selectedSubject != null &&
                    classFromController.text.isNotEmpty &&
                    classToController.text.isNotEmpty &&
                    feeController.text.isNotEmpty) {
                  setState(() {
                    _teacherSubjects.add({
                      'subject': selectedSubject,
                      'class_from': int.tryParse(classFromController.text) ?? 0,
                      'class_to': int.tryParse(classToController.text) ?? 0,
                      'fee': int.tryParse(feeController.text) ?? 0,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final searchableSubjects =
          _teacherSubjects.map((s) => s['subject'] as String).toList();
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'subjects': _teacherSubjects,
        'searchableSubjects': searchableSubjects,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _teacherSubjects.length,
                itemBuilder: (context, index) {
                  final subject = _teacherSubjects[index];
                  return ListTile(
                    title: Text(subject['subject']),
                    subtitle: Text(
                      'Class: ${subject['class_from']} - ${subject['class_to']}, Fee: ${subject['fee']}',
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addSubject,
              child: const Text('Add Subject'),
            ),
          ],
        ),
      ),
    );
  }
}
