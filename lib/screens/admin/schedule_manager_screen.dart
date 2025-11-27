import 'package:flutter/material.dart';

class ScheduleManagerScreen extends StatelessWidget {
  const ScheduleManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Manager'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Schedule Manager Screen'),
      ),
    );
  }
}
