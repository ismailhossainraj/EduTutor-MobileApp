import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/enrollment_model.dart';
import '../../models/tuition_model.dart';
import '../../routes/app_routes.dart';
import 'student_search_screen.dart';
import '../teacher/tuition_needed_screen.dart';

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
            tooltip: 'Find Tuition',
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
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
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                icon: const Icon(Icons.search),
                label: const Text('Find Tuition'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedIndex == 0
                ? _buildEnrollmentsView(context, user)
                : _selectedIndex == 1
                    ? _buildModulesView(context)
                    : _buildFindTuitionView(context, user),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Switch tabs for all indices so Find Tuition is an integrated tab.
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
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find Tuition',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        icon: const Icon(Icons.search),
        label: const Text('Find Tuition'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFindTuitionView(BuildContext context, User? user) {
    // Build two sections: Selected (student's picks) and Available (open posts)
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Tuitions',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),

            // Stream the student's selections first and capture selected IDs
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tuition_selections')
                  .where('studentId', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, selSnap) {
                if (!selSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final sels = selSnap.data!.docs;

                if (sels.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('You have not selected any tuition yet.'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sels.length,
                  itemBuilder: (context, i) {
                    final sDoc = sels[i];
                    final s = sDoc.data() as Map<String, dynamic>;
                    final tuitionId = s['tuitionId'] ?? '';
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tuitions')
                          .doc(tuitionId)
                          .get(),
                      builder: (context, tSnap) {
                        if (!tSnap.hasData) {
                          return const ListTile(title: Text('Loading...'));
                        }
                        final tuitionDoc = tSnap.data!;
                        final tuition = tuitionDoc.exists
                            ? tuitionDoc.data() as Map<String, dynamic>
                            : null;
                        return ListTile(
                          title: Text(tuition != null
                              ? (tuition['interestedSubject'] ?? 'Tuition')
                              : 'Tuition'),
                          subtitle: tuition != null
                              ? Text(
                                  'Time: ${tuition['startTime'] ?? ''} • Days: ${List<String>.from(tuition['days'] ?? []).join(', ')}')
                              : null,
                          trailing: ElevatedButton(
                            onPressed: () async {
                              // remove selection and set tuition back to open
                              final selDocId = sDoc.id;
                              await FirebaseFirestore.instance
                                  .collection('tuition_selections')
                                  .doc(selDocId)
                                  .delete();
                              if (tuitionId.isNotEmpty) {
                                await FirebaseFirestore.instance
                                    .collection('tuitions')
                                    .doc(tuitionId)
                                    .update({'status': 'open'});
                              }
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

            const Divider(height: 24),
            Text('Available Tuitions',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),

            // Available tuitions: only those that are open (and therefore selectable)
            // Filter out tuitions posted by students so student's own posts
            // don't appear in the Find Tuition list.
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tuitions')
                  .where('status', isEqualTo: 'open')
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // client-side filter: exclude student-posted tuitions
                final rawDocs = snap.data!.docs;
                final filtered = rawDocs.where((d) {
                  final m = d.data() as Map<String, dynamic>;
                  final posterRole =
                      (m['posterRole'] ?? '').toString().toLowerCase();
                  final posterId = (m['posterId'] ?? '').toString();
                  // exclude posts explicitly marked as posted by students
                  if (posterRole == 'student') {
                    return false;
                  }
                  // exclude posts created by the current student
                  if (user != null && posterId == user.uid) {
                    return false;
                  }
                  return true;
                }).toList();

                final items = filtered
                    .map((d) =>
                        TuitionModel.fromMap(d.data() as Map<String, dynamic>))
                    .toList();

                if (items.isEmpty) {
                  return const Text('No available tuition posts');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: user == null
                              ? null
                              : () async {
                                  final studentUid = user.uid;
                                  final selDocId = '${t.uid}_$studentUid';
                                  final tuitionRef = FirebaseFirestore.instance
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
                                      final currentStatus = tuitionSnap.exists
                                          ? (tuitionSnap.data()
                                              as Map<String, dynamic>)['status']
                                          : null;
                                      if (currentStatus != 'open') {
                                        throw Exception(
                                            'Tuition no longer available');
                                      }

                                      // Read student profile inside the transaction to capture name/email
                                      final userRef = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(studentUid);
                                      final studentSnap = await tx.get(userRef);
                                      final studentData = studentSnap.exists
                                          ? studentSnap.data()
                                              as Map<String, dynamic>
                                          : null;
                                      final studentName = studentData != null
                                          ? '${studentData['firstName'] ?? ''} ${studentData['lastName'] ?? ''}'
                                              .trim()
                                          : studentUid;
                                      final studentEmail = studentData != null
                                          ? (studentData['email'] ?? '')
                                          : '';

                                      final tuitionData = tuitionSnap.exists
                                          ? tuitionSnap.data()
                                              as Map<String, dynamic>
                                          : <String, dynamic>{};

                                      tx.set(selRef, {
                                        'uid': selRef.id,
                                        'tuitionId': t.uid,
                                        'studentId': studentUid,
                                        'teacherId': t.teacherId,
                                        // duplicate some student and tuition summary fields for easier teacher reads
                                        'studentName': studentName,
                                        'studentEmail': studentEmail,
                                        'subject':
                                            tuitionData['interestedSubject'] ??
                                                '',
                                        'days': tuitionData['days'] ?? [],
                                        'startTime':
                                            tuitionData['startTime'] ?? '',
                                        'endTime': tuitionData['endTime'] ?? '',
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                        'status': 'selected',
                                      });
                                      tx.update(
                                          tuitionRef, {'status': 'selected'});
                                    });
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Tutor selected')));
                                    setState(() {});
                                  } catch (e) {
                                    if (!mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                },
                          child: const Text('Select'),
                        ),
                      ),
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
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: const Text('Find Tuition'),
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
            'Available Tuition',
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

                // filter out student-posted tuitions (including current student's posts)
                final raw = snap.data!.docs;
                final filtered = raw.where((d) {
                  final m = d.data() as Map<String, dynamic>;
                  final posterRole =
                      (m['posterRole'] ?? '').toString().toLowerCase();
                  final posterId = (m['posterId'] ?? '').toString();
                  if (posterRole == 'student') return false;
                  if (user != null && posterId == user.uid) return false;
                  return true;
                }).toList();

                final items = filtered
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

                                          // Read student profile inside the transaction
                                          final userRef = FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc(studentUid);
                                          final studentSnap =
                                              await tx.get(userRef);
                                          final studentData = studentSnap.exists
                                              ? studentSnap.data()
                                                  as Map<String, dynamic>
                                              : null;
                                          final studentName = studentData !=
                                                  null
                                              ? '${studentData['firstName'] ?? ''} ${studentData['lastName'] ?? ''}'
                                                  .trim()
                                              : studentUid;
                                          final studentEmail =
                                              studentData != null
                                                  ? (studentData['email'] ?? '')
                                                  : '';

                                          final tuitionData = tuitionSnap.exists
                                              ? tuitionSnap.data()
                                                  as Map<String, dynamic>
                                              : <String, dynamic>{};

                                          tx.set(selRef, {
                                            'uid': selRef.id,
                                            'tuitionId': t.uid,
                                            'studentId': studentUid,
                                            'teacherId': t.teacherId,
                                            'studentName': studentName,
                                            'studentEmail': studentEmail,
                                            'subject': tuitionData[
                                                    'interestedSubject'] ??
                                                '',
                                            'days': tuitionData['days'] ?? [],
                                            'startTime':
                                                tuitionData['startTime'] ?? '',
                                            'endTime':
                                                tuitionData['endTime'] ?? '',
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
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
            // Quick Actions (small cards)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _quickAction(context, Icons.payment, 'Make Payment', () {
                  Navigator.pushNamed(context, AppRoutes.studentPayments);
                }),
                _quickAction(context, Icons.assessment, 'Tuition Wanted', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TuitionNeededScreen(),
                    ),
                  );
                }),
                _quickAction(context, Icons.trending_up, 'Find Tuition', () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),
                _quickAction(context, Icons.schedule, 'View Schedule', () {
                  Navigator.pushNamed(context, AppRoutes.studentSchedule);
                }),
                _quickAction(context, Icons.post_add, 'Tuition Wanted', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TuitionNeededScreen(),
                    ),
                  );
                }),
                _quickAction(context, Icons.search, 'Find Tuition', () {
                  // switch to Find Tuition tab
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 12),
            // Add Available Tuition module card for easy access
            _buildModuleCard(
              context,
              'Available Tuition',
              'Find tutors posted by teachers',
              Icons.search,
              Colors.indigo,
              () => setState(() {
                _selectedIndex = 2;
              }),
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

  Widget _quickAction(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: 160,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
