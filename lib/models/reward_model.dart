class Reward {
  final String id;
  final String studentId;
  final String type; // points, badges, performance_level
  final String title;
  final String description;
  final int pointsEarned;
  final DateTime earnedAt;
  final String category; // academic, attendance, participation
  final String? imageUrl;
  final bool isShared;

  Reward({
    required this.id,
    required this.studentId,
    required this.type,
    required this.title,
    required this.description,
    required this.pointsEarned,
    required this.earnedAt,
    required this.category,
    this.imageUrl,
    required this.isShared,
  });

  // Get reward icon/emoji
  String getRewardEmoji() {
    switch (type) {
      case 'badges':
        return '🏅';
      case 'points':
        return '⭐';
      case 'performance_level':
        return '🎖️';
      default:
        return '🎁';
    }
  }

  // Get category color
  String getCategoryColor() {
    switch (category) {
      case 'academic':
        return '#4CAF50'; // Green
      case 'attendance':
        return '#2196F3'; // Blue
      case 'participation':
        return '#FF9800'; // Orange
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'type': type,
      'title': title,
      'description': description,
      'pointsEarned': pointsEarned,
      'earnedAt': earnedAt,
      'category': category,
      'imageUrl': imageUrl,
      'isShared': isShared,
    };
  }

  // Create from Firestore Map
  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      type: map['type'] ?? 'points',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pointsEarned: map['pointsEarned'] ?? 0,
      earnedAt: (map['earnedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      category: map['category'] ?? 'academic',
      imageUrl: map['imageUrl'],
      isShared: map['isShared'] ?? false,
    );
  }

  // Copy with method
  Reward copyWith({
    String? id,
    String? studentId,
    String? type,
    String? title,
    String? description,
    int? pointsEarned,
    DateTime? earnedAt,
    String? category,
    String? imageUrl,
    bool? isShared,
  }) {
    return Reward(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      earnedAt: earnedAt ?? this.earnedAt,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isShared: isShared ?? this.isShared,
    );
  }
}

class ProgressReport {
  final String id;
  final String studentId;
  final double overallScore;
  final String performanceLevel; // excellent, good, average, needs_improvement
  final int totalTests;
  final int passedTests;
  final double averageScore;
  final DateTime generatedDate;
  final Map<String, double> subjectScores;
  final List<Reward> recentRewards;

  ProgressReport({
    required this.id,
    required this.studentId,
    required this.overallScore,
    required this.performanceLevel,
    required this.totalTests,
    required this.passedTests,
    required this.averageScore,
    required this.generatedDate,
    required this.subjectScores,
    required this.recentRewards,
  });

  // Get performance level color
  String getPerformanceColor() {
    switch (performanceLevel) {
      case 'excellent':
        return '#4CAF50'; // Green
      case 'good':
        return '#8BC34A'; // Light Green
      case 'average':
        return '#FFC107'; // Amber
      case 'needs_improvement':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Get pass percentage
  double getPassPercentage() {
    if (totalTests == 0) return 0;
    return (passedTests / totalTests) * 100;
  }

  // Get performance emoji
  String getPerformanceEmoji() {
    switch (performanceLevel) {
      case 'excellent':
        return '🌟';
      case 'good':
        return '👍';
      case 'average':
        return '👌';
      case 'needs_improvement':
        return '📚';
      default:
        return '📊';
    }
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'overallScore': overallScore,
      'performanceLevel': performanceLevel,
      'totalTests': totalTests,
      'passedTests': passedTests,
      'averageScore': averageScore,
      'generatedDate': generatedDate,
      'subjectScores': subjectScores,
      'recentRewards': recentRewards.map((r) => r.toMap()).toList(),
    };
  }

  // Create from Firestore Map
  factory ProgressReport.fromMap(Map<String, dynamic> map) {
    return ProgressReport(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      overallScore: (map['overallScore'] ?? 0).toDouble(),
      performanceLevel: map['performanceLevel'] ?? 'average',
      totalTests: map['totalTests'] ?? 0,
      passedTests: map['passedTests'] ?? 0,
      averageScore: (map['averageScore'] ?? 0).toDouble(),
      generatedDate:
          (map['generatedDate'] as dynamic)?.toDate() ?? DateTime.now(),
      subjectScores: Map<String, double>.from(
        (map['subjectScores'] as Map?)?.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ) ??
            {},
      ),
      recentRewards: (map['recentRewards'] as List?)
              ?.map((r) => Reward.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Copy with method
  ProgressReport copyWith({
    String? id,
    String? studentId,
    double? overallScore,
    String? performanceLevel,
    int? totalTests,
    int? passedTests,
    double? averageScore,
    DateTime? generatedDate,
    Map<String, double>? subjectScores,
    List<Reward>? recentRewards,
  }) {
    return ProgressReport(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      overallScore: overallScore ?? this.overallScore,
      performanceLevel: performanceLevel ?? this.performanceLevel,
      totalTests: totalTests ?? this.totalTests,
      passedTests: passedTests ?? this.passedTests,
      averageScore: averageScore ?? this.averageScore,
      generatedDate: generatedDate ?? this.generatedDate,
      subjectScores: subjectScores ?? this.subjectScores,
      recentRewards: recentRewards ?? this.recentRewards,
    );
  }
}
