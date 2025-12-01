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

class _HeaderStat extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot> stream;

  const _HeaderStat({Key? key, required this.title, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Row(
                children: [
                  const CircularProgressIndicator(strokeWidth: 2),
                  const SizedBox(width: 8),
                  Text(title),
                ],
              );
            }
            final count = snap.data!.docs.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                Text('$count',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TopNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).primaryColor : Colors.grey[600];
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? color!.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Widget bodyWidget;
    switch (_selectedIndex) {
      case 0:
        bodyWidget = _buildEnrollmentsView(context, user);
        break;
      case 1:
        bodyWidget = _buildModulesView(context);
        break;
      case 2:
        bodyWidget = _buildFindTuitionView(context, user);
        break;
      case 3:
        bodyWidget = _buildProfileView(context, user);
        break;
      default:
        bodyWidget = _buildEnrollmentsView(context, user);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: const Text(''),
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
      body: Column(
        children: [
          // Top header with gradient, greeting and nav
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          child: Text(
                            user?.displayName != null &&
                                    user!.displayName!.isNotEmpty
                                ? user.displayName![0].toUpperCase()
                                : (user?.email ?? '?')[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user != null && user.email != null
                                  ? user.email!.split('@').first
                                  : 'Student',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // top navigation row
                Material(
                  color: Colors.white,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TopNavItem(
                          icon: Icons.book,
                          label: 'Enrollments',
                          selected: _selectedIndex == 0,
                          onTap: () => setState(() => _selectedIndex = 0),
                        ),
                        _TopNavItem(
                          icon: Icons.dashboard,
                          label: 'Modules',
                          selected: _selectedIndex == 1,
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        _TopNavItem(
                          icon: Icons.search,
                          label: 'Find',
                          selected: _selectedIndex == 2,
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                        _TopNavItem(
                          icon: Icons.person,
                          label: 'Profile',
                          selected: _selectedIndex == 3,
                          onTap: () => setState(() => _selectedIndex = 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Stats row
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _HeaderStat(
                  title: 'Enrolled',
                  stream: FirebaseFirestore.instance
                      .collection('enrollments')
                      .where('studentId', isEqualTo: user?.uid)
                      .where('status', isEqualTo: 'enrolled')
                      .snapshots(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeaderStat(
                  title: 'Pending',
                  stream: FirebaseFirestore.instance
                      .collection('enrollments')
                      .where('studentId', isEqualTo: user?.uid)
                      .where('status', isEqualTo: 'interested')
                      .snapshots(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeaderStat(
                  title: 'Available',
                  stream: FirebaseFirestore.instance
                      .collection('tuitions')
                      .where('status',
                          whereIn: ['open', 'selected']).snapshots(),
                ),
              ),
            ],
          ),
          // Content with animated switcher
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.white,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: SizedBox(
                      key: ValueKey<int>(_selectedIndex),
                      width: double.infinity,
                      height: double.infinity,
                      child: bodyWidget,
                    ),
                  ),
                ),
              ),
            ),
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

  void _showDetailsDialog(
      BuildContext context, String uid, Map<String, dynamic> data) {
    final created = data['createdAt'];
    String createdStr;
    try {
      if (created == null) {
        createdStr = 'Unknown';
      } else if (created is Timestamp) {
        createdStr = created.toDate().toLocal().toString();
      } else {
        createdStr = created.toString();
      }
    } catch (_) {
      createdStr = created?.toString() ?? 'Unknown';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UID: $uid'),
                const SizedBox(height: 8),
                Text('Email: ${data['email'] ?? '—'}'),
                const SizedBox(height: 8),
                Text(
                    'Name: ${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'
                        .trim()),
                const SizedBox(height: 8),
                Text('Phone: ${data['phoneNumber'] ?? '—'}'),
                const SizedBox(height: 8),
                Text('School: ${data['schoolName'] ?? '—'}'),
                const SizedBox(height: 8),
                Text('Class: ${data['classLevel'] ?? '—'}'),
                const SizedBox(height: 8),
                Text('Gender: ${data['gender'] ?? '—'}'),
                const SizedBox(height: 8),
                Text('Role: ${data['role'] ?? 'student'}'),
                const SizedBox(height: 8),
                Text('Registered: $createdStr'),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close')),
          ],
        );
      },
    );
  }

  Widget _buildProfileView(BuildContext context, User? user) {
    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final doc = snap.data!;
        if (!doc.exists) {
          return const Center(child: Text('Profile not found'));
        }
        final data = doc.data() as Map<String, dynamic>;
        final fullName =
            '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
        final email = (data['email'] ?? user.email ?? '').toString();
        final phone = (data['phoneNumber'] ?? '').toString();
        final school = (data['schoolName'] ?? '').toString();
        final classLevel = (data['classLevel'] ?? '').toString();
        final gender = (data['gender'] ?? '').toString();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  fullName.isNotEmpty ? fullName : 'Unnamed',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(phone.isNotEmpty ? phone : '—'),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(school.isNotEmpty ? school : '—'),
                ),
                ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text(classLevel.isNotEmpty ? classLevel : '—'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(gender.isNotEmpty ? gender : '—'),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _showDetailsDialog(context, doc.id, data),
                      child: const Text('Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          Wrap(
            spacing: 12,
            runSpacing: 8,
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
            // Responsive module grid
            LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 1;
              double childAspect = 3.2;
              if (width > 1100) {
                crossAxisCount = 3;
                childAspect = 3.2;
              } else if (width > 700) {
                crossAxisCount = 2;
                childAspect = 3.2;
              } else {
                crossAxisCount = 1;
                childAspect = 3.6;
              }

              final modules = [
                {
                  'title': 'Available Tuition',
                  'subtitle': 'Find tutors posted by teachers',
                  'icon': Icons.search,
                  'color': Colors.indigo,
                  'onTap': () => setState(() => _selectedIndex = 2),
                },
                {
                  'title': 'Payments',
                  'subtitle': 'View and manage payments',
                  'icon': Icons.payment,
                  'color': Colors.blue,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentPayments),
                },
                {
                  'title': 'Payment History',
                  'subtitle': 'View your payment history',
                  'icon': Icons.history,
                  'color': Colors.indigo,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.paymentHistory),
                },
                {
                  'title': 'Invoices',
                  'subtitle': 'View your invoices',
                  'icon': Icons.receipt,
                  'color': Colors.purple,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.invoiceView),
                },
                {
                  'title': 'Results',
                  'subtitle': 'View exam results',
                  'icon': Icons.assessment,
                  'color': Colors.green,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentResults),
                },
                {
                  'title': 'Progress Report',
                  'subtitle': 'View your progress',
                  'icon': Icons.trending_up,
                  'color': Colors.teal,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentProgress),
                },
                {
                  'title': 'Rewards',
                  'subtitle': 'View achievements and rewards',
                  'icon': Icons.star,
                  'color': Colors.amber,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentRewards),
                },
                {
                  'title': 'Class Schedule',
                  'subtitle': 'View class timetable',
                  'icon': Icons.schedule,
                  'color': Colors.orange,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentSchedule),
                },
                {
                  'title': 'Materials',
                  'subtitle': 'Download course materials',
                  'icon': Icons.folder,
                  'color': Colors.brown,
                  'onTap': () =>
                      Navigator.pushNamed(context, AppRoutes.studentMaterials),
                },
              ];

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: childAspect,
                ),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final m = modules[index];
                  return _buildModuleCard(
                    context,
                    m['title'] as String,
                    m['subtitle'] as String,
                    m['icon'] as IconData,
                    m['color'] as Color,
                    m['onTap'] as VoidCallback,
                  );
                },
              );
            }),
            const SizedBox(height: 30),
          ],
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
