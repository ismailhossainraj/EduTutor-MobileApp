import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;
                final studentCount =
                    users.where((doc) => doc['role'] == 'student').length;
                final teacherCount =
                    users.where((doc) => doc['role'] == 'teacher').length;

                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Total Students'),
                        trailing: Text(studentCount.toString()),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Total Teachers'),
                        trailing: Text(teacherCount.toString()),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'All Enrollments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('enrollments')
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
                        subtitle: Text(
                            'Student: ${enrollment.studentId} - Teacher: ${enrollment.teacherId}'),
                        trailing: Text(enrollment.status),
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
