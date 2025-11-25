import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  final String uid;
  final String studentId;
  final String teacherId;
  final String subject;
  final String status;
  final DateTime createdAt;

  EnrollmentModel({
    required this.uid,
    required this.studentId,
    required this.teacherId,
    required this.subject,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'studentId': studentId,
      'teacherId': teacherId,
      'subject': subject,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory EnrollmentModel.fromMap(Map<String, dynamic> map) {
    return EnrollmentModel(
      uid: map['uid'] ?? '',
      studentId: map['studentId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      subject: map['subject'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
}
