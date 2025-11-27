import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum PaymentMethod { bkash, nagad, rocket }

class StudentPaymentScreen extends StatefulWidget {
  const StudentPaymentScreen({Key? key}) : super(key: key);

  @override
  State<StudentPaymentScreen> createState() => _StudentPaymentScreenState();
}

class _StudentPaymentScreenState extends State<StudentPaymentScreen> {
  PaymentMethod? _selectedMethod;
  final TextEditingController _amountController = TextEditingController();

  /// 🔥 FIXED: Map made final (the recommended change)
  final Map<PaymentMethod, String?> _adminNumbers = {};

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAdminNumbers();
  }

  /// Load admin payment numbers (bKash, Nagad, Rocket)
  Future<void> _loadAdminNumbers() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('settings')
          .doc('paymentMethods');
      final doc = await docRef.get();

      const defaults = {
        'bkash': '0123645475',
        'nagad': '01236545',
        'rocket': '012457896',
      };

      final data = doc.exists
          ? (doc.data() ?? <String, dynamic>{})
          : <String, dynamic>{};

      // Use existing values when present, otherwise use defaults
      final merged = <String, dynamic>{
        'bkash': data['bkash'] ?? defaults['bkash'],
        'nagad': data['nagad'] ?? defaults['nagad'],
        'rocket': data['rocket'] ?? defaults['rocket'],
      };

      // Ensure Firestore contains these values (merge true to avoid overwriting other settings)
      await docRef.set(merged, SetOptions(merge: true));

      setState(() {
        _adminNumbers[PaymentMethod.bkash] = merged['bkash'] as String?;
        _adminNumbers[PaymentMethod.nagad] = merged['nagad'] as String?;
        _adminNumbers[PaymentMethod.rocket] = merged['rocket'] as String?;
      });
    } catch (e) {
      // ignore errors quietly
    }
  }

  /// Handle payment action
  Future<void> _pay() async {
    final amountText = _amountController.text.trim();

    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKey(_selectedMethod!);
    String? storedNumber = prefs.getString(key);

    final adminNumber = _adminNumbers[_selectedMethod!];

    final payerNumber = await _promptForNumber(prefill: storedNumber);
    if (payerNumber == null || payerNumber.isEmpty) return;

    await prefs.setString(key, payerNumber);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final field = _firestoreField(_selectedMethod!);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({field: payerNumber}, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('admin_payments').add({
        'studentUid': user.uid,
        'studentEmail': user.email,
        'method': _methodLabel(_selectedMethod!),
        'amount': double.tryParse(amountText) ?? 0.0,
        'payerNumber': payerNumber,
        'adminNumber': adminNumber ?? '',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          adminNumber != null
              ? 'Pay ৳$amountText to ${_methodLabel(_selectedMethod!)} number $adminNumber. Your payer number $payerNumber was recorded.'
              : 'Admin number not available. Your payer number $payerNumber was recorded.',
        ),
      ),
    );
  }

  /// Preference key
  String _prefsKey(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bkash:
        return 'payment_bkash_number';
      case PaymentMethod.nagad:
        return 'payment_nagad_number';
      case PaymentMethod.rocket:
        return 'payment_rocket_number';
    }
  }

  /// Method label
  String _methodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bkash:
        return 'bKash';
      case PaymentMethod.nagad:
        return 'Nagad';
      case PaymentMethod.rocket:
        return 'Rocket';
    }
  }

  /// Firestore field mapping
  String _firestoreField(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bkash:
        return 'paymentMethods.bkash';
      case PaymentMethod.nagad:
        return 'paymentMethods.nagad';
      case PaymentMethod.rocket:
        return 'paymentMethods.rocket';
    }
  }

  /// Popup to ask student for their payment number
  Future<String?> _promptForNumber({String? prefill}) async {
    final controller = TextEditingController(text: prefill ?? '');

    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter payment number'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'e.g. 01XXXXXXXXX'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result;
  }

  /// UI
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Make Payment',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),

            // Amount input
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '৳ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // PAYMENT METHOD OPTIONS
            ...[PaymentMethod.bkash, PaymentMethod.nagad, PaymentMethod.rocket]
                .map((method) {
              return ListTile(
                leading: Radio<PaymentMethod>(
                  value: method,
                  // ignore: deprecated_member_use
                  groupValue: _selectedMethod,
                  // ignore: deprecated_member_use
                  onChanged: (value) => setState(() => _selectedMethod = value),
                ),
                title: Text(_methodLabel(method)),
                subtitle: Text(
                  _adminNumbers[method] ?? '017777777777',
                ),
                trailing: const Icon(Icons.payment),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pay,
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
