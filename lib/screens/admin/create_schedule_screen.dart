import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/schedule_model.dart';

class CreateScheduleScreen extends StatefulWidget {
  final ClassSchedule? existing;
  const CreateScheduleScreen({Key? key, this.existing}) : super(key: key);

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _teacherNameController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  String _day = 'Monday';
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);
  String _status = 'scheduled';

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _batchController.text = existing.batchName;
      _subjectController.text = existing.subject;
      _teacherNameController.text = existing.teacherName;
      _teacherIdController.text = existing.teacherId;
      _roomController.text = existing.roomNumber;
      _day = existing.dayOfWeek;
      _status = existing.status;
      _start = TimeOfDay.fromDateTime(existing.startTime);
      _end = TimeOfDay.fromDateTime(existing.endTime);
    }
  }

  @override
  void dispose() {
    _batchController.dispose();
    _subjectController.dispose();
    _teacherNameController.dispose();
    _teacherIdController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(context: context, initialTime: _start);
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(context: context, initialTime: _end);
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final startDate = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day,
        _start.hour, _start.minute);
    final end = DateTime(
        startDate.year, startDate.month, startDate.day, _end.hour, _end.minute);

    final map = {
      'batchName': _batchController.text.trim(),
      'subject': _subjectController.text.trim(),
      'teacherName': _teacherNameController.text.trim(),
      'teacherId': _teacherIdController.text.trim(),
      'startTime': start,
      'endTime': end,
      'roomNumber': _roomController.text.trim(),
      'status': _status,
      'dayOfWeek': _day,
    };

    final col = FirebaseFirestore.instance.collection('schedules');
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
        title:
            Text(widget.existing == null ? 'Create Schedule' : 'Edit Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _batchController,
                decoration: const InputDecoration(labelText: 'Batch'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration:
                    const InputDecoration(labelText: 'Subject / Course'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _teacherNameController,
                      decoration:
                          const InputDecoration(labelText: 'Teacher Name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _teacherIdController,
                      decoration:
                          const InputDecoration(labelText: 'Teacher ID'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _day,
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ]
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _day = v ?? _day),
                decoration: const InputDecoration(labelText: 'Day of Week'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: ListTile(
                          title: const Text('Start'),
                          subtitle: Text(_start.format(context)),
                          onTap: _pickStart)),
                  Expanded(
                      child: ListTile(
                          title: const Text('End'),
                          subtitle: Text(_end.format(context)),
                          onTap: _pickEnd)),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _status,
                items: ['scheduled', 'ongoing', 'completed', 'cancelled']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _save, child: const Text('Save Schedule'))
            ],
          ),
        ),
      ),
    );
  }
}
