import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import '../../routes/app_routes.dart';
import 'student_search_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildEnrollmentsView(context, user)
          : _buildModulesView(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Enrollments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Modules',
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentsView(BuildContext context, User? user) {
    return Padding(
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

                if (enrollments.isEmpty) {
                  return const Center(child: Text('No enrolled subjects'));
                }

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

                if (enrollments.isEmpty) {
                  return const Center(child: Text('No pending requests'));
                }

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
    );
  }

  Widget _buildModulesView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Student Modules',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // Payment Section
            _buildSectionHeader(context, 'Payment Management'),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Payments',
              'View and manage payments',
              Icons.payment,
              Colors.blue,
              () => Navigator.pushNamed(context, AppRoutes.studentPayments),
            ),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Payment History',
              'View your payment history',
              Icons.history,
              Colors.indigo,
              () => Navigator.pushNamed(context, AppRoutes.paymentHistory),
            ),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Invoices',
              'View your invoices',
              Icons.receipt,
              Colors.purple,
              () => Navigator.pushNamed(context, AppRoutes.invoiceView),
            ),
            const SizedBox(height: 30),
            // Academic Section
            _buildSectionHeader(context, 'Academic'),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Results',
              'View exam results',
              Icons.assessment,
              Colors.green,
              () => Navigator.pushNamed(context, AppRoutes.studentResults),
            ),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Progress Report',
              'View your progress',
              Icons.trending_up,
              Colors.teal,
              () => Navigator.pushNamed(context, AppRoutes.studentProgress),
            ),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Rewards',
              'View achievements and rewards',
              Icons.star,
              Colors.amber,
              () => Navigator.pushNamed(context, AppRoutes.studentRewards),
            ),
            const SizedBox(height: 30),
            // Class & Materials Section
            _buildSectionHeader(context, 'Learning Resources'),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Class Schedule',
              'View class timetable',
              Icons.schedule,
              Colors.orange,
              () => Navigator.pushNamed(context, AppRoutes.studentSchedule),
            ),
            const SizedBox(height: 10),
            _buildModuleCard(
              context,
              'Materials',
              'Download course materials',
              Icons.folder,
              Colors.brown,
              () => Navigator.pushNamed(context, AppRoutes.studentMaterials),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
