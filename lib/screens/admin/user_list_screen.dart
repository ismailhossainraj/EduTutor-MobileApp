import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                    final name = map['fullName'] ??
                        map['displayName'] ??
                        map['firstName'] ??
                        '';
                    final email = map['email'] ?? '';
                    return ListTile(
                      title: Text(name.isNotEmpty ? name : d.id),
                      subtitle: Text(email),
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
