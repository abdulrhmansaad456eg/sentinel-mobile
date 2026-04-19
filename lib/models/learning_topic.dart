class LearningTopic {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String category;
  final int difficulty;
  final int estimatedMinutes;
  final List<String> contentSections;
  final bool isCompleted;

  LearningTopic({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.contentSections,
    this.isCompleted = false,
  });

  factory LearningTopic.fromJson(Map<String, dynamic> json) {
    return LearningTopic(
      id: json['id'] ?? '',
      titleKey: json['titleKey'] ?? '',
      descriptionKey: json['descriptionKey'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      estimatedMinutes: json['estimatedMinutes'] ?? 5,
      contentSections: List<String>.from(json['contentSections'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'category': category,
      'difficulty': difficulty,
      'estimatedMinutes': estimatedMinutes,
      'contentSections': contentSections,
      'isCompleted': isCompleted,
    };
  }

  LearningTopic copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? category,
    int? difficulty,
    int? estimatedMinutes,
    List<String>? contentSections,
    bool? isCompleted,
  }) {
    return LearningTopic(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      contentSections: contentSections ?? this.contentSections,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class LearningProgress {
  final String userId;
  final Map<String, bool> completedTopics;
  final int totalTimeSpentMinutes;
  final DateTime lastActivity;

  LearningProgress({
    required this.userId,
    required this.completedTopics,
    required this.totalTimeSpentMinutes,
    required this.lastActivity,
  });

  factory LearningProgress.fromJson(Map<String, dynamic> json) {
    return LearningProgress(
      userId: json['userId'] ?? '',
      completedTopics: Map<String, bool>.from(json['completedTopics'] ?? {}),
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'] ?? 0,
      lastActivity: DateTime.parse(json['lastActivity'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'completedTopics': completedTopics,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  int get completedCount => completedTopics.values.where((v) => v).length;
}
