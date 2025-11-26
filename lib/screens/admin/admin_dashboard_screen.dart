import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          final studentCount =
              users.where((doc) => doc['role'] == 'student').length;
          final teacherCount =
              users.where((doc) => doc['role'] == 'teacher').length;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total Students'),
                    trailing: Text(studentCount.toString()),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Total Teachers'),
                    trailing: Text(teacherCount.toString()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
