class CourseMaterial {
  final String id;
  final String classId;
  final String teacherId;
  final String title;
  final String description;
  final String fileType; // pdf, video, image, link, notes
  final String fileUrl;
  final String downloadUrl;
  final DateTime uploadedAt;
  final String status; // published, draft, archived
  final List<String> accessibleToStudents; // student IDs or 'all'
  final int downloadCount;

  CourseMaterial({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.fileType,
    required this.fileUrl,
    required this.downloadUrl,
    required this.uploadedAt,
    required this.status,
    required this.accessibleToStudents,
    required this.downloadCount,
  });

  // Get file icon based on type
  String getFileIcon() {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'video':
        return '🎥';
      case 'image':
        return '🖼️';
      case 'link':
        return '🔗';
      case 'notes':
        return '📝';
      default:
        return '📦';
    }
  }

  // Check if material is accessible to student
  bool isAccessibleToStudent(String studentId) {
    return accessibleToStudents.contains('all') ||
        accessibleToStudents.contains(studentId);
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classId': classId,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'downloadUrl': downloadUrl,
      'uploadedAt': uploadedAt,
      'status': status,
      'accessibleToStudents': accessibleToStudents,
      'downloadCount': downloadCount,
    };
  }

  // Create from Firestore Map
  factory CourseMaterial.fromMap(Map<String, dynamic> map) {
    return CourseMaterial(
      id: map['id'] ?? '',
      classId: map['classId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      fileType: map['fileType'] ?? 'notes',
      fileUrl: map['fileUrl'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      uploadedAt: (map['uploadedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'published',
      accessibleToStudents:
          List<String>.from(map['accessibleToStudents'] ?? ['all']),
      downloadCount: map['downloadCount'] ?? 0,
    );
  }

  // Copy with method
  CourseMaterial copyWith({
    String? id,
    String? classId,
    String? teacherId,
    String? title,
    String? description,
    String? fileType,
    String? fileUrl,
    String? downloadUrl,
    DateTime? uploadedAt,
    String? status,
    List<String>? accessibleToStudents,
    int? downloadCount,
  }) {
    return CourseMaterial(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      accessibleToStudents: accessibleToStudents ?? this.accessibleToStudents,
      downloadCount: downloadCount ?? this.downloadCount,
    );
  }
}
