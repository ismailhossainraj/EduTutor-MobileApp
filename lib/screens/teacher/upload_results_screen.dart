import 'package:flutter/material.dart';

class UploadResultsScreen extends StatelessWidget {
  const UploadResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Upload Results Screen'),
      ),
    );
  }
}
