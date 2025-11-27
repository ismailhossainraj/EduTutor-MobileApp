class ClassModel {
  final String id;
  final String className; // e.g., "Class 10-A"
  final String subject;
  final int capacity; // Total student capacity
  final String level; // primary, secondary, senior_secondary
  final DateTime createdAt;
  final List<String> studentIds;
  final List<String> teacherIds;
  final String status; // active, inactive, archived
  final String academicYear;
  final String semester;

  ClassModel({
    required this.id,
    required this.className,
    required this.subject,
    required this.capacity,
    required this.level,
    required this.createdAt,
    required this.studentIds,
    required this.teacherIds,
    required this.status,
    required this.academicYear,
    required this.semester,
  });

  // Get current enrollment count
  int getCurrentEnrollment() {
    return studentIds.length;
  }

  // Check if class has capacity
  bool hasCapacity() {
    return getCurrentEnrollment() < capacity;
  }

  // Get available seats
  int getAvailableSeats() {
    return capacity - getCurrentEnrollment();
  }

  // Get enrollment percentage
  double getEnrollmentPercentage() {
    if (capacity == 0) return 0;
    return (getCurrentEnrollment() / capacity) * 100;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'subject': subject,
      'capacity': capacity,
      'level': level,
      'createdAt': createdAt,
      'studentIds': studentIds,
      'teacherIds': teacherIds,
      'status': status,
      'academicYear': academicYear,
      'semester': semester,
    };
  }

  // Create from Firestore Map
  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      className: map['className'] ?? '',
      subject: map['subject'] ?? '',
      capacity: map['capacity'] ?? 0,
      level: map['level'] ?? 'secondary',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      studentIds: List<String>.from(map['studentIds'] ?? []),
      teacherIds: List<String>.from(map['teacherIds'] ?? []),
      status: map['status'] ?? 'active',
      academicYear: map['academicYear'] ?? '',
      semester: map['semester'] ?? '',
    );
  }

  // Copy with method
  ClassModel copyWith({
    String? id,
    String? className,
    String? subject,
    int? capacity,
    String? level,
    DateTime? createdAt,
    List<String>? studentIds,
    List<String>? teacherIds,
    String? status,
    String? academicYear,
    String? semester,
  }) {
    return ClassModel(
      id: id ?? this.id,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      capacity: capacity ?? this.capacity,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      studentIds: studentIds ?? this.studentIds,
      teacherIds: teacherIds ?? this.teacherIds,
      status: status ?? this.status,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
    );
  }
}
