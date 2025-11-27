import 'package:flutter/material.dart';

class ViewResultsScreen extends StatelessWidget {
  const ViewResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('View Results Screen'),
      ),
    );
  }
}
