import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import 'user_list_screen.dart';
import 'manage_tuition_screen.dart';
import 'create_class_screen.dart';
import 'schedule_manager_screen.dart';
import 'class_enrollments_screen.dart';

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
                final studentDocs =
                    users.where((doc) => doc['role'] == 'student').toList();
                final teacherDocs =
                    users.where((doc) => doc['role'] == 'teacher').toList();
                final studentCount = studentDocs.length;
                final teacherCount = teacherDocs.length;

                // responsive card layout: switch to wrap/grid based on available width
                return LayoutBuilder(builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  const spacing = 12.0;
                  final columns =
                      maxWidth >= 800 ? 3 : (maxWidth >= 560 ? 2 : 1);
                  final itemWidth =
                      (maxWidth - (columns - 1) * spacing) / columns;

                  Widget buildCard(
                      {required Widget child, required VoidCallback onTap}) {
                    return SizedBox(
                      width: itemWidth,
                      child: Card(
                        child: InkWell(onTap: onTap, child: child),
                      ),
                    );
                  }

                  Widget avatarsForDocs(List docs) {
                    final shown = docs.take(3).toList();
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: shown.map<Widget>((doc) {
                        final data =
                            (doc.data() as Map<String, dynamic>?) ?? {};
                        final photo =
                            data['photoUrl'] ?? data['photo_url'] ?? '';
                        final name = data['displayName'] ?? data['name'] ?? '';
                        final initials =
                            (name != null && name.toString().isNotEmpty)
                                ? name
                                    .toString()
                                    .trim()
                                    .split(' ')
                                    .map((s) => s.isNotEmpty ? s[0] : '')
                                    .take(2)
                                    .join()
                                : '';
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                (photo != null && photo.toString().isNotEmpty)
                                    ? NetworkImage(photo.toString())
                                    : null,
                            child: (photo == null || photo.toString().isEmpty)
                                ? Text(initials)
                                : null,
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      buildCard(
                        child: ListTile(
                          leading: avatarsForDocs(studentDocs),
                          title: const Text('All Students'),
                          trailing: Text(studentCount.toString()),
                        ),
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
                      buildCard(
                        child: ListTile(
                          leading: avatarsForDocs(teacherDocs),
                          title: const Text('All Teachers'),
                          trailing: Text(teacherCount.toString()),
                        ),
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
                      buildCard(
                        child: const ListTile(
                          title: Text('Manage Tuition'),
                          leading: Icon(Icons.manage_accounts),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ManageTuitionScreen()));
                        },
                      ),
                    ],
                  );
                });
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
                          builder: (_) => const CreateClassScreen()));
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
            Text('All Enrollments',
                style: Theme.of(context).textTheme.headlineSmall),
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
                        leading: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(enrollment.studentId)
                              .get(),
                          builder: (context, userSnap) {
                            if (userSnap.connectionState ==
                                ConnectionState.waiting) {
                              return const CircleAvatar(radius: 20);
                            }
                            if (!userSnap.hasData ||
                                userSnap.data == null ||
                                !userSnap.data!.exists) {
                              return const CircleAvatar(radius: 20);
                            }
                            final data = userSnap.data!.data()
                                    as Map<String, dynamic>? ??
                                {};
                            final photo =
                                data['photoUrl'] ?? data['photo_url'] ?? '';
                            final name =
                                data['displayName'] ?? data['name'] ?? '';
                            final initials =
                                (name != null && name.toString().isNotEmpty)
                                    ? name
                                        .toString()
                                        .trim()
                                        .split(' ')
                                        .map((s) => s.isNotEmpty ? s[0] : '')
                                        .take(2)
                                        .join()
                                    : '';
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  (photo != null && photo.toString().isNotEmpty)
                                      ? NetworkImage(photo.toString())
                                      : null,
                              child: (photo == null || photo.toString().isEmpty)
                                  ? Text(initials)
                                  : null,
                            );
                          },
                        ),
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
