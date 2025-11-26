// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null || user.role != UserRole.teacher) {
      return Scaffold(
        appBar: AppBar(title: const Text('Teacher Profile')),
        body: const Center(child: Text('No teacher profile found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Profile'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture with animation
            Center(
              child: Hero(
                tag: "teacher-profile-pic",
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      const AssetImage('assets/images/teacher.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name & Email
            Text(
              user.fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Details Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                        Icons.school, "Education level", user.educationLevel ?? "N/A"),
                    Divider(),
                    _buildInfoRow(Icons.person, "Gender", user.gender ?? "N/A"),
                    Divider(),
                    _buildInfoRow(Icons.star, "Role", "Teacher"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Attractive Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to edit profile
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text("Edit Profile", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Row
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Text(
          "$title: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
