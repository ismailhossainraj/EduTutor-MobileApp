import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import 'student_search_screen.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentSearchScreen(),
                  ),
                );
              },
              child: const Text('Search for Teachers'),
            ),
            const SizedBox(height: 20),
            Text(
              'Enrolled Subjects',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('enrollments')
                    .where('studentId', isEqualTo: user?.uid)
                    .where('status', isEqualTo: 'enrolled')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final enrollments = snapshot.data!.docs
                      .map((doc) => EnrollmentModel.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: enrollments.length,
                    itemBuilder: (context, index) {
                      final enrollment = enrollments[index];
                      return ListTile(
                        title: Text(enrollment.subject),
                        subtitle: Text('Mode: ${enrollment.mode}'),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pending Requests',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('enrollments')
                    .where('studentId', isEqualTo: user?.uid)
                    .where('status', isEqualTo: 'interested')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final enrollments = snapshot.data!.docs
                      .map((doc) => EnrollmentModel.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: enrollments.length,
                    itemBuilder: (context, index) {
                      final enrollment = enrollments[index];
                      return ListTile(
                        title: Text(enrollment.subject),
                        subtitle: Text('Mode: ${enrollment.mode}'),
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
