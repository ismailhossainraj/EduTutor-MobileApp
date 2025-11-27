import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/class_model.dart';

class CreateClassScreen extends StatefulWidget {
  final ClassModel? existing;
  const CreateClassScreen({Key? key, this.existing}) : super(key: key);

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _subject = TextEditingController();
  final _capacity = TextEditingController(text: '30');
  String _level = 'secondary';
  final _academicYear = TextEditingController();
  final _semester = TextEditingController();
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _className.text = e.className;
      _subject.text = e.subject;
      _capacity.text = e.capacity.toString();
      _level = e.level;
      _academicYear.text = e.academicYear;
      _semester.text = e.semester;
      _status = e.status;
    }
  }

  @override
  void dispose() {
    _className.dispose();
    _subject.dispose();
    _capacity.dispose();
    _academicYear.dispose();
    _semester.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cap = int.tryParse(_capacity.text) ?? 0;
    final map = {
      'className': _className.text.trim(),
      'subject': _subject.text.trim(),
      'capacity': cap,
      'level': _level,
      'createdAt': DateTime.now(),
      'studentIds': <String>[],
      'teacherIds': <String>[],
      'status': _status,
      'academicYear': _academicYear.text.trim(),
      'semester': _semester.text.trim(),
    };

    final col = FirebaseFirestore.instance.collection('classes');
    if (widget.existing != null && widget.existing!.id.isNotEmpty) {
      await col.doc(widget.existing!.id).set(map, SetOptions(merge: true));
    } else {
      await col.add(map);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Create Class' : 'Edit Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _className,
                decoration: const InputDecoration(labelText: 'Class Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subject,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _capacity,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: const InputDecoration(labelText: 'Level'),
                items: [
                  'primary',
                  'secondary',
                  'senior_secondary',
                ].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (v) => setState(() => _level = v ?? _level),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _academicYear,
                decoration: const InputDecoration(labelText: 'Academic Year'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _semester,
                decoration: const InputDecoration(labelText: 'Semester'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['active', 'inactive', 'archived']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Save Class'))
            ],
          ),
        ),
      ),
    );
  }
}
