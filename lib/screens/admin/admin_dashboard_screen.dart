import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import 'create_class_screen.dart';
import 'schedule_manager_screen.dart';
import 'class_enrollments_screen.dart';
import 'user_list_screen.dart';

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
                        title: const Text('All Students'),
                        trailing: Text(studentCount.toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserListScreen(
                                  role: 'student', title: 'All Students'),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('All Teachers'),
                        trailing: Text(teacherCount.toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserListScreen(
                                  role: 'teacher', title: 'All Teachers'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Admin actions
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('Create Class'),
                subtitle: const Text('Add a new class / batch'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              // lazy import screen
                              const CreateClassScreen()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Class Schedule'),
                subtitle: const Text('View and manage class schedules'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ScheduleManagerScreen()));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Class Enrollments'),
                subtitle: const Text('View enrolled students per class'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ClassEnrollmentsScreen()));
                },
              ),
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
                      final date = enrollment.createdAt;
                      final dateStr = '${date.month}/${date.day}/${date.year}';
                      return ListTile(
                        title: Text(enrollment.subject),
                        subtitle: Text(
                            'Status: ${enrollment.status} • Date: $dateStr'),
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
