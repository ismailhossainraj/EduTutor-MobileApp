import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/tuition_model.dart';

class TuitionNeededScreen extends StatefulWidget {
  const TuitionNeededScreen({Key? key}) : super(key: key);

  @override
  State<TuitionNeededScreen> createState() => _TuitionNeededScreenState();
}

class _TuitionNeededScreenState extends State<TuitionNeededScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _qualificationCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  String _startTime = '';
  String _endTime = '';
  final Map<String, bool> _days = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _qualificationCtrl.dispose();
    _subjectCtrl.dispose();
    _salaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        final formatted = time.format(context);
        if (isStart) {
          _startTime = formatted;
        } else {
          _endTime = formatted;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    final tRef = FirebaseFirestore.instance.collection('tuitions').doc();

    // determine poster role from users collection so student posts are marked
    String posterRole = 'teacher';
    String posterId = user?.uid ?? '';
    try {
      if (user != null) {
        final uDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (uDoc.exists) {
          final u = uDoc.data() as Map<String, dynamic>;
          posterRole = (u['role'] ?? 'teacher').toString();
        }
      }
    } catch (_) {
      // ignore and default to teacher
    }

    // If a student posts, we don't populate teacherId. Teachers posting keep teacherId.
    final teacherId =
        posterRole.toLowerCase() == 'teacher' ? (user?.uid ?? '') : '';

    final tuition = TuitionModel(
      uid: tRef.id,
      teacherId: teacherId,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      qualification: _qualificationCtrl.text.trim(),
      interestedSubject: _subjectCtrl.text.trim(),
      days: _days.entries.where((e) => e.value).map((e) => e.key).toList(),
      startTime: _startTime,
      endTime: _endTime,
      salary: _salaryCtrl.text.trim(),
      status: 'open',
      createdAt: DateTime.now(),
    );

    // write tuition document and include poster metadata for student-posted requests
    final data = tuition.toMap();
    data['posterRole'] = posterRole.toLowerCase();
    data['posterId'] = posterId;
    await tRef.set(data);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tuition posted')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tuition Needed')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter name' : null),
                TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter email' : null),
                TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter phone' : null),
                TextFormField(
                    controller: _qualificationCtrl,
                    decoration: const InputDecoration(labelText: 'Class')),
                TextFormField(
                    controller: _subjectCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Interested Subject')),
                const SizedBox(height: 10),
                Text('Days per week',
                    style: Theme.of(context).textTheme.titleSmall),
                Wrap(
                  spacing: 8,
                  children: _days.keys.map((d) {
                    return FilterChip(
                        label: Text(d),
                        selected: _days[d]!,
                        onSelected: (sel) {
                          setState(() {
                            _days[d] = sel;
                          });
                        });
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  ElevatedButton(
                      onPressed: () => _pickTime(context, true),
                      child:
                          Text(_startTime.isEmpty ? 'Start time' : _startTime)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => _pickTime(context, false),
                      child: Text(_endTime.isEmpty ? 'End time' : _endTime)),
                ]),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _salaryCtrl,
                    decoration: const InputDecoration(labelText: 'Salary')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: 'open',
                  items: const [
                    DropdownMenuItem(value: 'open', child: Text('Open')),
                    DropdownMenuItem(
                        value: 'selected', child: Text('Selected')),
                    DropdownMenuItem(value: 'closed', child: Text('Closed')),
                  ],
                  onChanged: (v) {},
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _submit, child: const Text('Post Tuition')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
