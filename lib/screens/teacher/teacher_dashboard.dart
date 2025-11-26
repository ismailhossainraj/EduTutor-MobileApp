// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import 'package:edututormobile/screens/teacher/_dashboard_widgets.dart';
import '../../services/teacher_data_service.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
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
    final user = Provider.of<AuthProvider>(context, listen: false).user;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
          ),
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Student List'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Student'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {},
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
                  Text(
                    'Welcome, Teacher!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
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
                        onTap: () {},
                      ),
                      QuickActionButton(
                        icon: Icons.visibility,
                        label: 'View Student',
                        onTap: () {},
                      ),
                      QuickActionButton(
                        icon: Icons.check_circle,
                        label: 'Attendance',
                        onTap: () {},
                      ),
                      QuickActionButton(
                        icon: Icons.person,
                        label: 'Profile',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.assignment_turned_in),
                      title: const Text('Checked assignment submissions'),
                      subtitle: const Text('Today, 10:00 AM'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: const Text('Marked attendance for Class 10A'),
                      subtitle: const Text('Yesterday, 9:00 AM'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
