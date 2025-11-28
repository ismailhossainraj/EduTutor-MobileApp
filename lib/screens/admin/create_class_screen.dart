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
  final _batch = TextEditingController();
  final _courseName = TextEditingController();
  final _capacity = TextEditingController(text: '30');
  String _level = 'secondary';
  final _teacherName = TextEditingController();
  final Set<String> _daysSelected = <String>{};
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _session = TextEditingController();
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _className.text = e.className;
      _courseName.text = e.subject;
      _capacity.text = e.capacity.toString();
      _level = e.level;
      _teacherName.text = e.teacherIds.isNotEmpty ? (e.teacherIds.first) : '';
      _session.text = e.academicYear;
      _status = e.status;
    }
  }

  @override
  void dispose() {
    _className.dispose();
    _batch.dispose();
    _courseName.dispose();
    _capacity.dispose();
    _teacherName.dispose();
    _session.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cap = int.tryParse(_capacity.text) ?? 0;
    final map = {
      'className': _className.text.trim(),
      'batchName': _batch.text.trim(),
      'courseName': _courseName.text.trim(),
      'capacity': cap,
      'level': _level,
      'teacherName': _teacherName.text.trim(),
      'daysPerWeek': _daysSelected.toList(),
      'startTime': _startTime != null
          ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'endTime': _endTime != null
          ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'createdAt': DateTime.now(),
      'studentIds': <String>[],
      'teacherIds': <String>[],
      'status': _status,
      'session': _session.text.trim(),
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
                controller: _batch,
                decoration: const InputDecoration(labelText: 'Batch'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _courseName,
                decoration: const InputDecoration(labelText: 'Course Name'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _teacherName,
                decoration: const InputDecoration(labelText: 'Teacher Name'),
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
                  {'label': 'Secondary', 'value': 'secondary'},
                  {'label': 'Higher Secondary', 'value': 'higher_secondary'},
                  {'label': 'Other', 'value': 'other'},
                ]
                    .map((l) => DropdownMenuItem(
                        value: l['value'], child: Text(l['label']!)))
                    .toList(),
                onChanged: (v) => setState(() => _level = v ?? _level),
              ),
              const SizedBox(height: 12),
              const Text("Days per Week",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map((d) => FilterChip(
                          label: Text(d),
                          selected: _daysSelected.contains(d),
                          onSelected: (sel) => setState(() {
                            if (sel) {
                              _daysSelected.add(d);
                            } else {
                              _daysSelected.remove(d);
                            }
                          }),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              const Text("Duration",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final t = await showTimePicker(
                            context: context,
                            initialTime: _startTime ??
                                const TimeOfDay(hour: 9, minute: 0));
                        if (t != null) setState(() => _startTime = t);
                      },
                      child: Text(_startTime == null
                          ? 'Start Time'
                          : _startTime!.format(context)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final t = await showTimePicker(
                            context: context,
                            initialTime: _endTime ??
                                const TimeOfDay(hour: 10, minute: 0));
                        if (t != null) setState(() => _endTime = t);
                      },
                      child: Text(_endTime == null
                          ? 'End Time'
                          : _endTime!.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _session,
                decoration: const InputDecoration(labelText: 'Session'),
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
