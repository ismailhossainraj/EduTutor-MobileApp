class Exam {
  final String id;
  final String classId;
  final String teacherId;
  final String subject;
  final DateTime scheduledDate;
  final DateTime endTime;
  final String examType; // midterm, final, unit_test, quiz
  final String description;
  final String status; // scheduled, in_progress, completed, cancelled
  final int totalQuestions;
  final double totalMarks;
  final DateTime createdAt;
  final String? instructions;

  Exam({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.subject,
    required this.scheduledDate,
    required this.endTime,
    required this.examType,
    required this.description,
    required this.status,
    required this.totalQuestions,
    required this.totalMarks,
    required this.createdAt,
    this.instructions,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'teacherId': teacherId,
      'subject': subject,
      'scheduledDate': scheduledDate,
      'endTime': endTime,
      'examType': examType,
      'description': description,
      'status': status,
      'totalQuestions': totalQuestions,
      'totalMarks': totalMarks,
      'createdAt': createdAt,
      'instructions': instructions,
    };
  }

  // Create from Firestore Map
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'] ?? '',
      classId: map['classId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      subject: map['subject'] ?? '',
      scheduledDate:
          (map['scheduledDate'] as dynamic)?.toDate() ?? DateTime.now(),
      endTime: (map['endTime'] as dynamic)?.toDate() ?? DateTime.now(),
      examType: map['examType'] ?? 'quiz',
      description: map['description'] ?? '',
      status: map['status'] ?? 'scheduled',
      totalQuestions: map['totalQuestions'] ?? 0,
      totalMarks: (map['totalMarks'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      instructions: map['instructions'],
    );
  }

  // Copy with method
  Exam copyWith({
    String? id,
    String? classId,
    String? teacherId,
    String? subject,
    DateTime? scheduledDate,
    DateTime? endTime,
    String? examType,
    String? description,
    String? status,
    int? totalQuestions,
    double? totalMarks,
    DateTime? createdAt,
    String? instructions,
  }) {
    return Exam(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      subject: subject ?? this.subject,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      endTime: endTime ?? this.endTime,
      examType: examType ?? this.examType,
      description: description ?? this.description,
      status: status ?? this.status,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalMarks: totalMarks ?? this.totalMarks,
      createdAt: createdAt ?? this.createdAt,
      instructions: instructions ?? this.instructions,
    );
  }

  // Check if exam is upcoming
  bool isUpcoming() {
    return DateTime.now().isBefore(scheduledDate) && status != 'cancelled';
  }

  // Check if exam is ongoing
  bool isOngoing() {
    return DateTime.now().isAfter(scheduledDate) &&
        DateTime.now().isBefore(endTime);
  }

  // Get duration in minutes
  int getDurationInMinutes() {
    return endTime.difference(scheduledDate).inMinutes;
  }
}
