class Invoice {
  final String id;
  final String studentId;
  final String invoiceNumber;
  final DateTime generatedDate;
  final DateTime dueDate;
  final double monthlyFee;
  final double totalDue;
  final double amountPaid;
  final double balanceDue;
  final String status; // unpaid, paid, overdue, partial
  final DateTime? paidDate;
  final List<String> paymentIds;

  Invoice({
    required this.id,
    required this.studentId,
    required this.invoiceNumber,
    required this.generatedDate,
    required this.dueDate,
    required this.monthlyFee,
    required this.totalDue,
    required this.amountPaid,
    required this.balanceDue,
    required this.status,
    this.paidDate,
    required this.paymentIds,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'invoiceNumber': invoiceNumber,
      'generatedDate': generatedDate,
      'dueDate': dueDate,
      'monthlyFee': monthlyFee,
      'totalDue': totalDue,
      'amountPaid': amountPaid,
      'balanceDue': balanceDue,
      'status': status,
      'paidDate': paidDate,
      'paymentIds': paymentIds,
    };
  }

  // Create from Firestore Map
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      generatedDate:
          (map['generatedDate'] as dynamic)?.toDate() ?? DateTime.now(),
      dueDate: (map['dueDate'] as dynamic)?.toDate() ?? DateTime.now(),
      monthlyFee: (map['monthlyFee'] ?? 0).toDouble(),
      totalDue: (map['totalDue'] ?? 0).toDouble(),
      amountPaid: (map['amountPaid'] ?? 0).toDouble(),
      balanceDue: (map['balanceDue'] ?? 0).toDouble(),
      status: map['status'] ?? 'unpaid',
      paidDate: (map['paidDate'] as dynamic)?.toDate(),
      paymentIds: List<String>.from(map['paymentIds'] ?? []),
    );
  }

  // Copy with method
  Invoice copyWith({
    String? id,
    String? studentId,
    String? invoiceNumber,
    DateTime? generatedDate,
    DateTime? dueDate,
    double? monthlyFee,
    double? totalDue,
    double? amountPaid,
    double? balanceDue,
    String? status,
    DateTime? paidDate,
    List<String>? paymentIds,
  }) {
    return Invoice(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      generatedDate: generatedDate ?? this.generatedDate,
      dueDate: dueDate ?? this.dueDate,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      totalDue: totalDue ?? this.totalDue,
      amountPaid: amountPaid ?? this.amountPaid,
      balanceDue: balanceDue ?? this.balanceDue,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
      paymentIds: paymentIds ?? this.paymentIds,
    );
  }

  // Calculate penalty if overdue
  double calculatePenalty({double penaltyPercentage = 0.05}) {
    if (status == 'overdue' && balanceDue > 0) {
      return balanceDue * penaltyPercentage;
    }
    return 0;
  }

  // Check if invoice is overdue
  bool isOverdue() {
    return DateTime.now().isAfter(dueDate) && status != 'paid';
  }
}
