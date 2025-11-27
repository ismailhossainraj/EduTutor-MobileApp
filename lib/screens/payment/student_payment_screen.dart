import 'package:flutter/material.dart';

class StudentPaymentScreen extends StatelessWidget {
  const StudentPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Student Payment Screen'),
      ),
    );
  }
}
