class AppSettings {
  final String languageCode;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final DateTime lastUpdated;

  AppSettings({
    required this.languageCode,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.lastUpdated,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      languageCode: 'en',
      isDarkMode: true,
      notificationsEnabled: true,
      lastUpdated: DateTime.now(),
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      languageCode: json['languageCode'] ?? 'en',
      isDarkMode: json['isDarkMode'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  AppSettings copyWith({
    String? languageCode,
    bool? isDarkMode,
    bool? notificationsEnabled,
    DateTime? lastUpdated,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  bool get isRtl => languageCode == 'ar';
}
