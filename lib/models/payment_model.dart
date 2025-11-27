class Payment {
  final String id;
  final String studentId;
  final double amount;
  final DateTime paymentDate;
  final String status; // pending, completed, failed
  final String paymentMethod; // card, bank_transfer, wallet
  final String transactionId;
  final DateTime createdAt;
  final String? notes;
  final String? receiptUrl;

  Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.createdAt,
    this.notes,
    this.receiptUrl,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'amount': amount,
      'paymentDate': paymentDate,
      'status': status,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'createdAt': createdAt,
      'notes': notes,
      'receiptUrl': receiptUrl,
    };
  }

  // Create from Firestore Map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentDate: (map['paymentDate'] as dynamic)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? '',
      transactionId: map['transactionId'] ?? '',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
      receiptUrl: map['receiptUrl'],
    );
  }

  // Copy with method
  Payment copyWith({
    String? id,
    String? studentId,
    double? amount,
    DateTime? paymentDate,
    String? status,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    String? notes,
    String? receiptUrl,
  }) {
    return Payment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }
}
