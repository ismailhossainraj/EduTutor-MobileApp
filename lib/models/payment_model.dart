class Payment {
  final String id;
  final String studentName;
  final double amount;
  final String status;
  final DateTime date;

  Payment({
    required this.id,
    required this.studentName,
    required this.amount,
    required this.status,
    required this.date,
  });
}
