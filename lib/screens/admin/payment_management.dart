// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../models/payment_model.dart';

class PaymentManagementScreen extends StatelessWidget {
  PaymentManagementScreen({Key? key}) : super(key: key);

  final List<Payment> payments = [
    Payment(
      id: 'P001',
      studentName: 'Alice Smith',
      amount: 120.0,
      status: 'Paid',
      date: DateTime(2025, 9, 1),
    ),
    Payment(
      id: 'P002',
      studentName: 'Bob Johnson',
      amount: 150.0,
      status: 'Pending',
      date: DateTime(2025, 9, 3),
    ),
    Payment(
      id: 'P003',
      studentName: 'Carol Lee',
      amount: 100.0,
      status: 'Failed',
      date: DateTime(2025, 8, 28),
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
                      color: payment.status == 'Paid'
                          ? Colors.green
                          : payment.status == 'Pending'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    title: Text(payment.studentName),
                    subtitle: Text(
                        'Amount: \$${payment.amount.toStringAsFixed(2)}\nDate: '
                        '${payment.date.toLocal().toString().split(' ')[0]}'),
                    trailing: Text(
                      payment.status,
                      style: TextStyle(
                        color: payment.status == 'Paid'
                            ? Colors.green
                            : payment.status == 'Pending'
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
                              Text('Student: ${payment.studentName}'),
                              Text(
                                  'Amount: \$${payment.amount.toStringAsFixed(2)}'),
                              Text('Status: ${payment.status}'),
                              Text(
                                  'Date: ${payment.date.toLocal().toString().split(' ')[0]}'),
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
