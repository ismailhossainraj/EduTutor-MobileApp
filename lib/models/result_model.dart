class Result {
  final String id;
  final String studentId;
  final String classId;
  final String examId;
  final String subjectId;
  final double marksObtained;
  final double totalMarks;
  final String grade; // A, B, C, D, F
  final String remarks;
  final DateTime resultDate;
  final String examType; // midterm, final, unit_test, quiz
  final DateTime publishedDate;
  final bool isPublished;

  Result({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.examId,
    required this.subjectId,
    required this.marksObtained,
    required this.totalMarks,
    required this.grade,
    required this.remarks,
    required this.resultDate,
    required this.examType,
    required this.publishedDate,
    required this.isPublished,
  });

  // Calculate percentage
  double getPercentage() {
    if (totalMarks == 0) return 0;
    return (marksObtained / totalMarks) * 100;
  }

  // Get grade color for UI
  String getGradeColor() {
    switch (grade) {
      case 'A':
        return '#4CAF50'; // Green
      case 'B':
        return '#8BC34A'; // Light Green
      case 'C':
        return '#FFC107'; // Amber
      case 'D':
        return '#FF9800'; // Orange
      case 'F':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'examId': examId,
      'subjectId': subjectId,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
      'grade': grade,
      'remarks': remarks,
      'resultDate': resultDate,
      'examType': examType,
      'publishedDate': publishedDate,
      'isPublished': isPublished,
    };
  }

  // Create from Firestore Map
  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      classId: map['classId'] ?? '',
      examId: map['examId'] ?? '',
      subjectId: map['subjectId'] ?? '',
      marksObtained: (map['marksObtained'] ?? 0).toDouble(),
      totalMarks: (map['totalMarks'] ?? 0).toDouble(),
      grade: map['grade'] ?? 'N/A',
      remarks: map['remarks'] ?? '',
      resultDate: (map['resultDate'] as dynamic)?.toDate() ?? DateTime.now(),
      examType: map['examType'] ?? 'quiz',
      publishedDate:
          (map['publishedDate'] as dynamic)?.toDate() ?? DateTime.now(),
      isPublished: map['isPublished'] ?? false,
    );
  }

  // Copy with method
  Result copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? examId,
    String? subjectId,
    double? marksObtained,
    double? totalMarks,
    String? grade,
    String? remarks,
    DateTime? resultDate,
    String? examType,
    DateTime? publishedDate,
    bool? isPublished,
  }) {
    return Result(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      examId: examId ?? this.examId,
      subjectId: subjectId ?? this.subjectId,
      marksObtained: marksObtained ?? this.marksObtained,
      totalMarks: totalMarks ?? this.totalMarks,
      grade: grade ?? this.grade,
      remarks: remarks ?? this.remarks,
      resultDate: resultDate ?? this.resultDate,
      examType: examType ?? this.examType,
      publishedDate: publishedDate ?? this.publishedDate,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
