import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import '../../models/tuition_model.dart';
import '../../routes/app_routes.dart';
import 'student_search_screen.dart';
import 'search_tutor_screen.dart';

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
            icon: const Icon(Icons.search),
            tooltip: 'Search Tutor',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchTutorScreen(),
                ),
              );
            },
          ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchTutorScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Search Tutor'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedIndex == 0
                ? _buildEnrollmentsView(context, user)
                : _buildModulesView(context),
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchTutorScreen()),
          );
        },
        icon: const Icon(Icons.search),
        label: const Text('Search Tutor'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEnrollmentsView(BuildContext context, User? user) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
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
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchTutorScreen(),
                    ),
                  );
                },
                child: const Text('Search Tutor'),
              ),
            ],
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
          const SizedBox(height: 20),
          Text(
            'Search Tutor',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tuitions')
                  .where('status', whereIn: ['open', 'selected']).snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snap.data!.docs
                    .map((d) =>
                        TuitionModel.fromMap(d.data() as Map<String, dynamic>))
                    .toList();
                if (items.isEmpty) {
                  return const Center(child: Text('No tutors found'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final t = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(t.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Subject: ${t.interestedSubject}'),
                            Text('Days: ${t.days.join(', ')}'),
                            Text('Time: ${t.startTime} - ${t.endTime}'),
                            Text('Salary: ${t.salary}'),
                            Text('Status: ${t.status}'),
                          ],
                        ),
                        trailing: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tuition_selections')
                              .doc('${t.uid}_${user?.uid}')
                              .get(),
                          builder: (context, selSnap) {
                            final exists =
                                selSnap.hasData && selSnap.data!.exists;
                            if (exists || t.status == 'selected') {
                              return const Text('Selected');
                            }
                            final canSelect =
                                t.status == 'open' && user != null;
                            return ElevatedButton(
                              onPressed: canSelect
                                  ? () async {
                                      final studentUid = user.uid;
                                      final selDocId = '${t.uid}_$studentUid';
                                      final tuitionRef = FirebaseFirestore
                                          .instance
                                          .collection('tuitions')
                                          .doc(t.uid);
                                      final selRef = FirebaseFirestore.instance
                                          .collection('tuition_selections')
                                          .doc(selDocId);
                                      try {
                                        await FirebaseFirestore.instance
                                            .runTransaction((tx) async {
                                          final tuitionSnap =
                                              await tx.get(tuitionRef);
                                          final currentStatus =
                                              tuitionSnap.exists
                                                  ? (tuitionSnap.data() as Map<
                                                      String,
                                                      dynamic>)['status']
                                                  : null;
                                          if (currentStatus != 'open') {
                                            throw Exception(
                                                'Tuition no longer available');
                                          }
                                          tx.set(selRef, {
                                            'uid': selRef.id,
                                            'tuitionId': t.uid,
                                            'studentId': studentUid,
                                            'teacherId': t.teacherId,
                                            'createdAt': DateTime.now(),
                                            'status': 'selected',
                                          });
                                          tx.update(tuitionRef,
                                              {'status': 'selected'});
                                        });
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Tutor selected')));
                                        setState(() {});
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    }
                                  : null,
                              child: const Text('Select'),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Selected Tutors',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tuition_selections')
                  .where('studentId', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final sels = snapshot.data!.docs;
                if (sels.isEmpty) {
                  return const Center(child: Text('No selected tutors'));
                }
                return ListView.builder(
                  itemCount: sels.length,
                  itemBuilder: (context, index) {
                    final s = sels[index].data() as Map<String, dynamic>;
                    final tuitionId = s['tuitionId'] ?? '';
                    final teacherId = s['teacherId'] ?? '';
                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: Future.wait([
                        FirebaseFirestore.instance
                            .collection('tuitions')
                            .doc(tuitionId)
                            .get(),
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(teacherId)
                            .get(),
                      ]),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const ListTile(title: Text('Loading...'));
                        }
                        final tuitionDoc = snap.data![0];
                        final teacherDoc = snap.data![1];
                        final tuition = tuitionDoc.exists
                            ? tuitionDoc.data() as Map<String, dynamic>
                            : null;
                        final teacher = teacherDoc.exists
                            ? teacherDoc.data() as Map<String, dynamic>
                            : null;
                        final teacherName = teacher != null
                            ? '${teacher['firstName'] ?? ''} ${teacher['lastName'] ?? ''}'
                            : teacherId;
                        return ListTile(
                          title: Text(tuition != null
                              ? (tuition['interestedSubject'] ?? 'Tuition')
                              : 'Tuition'),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Teacher: $teacherName'),
                                if (tuition != null)
                                  Text(
                                      'Time: ${tuition['startTime'] ?? ''} - ${tuition['endTime'] ?? ''}'),
                                if (tuition != null)
                                  Text(
                                      'Days: ${List<String>.from(tuition['days'] ?? []).join(', ')}'),
                              ]),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              // remove selection and set tuition back to open
                              final selDocId = sels[index].id;
                              await FirebaseFirestore.instance
                                  .collection('tuition_selections')
                                  .doc(selDocId)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('tuitions')
                                  .doc(tuitionId)
                                  .update({'status': 'open'});
                            },
                            child: const Text('Unselect'),
                          ),
                        );
                      },
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
            const SizedBox(height: 12),
            // Add Search Tutor module card for easy access
            _buildModuleCard(
              context,
              'Search Tutor',
              'Find tutors posted by teachers',
              Icons.search,
              Colors.indigo,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchTutorScreen()),
              ),
            ),
            const SizedBox(height: 20),
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
