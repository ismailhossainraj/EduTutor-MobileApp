import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// enrollment model no longer used in this screen
import '../../routes/app_routes.dart';
import '../../services/teacher_data_service.dart';
import '_dashboard_widgets.dart';
import '../../widgets/ai_chat_widget.dart';
import 'tuition_needed_screen.dart';
import 'teacher_details_screen.dart';
import 'selected_student_list_screen.dart';
import 'search_tuition_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int? studentCount;
  int? assignmentCount;
  double? attendanceRate;
  String? teacherName;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final service = TeacherDataService();
    final sCount = await service.getStudentCount(user.uid);
    final aCount = await service.getAssignmentCount(user.uid);
    final attRate = await service.getAttendanceRate(user.uid);

    // fetch teacher profile name (firstName + lastName) if available
    String name = '';
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final fn = (data['firstName'] ?? '').toString();
          final ln = (data['lastName'] ?? '').toString();
          name = '$fn $ln'.trim();
        }
      }
    } catch (_) {
      // ignore firestore read errors for name, fallback to auth displayName
    }
    if (name.isEmpty) {
      name = user.displayName ?? 'Teacher';
    }

    if (!mounted) {
      return;
    }
    setState(() {
      studentCount = sCount;
      assignmentCount = aCount;
      attendanceRate = attRate;
      teacherName = name;
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
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'AI Assistant',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => const FractionallySizedBox(
                  heightFactor: 0.85,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SafeArea(child: AiChatWidget()),
                  ),
                ),
              );
            },
          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectedStudentListScreen(),
                  ),
                );
              },
            ),
            // 'View Student' and 'Attendance' removed per request.
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
                  // Hero header with teacher name
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white24,
                          child: Text(
                            (teacherName != null && teacherName!.isNotEmpty)
                                ? teacherName![0].toUpperCase()
                                : 'T',
                            style: const TextStyle(
                                fontSize: 28, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                teacherName != null && teacherName!.isNotEmpty
                                    ? teacherName!
                                    : 'Teacher',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Manage your classes, students and posts',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // (Stats removed by request)

                  // Quick Actions (responsive grid)
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(builder: (context, constraints) {
                    final maxW = constraints.maxWidth;
                    const spacing = 12.0;
                    final columns = maxW >= 700 ? 2 : 1;
                    final itemW = (maxW - (columns - 1) * spacing) / columns;

                    Widget actionItem({required Widget child}) =>
                        SizedBox(width: itemW, child: child);

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        actionItem(
                            child: QuickActionButton(
                                icon: Icons.search,
                                label: 'Search Tuition',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const SearchTuitionScreen()));
                                })),
                        actionItem(
                            child: QuickActionButton(
                                icon: Icons.school,
                                label: 'Tuition Needed',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TuitionNeededScreen()));
                                })),
                        actionItem(
                            child: QuickActionButton(
                                icon: Icons.people,
                                label: 'Student List',
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const SelectedStudentListScreen()));
                                })),
                        actionItem(
                            child: QuickActionButton(
                                icon: Icons.person,
                                label: 'Profile',
                                onTap: () async {
                                  final current =
                                      FirebaseAuth.instance.currentUser;
                                  if (current == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Not signed in')));
                                    return;
                                  }
                                  try {
                                    final doc = await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(current.uid)
                                        .get();
                                    if (!doc.exists) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Profile not found')));
                                      return;
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                TeacherDetailsScreen(
                                                    teacherUid: current.uid)));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error: ${e.toString()}')));
                                  }
                                })),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                  // Recent Activity removed by request.
                ],
              ),
            ),
    );
  }
}
