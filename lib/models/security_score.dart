class SecurityScore {
  final int score;
  final String status;
  final DateTime lastUpdated;
  final Map<String, int> categoryScores;

  SecurityScore({
    required this.score,
    required this.status,
    required this.lastUpdated,
    required this.categoryScores,
  });

  factory SecurityScore.fromJson(Map<String, dynamic> json) {
    return SecurityScore(
      score: json['score'] ?? 0,
      status: json['status'] ?? 'poor',
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      categoryScores: Map<String, int>.from(json['categoryScores'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
      'categoryScores': categoryScores,
    };
  }

  SecurityScore copyWith({
    int? score,
    String? status,
    DateTime? lastUpdated,
    Map<String, int>? categoryScores,
  }) {
    return SecurityScore(
      score: score ?? this.score,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      categoryScores: categoryScores ?? this.categoryScores,
    );
  }
}
