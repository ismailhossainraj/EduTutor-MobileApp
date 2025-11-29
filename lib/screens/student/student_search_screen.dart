import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
// removed unused provider import and auth provider since search/filter removed
import '../teacher/teacher_details_screen.dart';

class StudentSearchScreen extends StatefulWidget {
  const StudentSearchScreen({Key? key}) : super(key: key);

  @override
  StudentSearchScreenState createState() => StudentSearchScreenState();
}

class StudentSearchScreenState extends State<StudentSearchScreen> {
  @override
  Widget build(BuildContext context) {
    // no auth-specific filtering needed for this list

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Teachers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 'Search by subject' removed per request. Showing all teachers.
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'teacher')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final teachers = snapshot.data!.docs
                      .map((doc) =>
                          UserModel.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      final subjects = teacher.subjects
                              ?.map((s) => s['subject'])
                              .join(', ') ??
                          '';
                      return ListTile(
                        title: Text(teacher.fullName),
                        subtitle: Text(subjects),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherDetailsScreen(
                                teacher: teacher,
                              ),
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
      ),
    );
  }
}
