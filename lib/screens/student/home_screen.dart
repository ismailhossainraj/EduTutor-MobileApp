import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import 'search_tutor_screen.dart';
import '../teacher/tuition_needed_screen.dart';
import '../../widgets/ai_chat_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? currentUser;
  late UserModel? userModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (currentUser != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        if (doc.exists) {
          setState(() {
            userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          });
        }
      } catch (e) {
        // Error loading user data - handled gracefully
        // User will see fallback values in UI
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: const Text(
          'EduTutor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            tooltip: 'AI Assistant',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const AiChatWidget(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedIndex = 3; // Switch to Profile tab
              });
            },
            tooltip: 'Profile',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home,
                            color: _selectedIndex == 0
                                ? Colors.blue[700]
                                : Colors.grey),
                        const SizedBox(height: 6),
                        Text('Home',
                            style: TextStyle(
                                color: _selectedIndex == 0
                                    ? Colors.blue[700]
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.book,
                            color: _selectedIndex == 1
                                ? Colors.blue[700]
                                : Colors.grey),
                        const SizedBox(height: 6),
                        Text('Classes',
                            style: TextStyle(
                                color: _selectedIndex == 1
                                    ? Colors.blue[700]
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.payment,
                            color: _selectedIndex == 2
                                ? Colors.blue[700]
                                : Colors.grey),
                        const SizedBox(height: 6),
                        Text('Payments',
                            style: TextStyle(
                                color: _selectedIndex == 2
                                    ? Colors.blue[700]
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person,
                            color: _selectedIndex == 3
                                ? Colors.blue[700]
                                : Colors.grey),
                        const SizedBox(height: 6),
                        Text('Profile',
                            style: TextStyle(
                                color: _selectedIndex == 3
                                    ? Colors.blue[700]
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
      // bottomNavigationBar removed — navigation moved to AppBar.bottom
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildClassesTab();
      case 2:
        return _buildPaymentsTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  userModel?.fullName ?? 'Student',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const SizedBox(height: 24),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  icon: Icons.payment,
                  title: 'Make Payment',
                  subtitle: 'View and pay invoices',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.studentPayments);
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.assessment,
                  title: 'Tuition Wanted',
                  subtitle: 'Post a tuition request',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TuitionNeededScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.search,
                  title: 'Find Tuition',
                  subtitle: 'Find tutors posted by teachers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SearchTutorScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.schedule,
                  title: 'View Schedule',
                  subtitle: 'View timetable',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.studentSchedule);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildClassesTab() {
    final userId = currentUser?.uid ?? '';
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Classes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            // Enrolled classes: classes where studentIds array contains current user
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .where('studentIds', arrayContains: userId)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const SizedBox.shrink();
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Text('You are not enrolled in any classes yet.');
                }
                return Column(
                  children: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final title =
                        data['className'] ?? data['subject'] ?? 'Class';
                    final teacherList =
                        (data['teacherIds'] as List?) ?? <dynamic>[];
                    final teacher = teacherList.isNotEmpty
                        ? teacherList.first as String
                        : '';
                    final schedule = '${data['academicYear'] ?? ''}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildClassCard(
                        context,
                        title: title,
                        teacher: teacher,
                        schedule: schedule,
                        progress: 0,
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              'Available Classes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classes')
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Text('No classes available.');
                }
                return Column(
                  children: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final id = d.id;
                    final className = data['className'] ?? '';

                    final capacity = (data['capacity'] as num?)?.toInt() ?? 0;
                    final studentIds =
                        List<String>.from(data['studentIds'] ?? []);
                    final available = capacity - studentIds.length;
                    final enrolled = studentIds.contains(userId);
                    return Card(
                      child: ListTile(
                        title: Text('$className'),
                        subtitle: Text(
                          'Course: ${data['subject'] ?? data['courseName'] ?? data['course'] ?? ''}\nBatch: ${data['batchName'] ?? ''}\nSeats left: $available',
                        ),
                        trailing: ElevatedButton(
                          onPressed: (enrolled ||
                                  available <= 0 ||
                                  userId.isEmpty)
                              ? null
                              : () =>
                                  _showEnrollDialog(context, id, data, userId),
                          child: Text(enrolled ? 'Enrolled' : 'Enroll'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payments',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Amount Due: \$150.00',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.studentPayments);
                    },
                    child: const Text('Pay Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildPaymentHistoryItem(
              title: 'Tuition Fee',
              amount: '\$500.00',
              date: 'Nov 15, 2025',
              status: 'Paid',
              statusColor: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildPaymentHistoryItem(
              title: 'Lab Fee',
              amount: '\$75.00',
              date: 'Oct 20, 2025',
              status: 'Paid',
              statusColor: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildPaymentHistoryItem(
              title: 'Activities Fee',
              amount: '\$50.00',
              date: 'Oct 10, 2025',
              status: 'Paid',
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[700],
                    child: Text(
                      (userModel?.fullName ?? 'S')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userModel?.fullName ?? 'Student Name',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userModel?.email ?? 'student@email.com',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Registration details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Full name', userModel?.fullName ?? ''),
                  const SizedBox(height: 8),
                  _infoRow('Email', userModel?.email ?? ''),
                  const SizedBox(height: 8),
                  _infoRow('Gender', userModel?.gender ?? ''),
                  const SizedBox(height: 8),
                  _infoRow('School', userModel?.schoolName ?? ''),
                  const SizedBox(height: 8),
                  _infoRow('Class', userModel?.classLevel ?? ''),
                  const SizedBox(height: 8),
                  _infoRow(
                      'Registered',
                      userModel != null
                          ? '${userModel!.createdAt.toLocal()}'
                          : ''),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEnrollDialog(BuildContext context, String classId,
      Map<String, dynamic> classData, String userId) async {
    final className = classData['className'] ?? classData['subject'] ?? 'Class';
    final course = classData['subject'] ??
        classData['courseName'] ??
        classData['course'] ??
        '';
    final batch = classData['batchName'] ?? '';
    final level = classData['level'] ?? '';
    final academicYear =
        classData['academicYear'] ?? classData['session'] ?? '';
    final semester = classData['semester'] ?? '';
    final capacity = (classData['capacity'] as num?)?.toInt() ?? 0;
    final studentIds = List<String>.from(classData['studentIds'] ?? []);
    final seatsLeft = capacity - studentIds.length;
    final days =
        (classData['daysPerWeek'] as List?)?.cast<String>() ?? <String>[];
    final startTime = classData['startTime'] ?? '';
    final endTime = classData['endTime'] ?? '';
    final status = classData['status'] ?? '';
    final teacherName = classData['teacherName'] ?? '';
    final teacherId = classData['teacherIds'] != null &&
            (classData['teacherIds'] as List).isNotEmpty
        ? (classData['teacherIds'] as List).first
        : '';

    // show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enroll in $className'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Course: $course'),
              const SizedBox(height: 6),
              Text('Batch: $batch'),
              const SizedBox(height: 6),
              Text('Level: $level'),
              const SizedBox(height: 6),
              Text(
                  'Session: $academicYear ${semester.isNotEmpty ? ' • $semester' : ''}'),
              const SizedBox(height: 6),
              Text(
                  'Teacher: ${teacherName.isNotEmpty ? teacherName : teacherId}'),
              const SizedBox(height: 6),
              Text('Days: ${days.join(', ')}'),
              const SizedBox(height: 6),
              Text(
                  'Duration: ${startTime.isNotEmpty || endTime.isNotEmpty ? '$startTime - $endTime' : 'N/A'}'),
              const SizedBox(height: 6),
              Text('Seats left: $seatsLeft (Capacity: $capacity)'),
              const SizedBox(height: 6),
              Text('Status: $status'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Enroll')),
        ],
      ),
    );

    if (confirmed != true) return;

    // perform enrollment transaction
    final db = FirebaseFirestore.instance;
    final classRef = db.collection('classes').doc(classId);
    try {
      await db.runTransaction((tx) async {
        final snap = await tx.get(classRef);
        final map = snap.data() as Map<String, dynamic>;
        final current = List<String>.from(map['studentIds'] ?? []);
        final cap = (map['capacity'] as num?)?.toInt() ?? 0;
        if (current.contains(userId)) return;
        if (current.length >= cap) throw Exception('Class is full');
        current.add(userId);
        tx.update(classRef, {'studentIds': current});
        final enrollRef = db.collection('enrollments').doc();
        tx.set(enrollRef, {
          'uid': enrollRef.id,
          'classId': classId,
          'className': className,
          'batchName': batch,
          'studentId': userId,
          'teacherId': teacherId,
          'teacherName': teacherName,
          'course': course,
          'capacity': capacity,
          'level': level,
          'daysPerWeek': days,
          'startTime': startTime,
          'endTime': endTime,
          'academicYear': academicYear,
          'semester': semester,
          'status': 'enrolled',
          'mode': 'N/A',
          'createdAt': DateTime.now(),
        });
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enrolled successfully')));
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Enrollment failed: ${e.toString()}')));
      }
    }
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Text(value.isNotEmpty ? value : '—')),
      ],
    );
  }

  Future<void> _showEditProfileDialog() async {
    if (currentUser == null) return;
    final uid = currentUser!.uid;

    // initialize controllers with current values
    final firstNameCtrl =
        TextEditingController(text: userModel?.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: userModel?.lastName ?? '');
    final genderCtrl = TextEditingController(text: userModel?.gender ?? '');
    final schoolCtrl = TextEditingController(text: userModel?.schoolName ?? '');
    final classCtrl = TextEditingController(text: userModel?.classLevel ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameCtrl,
                  decoration: const InputDecoration(labelText: 'First name'),
                ),
                TextField(
                  controller: lastNameCtrl,
                  decoration: const InputDecoration(labelText: 'Last name'),
                ),
                TextField(
                  controller: genderCtrl,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: schoolCtrl,
                  decoration: const InputDecoration(labelText: 'School'),
                ),
                TextField(
                  controller: classCtrl,
                  decoration: const InputDecoration(labelText: 'Class'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'firstName': firstNameCtrl.text.trim(),
                    'lastName': lastNameCtrl.text.trim(),
                    'gender': genderCtrl.text.trim(),
                    'schoolName': schoolCtrl.text.trim(),
                    'classLevel': classCtrl.text.trim(),
                  });
                  Navigator.of(context).pop();
                  await _loadUserData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Update failed: ${e.toString()}')));
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // _buildStatCard removed — Quick Stats were removed from the UI.

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue[700]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context, {
    required String title,
    required String teacher,
    required String schedule,
    required int progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                teacher,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.blue[700]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$progress%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem({
    required String title,
    required String amount,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Profile menu items removed; helper removed accordingly.
}
