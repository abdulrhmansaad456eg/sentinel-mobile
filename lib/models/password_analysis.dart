class PasswordAnalysis {
  final String password;
  final int score;
  final String strength;
  final List<String> suggestions;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumbers;
  final bool hasSpecialChars;
  final int length;
  final DateTime analyzedAt;

  PasswordAnalysis({
    required this.password,
    required this.score,
    required this.strength,
    required this.suggestions,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumbers,
    required this.hasSpecialChars,
    required this.length,
    required this.analyzedAt,
  });

  factory PasswordAnalysis.fromJson(Map<String, dynamic> json) {
    return PasswordAnalysis(
      password: json['password'] ?? '',
      score: json['score'] ?? 0,
      strength: json['strength'] ?? 'very_weak',
      suggestions: List<String>.from(json['suggestions'] ?? []),
      hasUppercase: json['hasUppercase'] ?? false,
      hasLowercase: json['hasLowercase'] ?? false,
      hasNumbers: json['hasNumbers'] ?? false,
      hasSpecialChars: json['hasSpecialChars'] ?? false,
      length: json['length'] ?? 0,
      analyzedAt: DateTime.parse(json['analyzedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'score': score,
      'strength': strength,
      'suggestions': suggestions,
      'hasUppercase': hasUppercase,
      'hasLowercase': hasLowercase,
      'hasNumbers': hasNumbers,
      'hasSpecialChars': hasSpecialChars,
      'length': length,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }
}
