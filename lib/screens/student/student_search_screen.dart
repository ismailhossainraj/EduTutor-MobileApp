import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../teacher/teacher_details_screen.dart';

class StudentSearchScreen extends StatefulWidget {
  const StudentSearchScreen({Key? key}) : super(key: key);

  @override
  StudentSearchScreenState createState() => StudentSearchScreenState();
}

class StudentSearchScreenState extends State<StudentSearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final student = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Teachers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by subject',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'teacher')
                    .where('searchableSubjects', arrayContains: _searchQuery)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final teachers = snapshot.data!.docs
                      .map((doc) => UserModel.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .where((teacher) {
                    if (_searchQuery.isEmpty) {
                      return true;
                    }
                    return teacher.subjects?.any((subject) {
                      final subjectMatches = subject['subject']
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                      final classFrom = subject['class_from'] ?? 0;
                      final classTo = subject['class_to'] ?? 0;
                      final studentClass =
                          int.tryParse(student?.classLevel ?? '0') ?? 0;
                      final classMatches =
                          studentClass >= classFrom && studentClass <= classTo;
                      return subjectMatches && classMatches;
                    }) ?? false;
                  }).toList();

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
