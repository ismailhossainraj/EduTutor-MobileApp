class ClassSchedule {
  final String id;
  final String classId;
  final String subject;
  final String teacherName;
  final String teacherId;
  final DateTime startTime;
  final DateTime endTime;
  final String roomNumber;
  final String status; // scheduled, ongoing, completed, cancelled
  final String dayOfWeek; // Monday, Tuesday, etc.
  final String batchName;

  ClassSchedule({
    required this.id,
    required this.classId,
    required this.subject,
    required this.teacherName,
    required this.teacherId,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.status,
    required this.dayOfWeek,
    required this.batchName,
  });

  // Get formatted time
  String getFormattedTime() {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  // Get duration in minutes
  int getDurationInMinutes() {
    return endTime.difference(startTime).inMinutes;
  }

  // Check if class is ongoing
  bool isOngoing() {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  // Check if class is upcoming
  bool isUpcoming() {
    return DateTime.now().isBefore(startTime) && status != 'cancelled';
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'subject': subject,
      'teacherName': teacherName,
      'teacherId': teacherId,
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
      'status': status,
      'dayOfWeek': dayOfWeek,
      'batchName': batchName,
    };
  }

  // Create from Firestore Map
  factory ClassSchedule.fromMap(Map<String, dynamic> map) {
    return ClassSchedule(
      id: map['id'] ?? '',
      classId: map['classId'] ?? '',
      subject: map['subject'] ?? '',
      teacherName: map['teacherName'] ?? '',
      teacherId: map['teacherId'] ?? '',
      startTime: (map['startTime'] as dynamic)?.toDate() ?? DateTime.now(),
      endTime: (map['endTime'] as dynamic)?.toDate() ?? DateTime.now(),
      roomNumber: map['roomNumber'] ?? '',
      status: map['status'] ?? 'scheduled',
      dayOfWeek: map['dayOfWeek'] ?? '',
      batchName: map['batchName'] ?? '',
    );
  }

  // Copy with method
  ClassSchedule copyWith({
    String? id,
    String? classId,
    String? subject,
    String? teacherName,
    String? teacherId,
    DateTime? startTime,
    DateTime? endTime,
    String? roomNumber,
    String? status,
    String? dayOfWeek,
    String? batchName,
  }) {
    return ClassSchedule(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      subject: subject ?? this.subject,
      teacherName: teacherName ?? this.teacherName,
      teacherId: teacherId ?? this.teacherId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      roomNumber: roomNumber ?? this.roomNumber,
      status: status ?? this.status,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      batchName: batchName ?? this.batchName,
    );
  }
}
