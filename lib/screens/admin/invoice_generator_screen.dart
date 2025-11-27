import 'package:flutter/material.dart';

class InvoiceGeneratorScreen extends StatelessWidget {
  const InvoiceGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Generator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Invoice Generator Screen'),
      ),
    );
  }
}
