import 'package:flutter/material.dart';

class UploadMaterialScreen extends StatelessWidget {
  const UploadMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Material'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Upload Material Screen'),
      ),
    );
  }
}
