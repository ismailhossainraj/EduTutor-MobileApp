import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageTuitionScreen extends StatelessWidget {
  const ManageTuitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tuition')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student Requests',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                // Query student requests: include open and selected so admin
                // can see which requests were selected and by whom.
                stream: FirebaseFirestore.instance
                    .collection('tuitions')
                    .where('status', whereIn: ['open', 'selected']).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final raw = snap.data!.docs;
                  final docs = raw.where((d) {
                    final t = d.data() as Map<String, dynamic>;
                    final posterRole =
                        (t['posterRole'] ?? '').toString().toLowerCase();
                    final teacherId = (t['teacherId'] ?? '').toString();
                    return posterRole == 'student' ||
                        (posterRole.isEmpty && teacherId.isEmpty);
                  }).toList();
                  if (docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No open student requests'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final d = docs[index];
                      final t = d.data() as Map<String, dynamic>;
                      final posterId = t['posterId'] ?? '';
                      final tuitionId = t['uid'] ?? d.id;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(posterId)
                            .get(),
                        builder: (context, userSnap) {
                          final studentName = (userSnap.hasData &&
                                  userSnap.data!.exists)
                              ? '${(userSnap.data!.data() as Map<String, dynamic>)['firstName'] ?? ''} ${(userSnap.data!.data() as Map<String, dynamic>)['lastName'] ?? ''}'
                                  .trim()
                              : posterId;

                          // If this tuition is selected, fetch the selection doc to show teacher name
                          if ((t['status'] ?? '').toString() == 'selected') {
                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('tuition_selections')
                                  .where('tuitionId', isEqualTo: tuitionId)
                                  .limit(1)
                                  .get(),
                              builder: (context, selSnap) {
                                String teacherLabel = 'Selected';
                                if (selSnap.hasData &&
                                    selSnap.data!.docs.isNotEmpty) {
                                  final s = selSnap.data!.docs.first.data()
                                      as Map<String, dynamic>;
                                  final selTeacherName =
                                      (s['teacherName'] ?? '').toString();
                                  final selTeacherId =
                                      (s['teacherId'] ?? '').toString();
                                  teacherLabel = selTeacherName.isNotEmpty
                                      ? 'Selected by: $selTeacherName'
                                      : 'Selected by: $selTeacherId';
                                }
                                return ListTile(
                                  title:
                                      Text(t['interestedSubject'] ?? 'Tuition'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Student: $studentName'),
                                      if (t['days'] != null)
                                        Text(
                                            'Days: ${List<String>.from(t['days']).join(', ')}'),
                                      if (t['startTime'] != null)
                                        Text(
                                            'Time: ${t['startTime']} - ${t['endTime'] ?? ''}'),
                                      Text(teacherLabel),
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          // Not selected: show student info only
                          return ListTile(
                            title: Text(t['interestedSubject'] ?? 'Tuition'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Student: $studentName'),
                                if (t['days'] != null)
                                  Text(
                                      'Days: ${List<String>.from(t['days']).join(', ')}'),
                                if (t['startTime'] != null)
                                  Text(
                                      'Time: ${t['startTime']} - ${t['endTime'] ?? ''}'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const Divider(height: 24),
              Text('Teacher Requests',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tuition_selections')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final sels = snapshot.data!.docs;
                  if (sels.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No tuition selections'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sels.length,
                    itemBuilder: (context, index) {
                      final s = sels[index].data() as Map<String, dynamic>;
                      final tuitionId = s['tuitionId'] ?? '';
                      final studentId = s['studentId'] ?? '';
                      final teacherId = s['teacherId'] ?? '';

                      // Prefer names stored on the selection doc (teacherName/studentName)
                      final selStudentName =
                          (s['studentName'] ?? '').toString();
                      final selTeacherName =
                          (s['teacherName'] ?? '').toString();

                      if (selStudentName.isNotEmpty &&
                          selTeacherName.isNotEmpty) {
                        // Minimal fetch: get tuition for subject/title
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tuitions')
                              .doc(tuitionId)
                              .get(),
                          builder: (context, snap) {
                            if (!snap.hasData)
                              // ignore: curly_braces_in_flow_control_structures
                              return const ListTile(title: Text('Loading...'));
                            final tuitionDoc = snap.data!;
                            final tuition = tuitionDoc.exists
                                ? tuitionDoc.data() as Map<String, dynamic>
                                : null;
                            return ListTile(
                              title: Text(tuition != null
                                  ? (tuition['interestedSubject'] ?? 'Tuition')
                                  : 'Tuition'),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Teacher: $selTeacherName'),
                                    Text('Student: $selStudentName'),
                                  ]),
                            );
                          },
                        );
                      }

                      // Fallback: fetch tuition, student and teacher docs
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
            ],
          ),
        ),
      ),
    );
  }
}
