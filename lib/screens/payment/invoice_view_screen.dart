import 'package:flutter/material.dart';

class InvoiceViewScreen extends StatelessWidget {
  const InvoiceViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Invoice View Screen'),
      ),
    );
  }
}
