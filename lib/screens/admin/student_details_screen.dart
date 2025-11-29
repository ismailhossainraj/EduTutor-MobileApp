import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class StudentDetailsScreen extends StatelessWidget {
  final UserModel student;

  const StudentDetailsScreen({Key? key, required this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full name: ${student.fullName}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Email: ${student.email}'),
            const SizedBox(height: 8),
            if (student.classLevel != null && student.classLevel!.isNotEmpty)
              Text('Class: ${student.classLevel}'),
          ],
        ),
      ),
    );
  }
}
