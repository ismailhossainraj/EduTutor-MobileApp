import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/tuition_model.dart';

class SearchTutorScreen extends StatefulWidget {
  const SearchTutorScreen({Key? key}) : super(key: key);

  @override
  State<SearchTutorScreen> createState() => _SearchTutorScreenState();
}

class _SearchTutorScreenState extends State<SearchTutorScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Tutor')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tuitions')
            .where('status', whereIn: ['open', 'selected']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs
              .map(
                  (d) => TuitionModel.fromMap(d.data() as Map<String, dynamic>))
              .toList();

          if (items.isEmpty) {
            return const Center(child: Text('No tutors found'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final t = items[index];
              return Card(
                child: ListTile(
                  title: Text(t.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Email: ${t.email}'),
                      Text('Phone: ${t.phone}'),
                      Text('Qualification: ${t.qualification}'),
                      Text('Subject: ${t.interestedSubject}'),
                      Text('Days: ${t.days.join(', ')}'),
                      Text('Time: ${t.startTime} - ${t.endTime}'),
                      Text('Salary: ${t.salary}'),
                      Text('Status: ${t.status}'),
                    ],
                  ),
                  trailing: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('tuition_selections')
                        .doc('${t.uid}_${user?.uid}')
                        .get(),
                    builder: (context, snap) {
                      final exists = snap.hasData && snap.data!.exists;
                      // If already selected or tuition status is selected, show Selected
                      if (exists || t.status == 'selected') {
                        return const Text('Selected');
                      }

                      // Only allow selecting when tuition is open
                      final canSelect = t.status == 'open' && user != null;
                      return ElevatedButton(
                        onPressed: canSelect
                            ? () async {
                                final studentUid = user!.uid;
                                final selDocId = '${t.uid}_$studentUid';
                                final tuitionRef = FirebaseFirestore.instance
                                    .collection('tuitions')
                                    .doc(t.uid);
                                final selRef = FirebaseFirestore.instance
                                    .collection('tuition_selections')
                                    .doc(selDocId);

                                // Use transaction to avoid race conditions
                                try {
                                  await FirebaseFirestore.instance
                                      .runTransaction((tx) async {
                                    final tuitionSnap =
                                        await tx.get(tuitionRef);
                                    final currentStatus = tuitionSnap.exists
                                        ? (tuitionSnap.data()
                                            as Map<String, dynamic>)['status']
                                        : null;
                                    if (currentStatus != 'open') {
                                      throw Exception(
                                          'Tuition no longer available');
                                    }
                                    tx.set(selRef, {
                                      'uid': selRef.id,
                                      'tuitionId': t.uid,
                                      'studentId': studentUid,
                                      'teacherId': t.teacherId,
                                      'createdAt': DateTime.now(),
                                      'status': 'selected',
                                    });
                                    tx.update(
                                        tuitionRef, {'status': 'selected'});
                                  });
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Tutor selected')));
                                  setState(() {});
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              }
                            : null,
                        child: const Text('Select'),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
