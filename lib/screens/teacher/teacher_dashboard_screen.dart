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

    if (!mounted) {
      return;
    }
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
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'AI Assistant',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const SizedBox(
                  height: 600,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AiChatWidget(),
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
                  // Welcome Section
                  Text(
                    'Welcome, Teacher!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 30),
                  // 'Find Tuition' section removed per request

                  // Dashboard stats removed per request

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SelectedStudentListScreen(),
                            ),
                          );
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.person,
                        label: 'Profile',
                        onTap: () async {
                          final current = FirebaseAuth.instance.currentUser;
                          if (current == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Not signed in')),
                            );
                            return;
                          }

                          try {
                            final doc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(current.uid)
                                .get();
                            if (!doc.exists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profile not found')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TeacherDetailsScreen(
                                  teacherUid: current.uid,
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.school,
                        label: 'Tuition Needed',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TuitionNeededScreen(),
                            ),
                          );
                        },
                      ),
                      QuickActionButton(
                        icon: Icons.search,
                        label: 'Search Tuition',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchTuitionScreen(),
                            ),
                          );
                        },
                      ),
                      // 'Find Tuition' quick action removed per request
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Recent Activity removed per request.

                  // Interested / Enrolled students sections removed per request.
                ],
              ),
            ),
    );
  }
}
