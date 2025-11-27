import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_schedule_screen.dart';
import '../../models/schedule_model.dart';

class ScheduleManagerScreen extends StatelessWidget {
  const ScheduleManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Manager'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('schedules')
            .orderBy('dayOfWeek')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No schedules yet.'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final schedule =
                  ClassSchedule.fromMap({...data, 'id': docs[index].id});
              return ListTile(
                title: Text('${schedule.subject} — ${schedule.batchName}'),
                subtitle: Text(
                    '${schedule.dayOfWeek} • ${schedule.getFormattedTime()} • ${schedule.teacherName}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CreateScheduleScreen(existing: schedule)));
                  },
                ),
                onTap: () {
                  // maybe show details
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text(schedule.subject),
                            content: Text(
                                'Batch: ${schedule.batchName}\nTeacher: ${schedule.teacherName}\nRoom: ${schedule.roomNumber}\nTime: ${schedule.getFormattedTime()}'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'))
                            ],
                          ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreateScheduleScreen())),
        tooltip: 'Create Schedule',
        child: const Icon(Icons.add),
      ),
    );
  }
}
