import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchTuitionScreen extends StatefulWidget {
  const SearchTuitionScreen({Key? key}) : super(key: key);

  @override
  State<SearchTuitionScreen> createState() => _SearchTuitionScreenState();
}

class _SearchTuitionScreenState extends State<SearchTuitionScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Search Tuition')),
      body: StreamBuilder<QuerySnapshot>(
        // Query by status and apply client-side filter for student posts
        stream: FirebaseFirestore.instance
            .collection('tuitions')
            .where('status', whereIn: ['open', 'selected']).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rawDocs = snapshot.data!.docs;
          final docs = rawDocs.where((d) {
            final t = d.data() as Map<String, dynamic>;
            final posterRole = (t['posterRole'] ?? '').toString().toLowerCase();
            final teacherId = (t['teacherId'] ?? '').toString();
            final isStudentRole = posterRole == 'student';
            final legacyStudent = posterRole.isEmpty && teacherId.isEmpty;
            return isStudentRole || legacyStudent;
          }).toList();

          if (docs.isEmpty) {
            return const Center(child: Text('No student tuition requests'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index];
              final t = d.data() as Map<String, dynamic>;
              final tuitionId = t['uid'] ?? d.id;
              final studentId = t['posterId'] ?? '';
              final status = (t['status'] ?? 'open').toString();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(t['interestedSubject'] ?? 'Tuition'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (t['days'] != null)
                        Text(
                            'Days: ${List<String>.from(t['days']).join(', ')}'),
                      if (t['startTime'] != null)
                        Text('Time: ${t['startTime']} - ${t['endTime'] ?? ''}'),
                      if (t['salary'] != null) Text('Salary: ${t['salary']}'),
                    ],
                  ),
                  trailing: status == 'open'
                      ? ElevatedButton(
                          onPressed: () async {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser == null) {
                              return;
                            }
                            final teacherUid = currentUser.uid;
                            final selDocId = '${tuitionId}_$teacherUid';
                            final tuitionRef = FirebaseFirestore.instance
                                .collection('tuitions')
                                .doc(tuitionId);
                            final selRef = FirebaseFirestore.instance
                                .collection('tuition_selections')
                                .doc(selDocId);

                            try {
                              await FirebaseFirestore.instance
                                  .runTransaction((tx) async {
                                final tuitionSnap = await tx.get(tuitionRef);
                                final currentStatus = tuitionSnap.exists
                                    ? (tuitionSnap.data()
                                        as Map<String, dynamic>)['status']
                                    : null;
                                if (currentStatus != 'open') {
                                  throw Exception(
                                      'Tuition no longer available');
                                }

                                // read student info
                                final studentRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(studentId);
                                final studentSnap = await tx.get(studentRef);
                                final studentData = studentSnap.exists
                                    ? studentSnap.data() as Map<String, dynamic>
                                    : null;
                                final studentName = studentData != null
                                    ? '${studentData['firstName'] ?? ''} ${studentData['lastName'] ?? ''}'
                                        .trim()
                                    : studentId;

                                // read teacher info to capture teacher name
                                final teacherRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(teacherUid);
                                final teacherSnap = await tx.get(teacherRef);
                                final teacherData = teacherSnap.exists
                                    ? teacherSnap.data() as Map<String, dynamic>
                                    : null;
                                final teacherName = teacherData != null
                                    ? '${teacherData['firstName'] ?? ''} ${teacherData['lastName'] ?? ''}'
                                        .trim()
                                    : teacherUid;

                                tx.set(selRef, {
                                  'uid': selRef.id,
                                  'tuitionId': tuitionId,
                                  'studentId': studentId,
                                  'teacherId': teacherUid,
                                  'studentName': studentName,
                                  'teacherName': teacherName,
                                  'subject': t['interestedSubject'] ?? '',
                                  'days': t['days'] ?? [],
                                  'startTime': t['startTime'] ?? '',
                                  'endTime': t['endTime'] ?? '',
                                  'createdAt': FieldValue.serverTimestamp(),
                                  'status': 'selected',
                                });

                                tx.update(tuitionRef, {'status': 'selected'});
                              });

                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('You selected this request')));
                              setState(() {});
                            } catch (e) {
                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: const Text('Select'),
                        )
                      : FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tuition_selections')
                              .where('tuitionId', isEqualTo: tuitionId)
                              .limit(1)
                              .get(),
                          builder: (context, selSnap) {
                            if (!selSnap.hasData) {
                              return const Text('Selected');
                            }
                            final selDocs = selSnap.data!.docs;
                            if (selDocs.isEmpty) {
                              return const Text('Selected');
                            }
                            final sel =
                                selDocs.first.data() as Map<String, dynamic>;
                            final selectingTeacherId = sel['teacherId'] ?? '';
                            final isMe =
                                user != null && selectingTeacherId == user.uid;
                            return Text(isMe ? 'Selected (you)' : 'Selected');
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
