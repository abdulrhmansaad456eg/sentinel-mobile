class ThreatCheck {
  final String id;
  final DateTime checkedAt;
  final bool threatsFound;
  final List<ThreatItem> threats;
  final List<String> recommendations;
  final int overallRiskLevel;

  ThreatCheck({
    required this.id,
    required this.checkedAt,
    required this.threatsFound,
    required this.threats,
    required this.recommendations,
    required this.overallRiskLevel,
  });

  factory ThreatCheck.fromJson(Map<String, dynamic> json) {
    return ThreatCheck(
      id: json['id'] ?? '',
      checkedAt: DateTime.parse(json['checkedAt'] ?? DateTime.now().toIso8601String()),
      threatsFound: json['threatsFound'] ?? false,
      threats: (json['threats'] as List<dynamic>? ?? [])
          .map((e) => ThreatItem.fromJson(e))
          .toList(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      overallRiskLevel: json['overallRiskLevel'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkedAt': checkedAt.toIso8601String(),
      'threatsFound': threatsFound,
      'threats': threats.map((e) => e.toJson()).toList(),
      'recommendations': recommendations,
      'overallRiskLevel': overallRiskLevel,
    };
  }
}

class ThreatItem {
  final String name;
  final String description;
  final String severity;
  final String category;

  ThreatItem({
    required this.name,
    required this.description,
    required this.severity,
    required this.category,
  });

  factory ThreatItem.fromJson(Map<String, dynamic> json) {
    return ThreatItem(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'low',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'severity': severity,
      'category': category,
    };
  }
}
