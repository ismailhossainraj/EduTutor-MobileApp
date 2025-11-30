import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../teacher/teacher_details_screen.dart';
import 'student_details_screen.dart';
import '../../models/user_model.dart';

class UserListScreen extends StatelessWidget {
  final String role; // 'student' or 'teacher'
  final String title;

  const UserListScreen({Key? key, required this.role, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: role)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData)
            // ignore: curly_braces_in_flow_control_structures
            return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          final count = docs.length;
          if (docs.isEmpty) return Center(child: Text('No $title found.'));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('$title — $count',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final d = docs[index];
                    final map = d.data() as Map<String, dynamic>;
                    final firstName = map['firstName'] ?? '';
                    final lastName = map['lastName'] ?? '';
                    final composedName =
                        '${firstName.toString()} ${lastName.toString()}'.trim();
                    final name = composedName.isNotEmpty
                        ? composedName
                        : (map['fullName'] ?? map['displayName'] ?? d.id)
                            .toString();
                    final email = (map['email'] ?? '').toString();

                    // Student-specific
                    final studentClass =
                        (map['classLevel'] ?? map['class'] ?? '').toString();

                    // Teacher-specific
                    final phone =
                        (map['phoneNumber'] ?? map['phone'] ?? '').toString();
                    final university = (map['university'] ?? '').toString();
                    final interest =
                        (map['interest'] ?? map['interestedSubject'] ?? '')
                            .toString();

                    return ListTile(
                      onTap: () {
                        // Build a map copy including uid so UserModel.fromMap picks it up
                        final data = Map<String, dynamic>.from(map);
                        data.putIfAbsent('uid', () => d.id);
                        final userModel = UserModel.fromMap(data);
                        if (role == 'teacher') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                TeacherDetailsScreen(teacherUid: userModel.uid),
                          ));
                        } else if (role == 'student') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                StudentDetailsScreen(student: userModel),
                          ));
                        }
                      },
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (email.isNotEmpty) Text(email),
                          if (role == 'student' && studentClass.isNotEmpty)
                            Text('Class: $studentClass'),
                          if (role == 'teacher') ...[
                            if (phone.isNotEmpty) Text('Phone: $phone'),
                            if (university.isNotEmpty)
                              Text('University: $university'),
                            if (interest.isNotEmpty)
                              Text('Interested: $interest'),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
