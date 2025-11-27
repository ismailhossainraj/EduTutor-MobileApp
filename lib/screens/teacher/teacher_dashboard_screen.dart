import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import '../../routes/app_routes.dart';
import '../../services/teacher_data_service.dart';
import '_dashboard_widgets.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int? studentCount;
  int? assignmentCount;
  double? attendanceRate;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final service = TeacherDataService();
    final sCount = await service.getStudentCount(user.uid);
    final aCount = await service.getAssignmentCount(user.uid);
    final attRate = await service.getAttendanceRate(user.uid);

    setState(() {
      studentCount = sCount;
      assignmentCount = aCount;
      attendanceRate = attRate;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Teacher Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Student List'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Student list feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Student'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('View student feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Attendance feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Text(
                    'Welcome, Teacher!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),

                  // Dashboard Stats Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardStatCard(
                        icon: Icons.people,
                        label: 'Students',
                        value: studentCount?.toString() ?? '-',
                        color: Colors.blue,
                      ),
                      DashboardStatCard(
                        icon: Icons.check_circle,
                        label: 'Attendance',
                        value: attendanceRate != null
                            ? '${attendanceRate!.toStringAsFixed(1)}%'
                            : '-',
                        color: Colors.green,
                      ),
                      DashboardStatCard(
                        icon: Icons.assignment,
                        label: 'Assignments',
                        value: assignmentCount?.toString() ?? '-',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Quick Actions Section
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      QuickActionButton(
                        icon: Icons.people,
                        label: 'Student List',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Student list feature coming soon!')),
                          );
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.visibility,
                        label: 'View Student',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('View student feature coming soon!')),
                          );
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.check_circle,
                        label: 'Attendance',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Attendance feature coming soon!')),
                          );
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.person,
                        label: 'Profile',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile feature coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Recent Activity Section
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text('Checked assignment submissions'),
                      subtitle: Text('Today, 10:00 AM'),
                    ),
                  ),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline),
                      title: Text('Marked attendance for Class 10A'),
                      subtitle: Text('Yesterday, 9:00 AM'),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Interested Students Section
                  Text(
                    'Interested Students',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('enrollments')
                        .where('teacherId', isEqualTo: user?.uid)
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

                      if (enrollments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('No interested students'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: enrollments.length,
                        itemBuilder: (context, index) {
                          final enrollment = enrollments[index];
                          return ListTile(
                            title: Text(enrollment.subject),
                            subtitle: Text('Mode: ${enrollment.mode}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('enrollments')
                                    .doc(enrollment.uid)
                                    .update({'status': 'enrolled'});
                              },
                              child: const Text('Enroll'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // Enrolled Students Section
                  Text(
                    'Enrolled Students',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('enrollments')
                        .where('teacherId', isEqualTo: user?.uid)
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

                      if (enrollments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('No enrolled students'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                ],
              ),
            ),
    );
  }
}
