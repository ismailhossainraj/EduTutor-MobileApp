import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassEnrollmentsScreen extends StatelessWidget {
  const ClassEnrollmentsScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _loadStudentsForClass(
      List<dynamic> ids) async {
    final db = FirebaseFirestore.instance;
    final List<Map<String, dynamic>> result = [];
    for (final id in ids) {
      try {
        final doc = await db.collection('users').doc(id as String).get();
        if (doc.exists) {
          result.add({'id': doc.id, ...doc.data()!});
        }
      } catch (_) {
        // ignore individual failures
      }
    }
    return result;
  }

  void _showStudentList(
      BuildContext context, List<dynamic> ids, String className) async {
    final students = await _loadStudentsForClass(ids);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Enrolled students — $className'),
        content: SizedBox(
          width: double.maxFinite,
          child: students.isEmpty
              ? const Text('No students enrolled yet.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (_, i) {
                    final s = students[i];
                    return ListTile(
                      title: Text(s['fullName'] ??
                          s['displayName'] ??
                          s['email'] ??
                          s['id'] ??
                          'Student'),
                      subtitle: Text(s['email'] ?? ''),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Enrollments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No classes found.'));
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final d = docs[index];
              final data = d.data() as Map<String, dynamic>;
              final name = data['className'] ?? data['subject'] ?? 'Class';
              final capacity = (data['capacity'] as num?)?.toInt() ?? 0;
              final students = List<String>.from(data['studentIds'] ?? []);
              return ListTile(
                title: Text('$name'),
                subtitle: Text('Enrolled: ${students.length} / $capacity'),
                trailing: IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () => _showStudentList(context, students, name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
