import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/schedule_model.dart';

class ClassScheduleScreen extends StatefulWidget {
  const ClassScheduleScreen({super.key});

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  String? _batch;

  @override
  void initState() {
    super.initState();
    _loadStudentBatch();
  }

  Future<List<ClassSchedule>> _loadLocalSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('dev_schedules') ?? <String>[];
    final List<ClassSchedule> result = [];
    for (final item in raw) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        // parse ISO strings back to DateTime
        if (map['startTime'] is String) {
          map['startTime'] = DateTime.parse(map['startTime']);
        }
        if (map['endTime'] is String) {
          map['endTime'] = DateTime.parse(map['endTime']);
        }
        result.add(ClassSchedule.fromMap(map));
      } catch (_) {
        // ignore malformed local entries
      }
    }
    return result;
  }

  Future<void> _loadStudentBatch() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _batch = doc.data()?['classLevel'] ?? doc.data()?['batchName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _batch == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              // NOTE: ordering on a different field than the where() clause
              // requires a composite index in Firestore. To avoid runtime
              // index errors during development, we fetch the filtered
              // documents and sort them client-side by weekday and start time.
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .where('batchName', isEqualTo: _batch)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final err = snapshot.error.toString();
                  if (err.contains('permission-denied')) {
                    // Try to load local dev schedules as a fallback when Firestore
                    // permissions prevent reading the schedules collection.
                    return FutureBuilder<List<ClassSchedule>>(
                      future: _loadLocalSchedules(),
                      builder: (context, localSnap) {
                        if (localSnap.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final local = localSnap.data ?? [];
                        if (local.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_outline,
                                    size: 48, color: Colors.red),
                                SizedBox(height: 8),
                                Text('Access denied.'),
                                SizedBox(height: 6),
                                Text(
                                    'No local schedules found. Ask admin to publish schedules.'),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: local.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final s = local[index];
                            return ListTile(
                              title: Text('Batch: ${s.batchName}'),
                              subtitle: Text(
                                  'Course: ${s.subject}\nTime: ${s.dayOfWeek} ${s.getFormattedTime()}\nTeacher: ${s.teacherName}'),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No schedule available.'));
                }

                // Map documents to models
                final schedules = docs
                    .map((d) => ClassSchedule.fromMap(
                        {...d.data() as Map<String, dynamic>, 'id': d.id}))
                    .toList();

                // Client-side sort order for weekdays
                const weekdayOrder = {
                  'Monday': 1,
                  'Tuesday': 2,
                  'Wednesday': 3,
                  'Thursday': 4,
                  'Friday': 5,
                  'Saturday': 6,
                  'Sunday': 7,
                };

                schedules.sort((a, b) {
                  final ai = weekdayOrder[a.dayOfWeek] ?? 99;
                  final bi = weekdayOrder[b.dayOfWeek] ?? 99;
                  if (ai != bi) return ai.compareTo(bi);
                  // If same weekday, sort by start time
                  return a.startTime.compareTo(b.startTime);
                });

                return ListView.separated(
                  itemCount: schedules.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = schedules[index];
                    return ListTile(
                      title: Text(s.subject),
                      subtitle: Text(
                          '${s.dayOfWeek} • ${s.getFormattedTime()} • ${s.teacherName} • Room ${s.roomNumber}'),
                    );
                  },
                );
              },
            ),
    );
  }
}
