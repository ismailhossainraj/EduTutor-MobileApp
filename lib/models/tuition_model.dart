import 'package:cloud_firestore/cloud_firestore.dart';

class TuitionModel {
  final String uid;
  final String teacherId;
  final String name;
  final String email;
  final String phone;
  final String qualification;
  final String interestedSubject;
  final List<String> days; // e.g., ['Mon','Wed']
  final String startTime;
  final String endTime;
  final String salary;
  final String status; // open, selected, closed
  final DateTime createdAt;

  TuitionModel({
    required this.uid,
    required this.teacherId,
    required this.name,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.interestedSubject,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.salary,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'teacherId': teacherId,
      'name': name,
      'email': email,
      'phone': phone,
      'qualification': qualification,
      'interestedSubject': interestedSubject,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
      'salary': salary,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory TuitionModel.fromMap(Map<String, dynamic> map) {
    return TuitionModel(
      uid: map['uid'] ?? '',
      teacherId: map['teacherId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      qualification: map['qualification'] ?? '',
      interestedSubject: map['interestedSubject'] ?? '',
      days: map['days'] != null ? List<String>.from(map['days']) : <String>[],
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      salary: map['salary'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
}
