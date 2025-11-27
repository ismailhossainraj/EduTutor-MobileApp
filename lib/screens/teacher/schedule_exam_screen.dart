import 'package:flutter/material.dart';

class ScheduleExamScreen extends StatelessWidget {
  const ScheduleExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Exam'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Schedule Exam Screen'),
      ),
    );
  }
}
