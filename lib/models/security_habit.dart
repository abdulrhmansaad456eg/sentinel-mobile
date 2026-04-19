class SecurityHabit {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final List<DateTime> completedDates;
  final int targetDaysPerWeek;
  final bool isActive;

  SecurityHabit({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.completedDates,
    required this.targetDaysPerWeek,
    required this.isActive,
  });

  factory SecurityHabit.fromJson(Map<String, dynamic> json) {
    return SecurityHabit(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      completedDates: (json['completedDates'] as List<dynamic>? ?? [])
          .map((e) => DateTime.parse(e))
          .toList(),
      targetDaysPerWeek: json['targetDaysPerWeek'] ?? 7,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((e) => e.toIso8601String()).toList(),
      'targetDaysPerWeek': targetDaysPerWeek,
      'isActive': isActive,
    };
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    
    final sorted = completedDates..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime checkDate = DateTime.now();
    
    for (final date in sorted) {
      if (isSameDay(date, checkDate) || isSameDay(date, checkDate.subtract(const Duration(days: 1)))) {
        if (isSameDay(date, checkDate.subtract(Duration(days: streak)))) {
          streak++;
        }
      } else {
        break;
      }
    }
    
    return streak;
  }

  bool get isCompletedToday {
    return completedDates.any((date) => isSameDay(date, DateTime.now()));
  }

  int getCompletionCountForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return completedDates.where((date) => 
      date.isAfter(weekStart.subtract(const Duration(days: 1))) && 
      date.isBefore(weekEnd)
    ).length;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  SecurityHabit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<DateTime>? completedDates,
    int? targetDaysPerWeek,
    bool? isActive,
  }) {
    return SecurityHabit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      isActive: isActive ?? this.isActive,
    );
  }
}
