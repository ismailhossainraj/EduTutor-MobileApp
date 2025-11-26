import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, teacher, student }

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final UserRole role;
  final DateTime createdAt;

  // Student specific fields
  final String? schoolName;
  final String? classLevel;

  // Teacher specific fields
  final String? college;
  final String? educationLevel;
  final String? university;
  final String? interest;
  final String? phoneNumber;
  final List<Map<String, dynamic>>? subjects;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    required this.role,
    required this.createdAt,
    // Student fields
    this.schoolName,
    this.classLevel,
    // Teacher fields
    this.college,
    this.educationLevel,
    this.university,
    this.interest,
    this.phoneNumber,
    this.subjects,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'role': role.name,
      'createdAt': createdAt,
      // Student fields
      'schoolName': schoolName,
      'classLevel': classLevel,
      // Teacher fields
      'college': college,
      'educationLevel': educationLevel,
      'university': university,
      'interest': interest,
      'phoneNumber': phoneNumber,
      'subjects': subjects,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      gender: map['gender'],
      role: _roleFromString(map['role']),
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                  DateTime.now(),
      // Student fields
      schoolName: map['schoolName'],
      classLevel: map['classLevel'],
      // Teacher fields
      college: map['college'],
      educationLevel: map['educationLevel'],
      university: map['university'],
      interest: map['interest'],
      phoneNumber: map['phoneNumber'],
      subjects: map['subjects'] != null
          ? List<Map<String, dynamic>>.from(map['subjects'])
          : null,
    );
  }

  static UserRole _roleFromString(dynamic role) {
    if (role is UserRole) return role;
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'teacher':
          return UserRole.teacher;
        case 'student':
          return UserRole.student;
      }
    }
    return UserRole.student;
  }
}
