// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../models/payment_model.dart';

class PaymentManagementScreen extends StatelessWidget {
  PaymentManagementScreen({Key? key}) : super(key: key);

  final List<Payment> payments = [
    Payment(
      id: 'P001',
      studentId: 'S001',
      amount: 120.0,
      paymentDate: DateTime(2025, 9, 1),
      status: 'completed',
      paymentMethod: 'card',
      transactionId: 'TXN001',
      createdAt: DateTime(2025, 9, 1),
    ),
    Payment(
      id: 'P002',
      studentId: 'S002',
      amount: 150.0,
      paymentDate: DateTime(2025, 9, 3),
      status: 'pending',
      paymentMethod: 'bank_transfer',
      transactionId: 'TXN002',
      createdAt: DateTime(2025, 9, 3),
    ),
    Payment(
      id: 'P003',
      studentId: 'S003',
      amount: 100.0,
      paymentDate: DateTime(2025, 8, 28),
      status: 'failed',
      paymentMethod: 'wallet',
      transactionId: 'TXN003',
      createdAt: DateTime(2025, 8, 28),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: payments.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return ListTile(
                    leading: Icon(
                      Icons.payment,
                      color: payment.status == 'completed'
                          ? Colors.green
                          : payment.status == 'pending'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    title: Text(payment.studentId),
                    subtitle: Text(
                        'Amount: \$${payment.amount.toStringAsFixed(2)}\nDate: '
                        '${payment.paymentDate.toLocal().toString().split(' ')[0]}'),
                    trailing: Text(
                      payment.status,
                      style: TextStyle(
                        color: payment.status == 'completed'
                            ? Colors.green
                            : payment.status == 'pending'
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Payment Details'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${payment.id}'),
                              Text('Student: ${payment.studentId}'),
                              Text(
                                  'Amount: \$${payment.amount.toStringAsFixed(2)}'),
                              Text('Status: ${payment.status}'),
                              Text(
                                  'Date: ${payment.paymentDate.toLocal().toString().split(' ')[0]}'),
                              const SizedBox(height: 8),
                              Text('Payment Method:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet,
                                      color: Colors.purple, size: 20),
                                  SizedBox(width: 6),
                                  Text('bKash'),
                                  SizedBox(width: 16),
                                  Icon(Icons.account_balance_wallet,
                                      color: Colors.red, size: 20),
                                  SizedBox(width: 6),
                                  Text('Nagad'),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
