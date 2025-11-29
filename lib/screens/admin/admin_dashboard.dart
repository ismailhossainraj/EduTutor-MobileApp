// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'dart:async';

import 'package:edututormobile/services/student_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import 'student_management.dart';
import 'payment_management.dart';
import 'teacher_management.dart';

class AdminDashboard extends StatelessWidget {
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!')),
    );
  }

  const AdminDashboard({super.key});

  // Example: Replace with actual data source or provider in real app
  // final int studentCount = 350;
  final int teacherCount = 25;
  final int courseCount = 12;

  @override
  Widget build(BuildContext context) {
    // Responsive padding for mobile and larger screens
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth < 400 ? 8.0 : 20.0;
    final double verticalPadding = screenWidth < 400 ? 8.0 : 20.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
            tooltip: 'Home',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
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
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Student Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Teacher Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeacherManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Course Management'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Schedule Management'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Admin Dashboard',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: _AdminStatCard(
                    icon: Icons.people,
                    label: 'Students',
                    value: StudentService.getStudentCount(),
                    color: Colors.blue,
                  ),
                ),
                Flexible(
                  child: _AdminStatCard(
                    icon: Icons.school,
                    label: 'Teachers',
                    value: teacherCount,
                    color: Colors.green,
                  ),
                ),
                Flexible(
                  child: _AdminStatCard(
                    icon: Icons.book,
                    label: 'Courses',
                    value: courseCount,
                    color: Colors.orange,
                  ),
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
                _AdminQuickAction(
                  icon: Icons.people,
                  label: 'Student Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentManagementScreen(),
                      ),
                    );
                  },
                ),
                _AdminQuickAction(
                  icon: Icons.school,
                  label: 'Teacher Management',
                  onTap: () => _showComingSoon(context, 'Teacher Management'),
                ),
                _AdminQuickAction(
                  icon: Icons.book,
                  label: 'Course Management',
                  onTap: () => _showComingSoon(context, 'Course Management'),
                ),
                _AdminQuickAction(
                  icon: Icons.payment,
                  label: 'Payment Management',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentManagementScreen(),
                      ),
                    );
                  },
                ),
                _AdminQuickAction(
                  icon: Icons.schedule,
                  label: 'Schedule Management',
                  onTap: () => _showComingSoon(context, 'Schedule Management'),
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
                leading: const Icon(Icons.person_add),
                title: const Text('Added new student'),
                subtitle: const Text('Today, 9:00 AM'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Approved teacher registration'),
                subtitle: const Text('Yesterday, 2:00 PM'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Admin Stat Card
class _AdminStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final FutureOr<int> value;
  final Color color;

  const _AdminStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: value is Future<int>
                    ? value as Future<int>
                    : Future.value(value),
                builder: (context, asyncSnapshot) {
                  return Text(asyncSnapshot.data?.toString() ?? '-',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
                }),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// Admin Quick Action
class _AdminQuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminQuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
