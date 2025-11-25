import 'package:cloud_firestore/cloud_firestore.dart';

class StudentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getStudentsForTeacher(
      String teacherId) async {
    final query = await _firestore
        .collection('students')
        .where('teacherId', isEqualTo: teacherId)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  static Future<int> getStudentCount() async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'student')
        .get();
    return query.docs.length;
  }
}
