import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageTuitionScreen extends StatelessWidget {
  const ManageTuitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tuition')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tuition_selections')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final sels = snapshot.data!.docs;
          if (sels.isEmpty) {
            return const Center(child: Text('No tuition selections'));
          }
          return ListView.builder(
            itemCount: sels.length,
            itemBuilder: (context, index) {
              final s = sels[index].data() as Map<String, dynamic>;
              final tuitionId = s['tuitionId'] ?? '';
              final studentId = s['studentId'] ?? '';
              final teacherId = s['teacherId'] ?? '';
              return FutureBuilder<List<DocumentSnapshot>>(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('tuitions')
                      .doc(tuitionId)
                      .get(),
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(studentId)
                      .get(),
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(teacherId)
                      .get(),
                ]),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  final tuitionDoc = snap.data![0];
                  final studentDoc = snap.data![1];
                  final teacherDoc = snap.data![2];
                  final tuition = tuitionDoc.exists
                      ? tuitionDoc.data() as Map<String, dynamic>
                      : null;
                  final student = studentDoc.exists
                      ? studentDoc.data() as Map<String, dynamic>
                      : null;
                  final teacher = teacherDoc.exists
                      ? teacherDoc.data() as Map<String, dynamic>
                      : null;
                  return ListTile(
                    title: Text(tuition != null
                        ? (tuition['interestedSubject'] ?? 'Tuition')
                        : 'Tuition'),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Teacher: ${teacher != null ? '${teacher['firstName'] ?? ''} ${teacher['lastName'] ?? ''}' : teacherId}'),
                          Text(
                              'Student: ${student != null ? '${student['firstName'] ?? ''} ${student['lastName'] ?? ''}' : studentId}'),
                        ]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
