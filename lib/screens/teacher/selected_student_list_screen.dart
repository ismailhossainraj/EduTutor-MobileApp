import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectedStudentListScreen extends StatelessWidget {
  const SelectedStudentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Students who selected your tuitions',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Expanded(
              child: user == null
                  ? const Center(child: Text('Please sign in to view students'))
                  : StreamBuilder<QuerySnapshot>(
                      // NOTE: removed `orderBy('createdAt')` to avoid requiring a
                      // composite Firestore index during development. If you
                      // prefer ordering by `createdAt`, add the composite index
                      // shown in the runtime error link or re-enable ordering.
                      stream: FirebaseFirestore.instance
                          .collection('tuition_selections')
                          .where('teacherId', isEqualTo: user.uid)
                          .where('status', isEqualTo: 'selected')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading selections: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final sels = snapshot.data?.docs ?? [];
                        if (sels.isEmpty) {
                          return const Center(
                            child: Text(
                                'No students have selected your tuitions yet.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: sels.length,
                          itemBuilder: (context, index) {
                            final s =
                                sels[index].data() as Map<String, dynamic>;

                            // Prefer cached fields added at selection time
                            final studentName =
                                (s['studentName'] as String?) ?? '';
                            final studentEmail =
                                (s['studentEmail'] as String?) ?? '';
                            final subject = (s['subject'] as String?) ?? '';
                            final days = (s['days'] as List?)
                                    ?.map((e) => e.toString())
                                    .toList() ??
                                <String>[];
                            final startTime = (s['startTime'] as String?) ?? '';
                            final endTime = (s['endTime'] as String?) ?? '';
                            final timeRange =
                                (startTime.isNotEmpty || endTime.isNotEmpty)
                                    ? '$startTime - $endTime'
                                    : '';

                            final displayName = studentName.isNotEmpty
                                ? studentName
                                : (s['studentId'] ?? 'Student');

                            return Card(
                              child: ListTile(
                                title: Text(displayName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (studentEmail.isNotEmpty)
                                      Text('Email: $studentEmail'),
                                    if (subject.isNotEmpty)
                                      Text('Subject: $subject'),
                                    if (days.isNotEmpty)
                                      Text('Days: ${days.join(', ')}'),
                                    if (timeRange.isNotEmpty)
                                      Text('Time: $timeRange'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
