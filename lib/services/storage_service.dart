import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/security_score.dart';
import '../models/security_habit.dart';
import '../models/app_settings.dart';
import '../models/threat_check.dart';
import '../models/learning_topic.dart';

class StorageService {
  static const String _settingsKey = 'app_settings';
  static const String _securityScoreKey = 'security_score';
  static const String _habitsKey = 'security_habits';
  static const String _threatChecksKey = 'threat_checks';
  static const String _learningProgressKey = 'learning_progress';
  static const String _lastScanKey = 'last_scan_date';

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<AppSettings> getSettings() async {
    if (_prefs == null) await initialize();
    
    final jsonString = _prefs?.getString(_settingsKey);
    if (jsonString == null) {
      return AppSettings.defaultSettings();
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (e) {
      return AppSettings.defaultSettings();
    }
  }

  static Future<void> saveSettings(AppSettings settings) async {
    if (_prefs == null) await initialize();
    
    final jsonString = jsonEncode(settings.toJson());
    await _prefs?.setString(_settingsKey, jsonString);
  }

  static Future<SecurityScore> getSecurityScore() async {
    if (_prefs == null) await initialize();
    
    final jsonString = _prefs?.getString(_securityScoreKey);
    if (jsonString == null) {
      return _createDefaultScore();
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SecurityScore.fromJson(json);
    } catch (e) {
      return _createDefaultScore();
    }
  }

  static Future<void> saveSecurityScore(SecurityScore score) async {
    if (_prefs == null) await initialize();
    
    final jsonString = jsonEncode(score.toJson());
    await _prefs?.setString(_securityScoreKey, jsonString);
  }

  static SecurityScore _createDefaultScore() {
    return SecurityScore(
      score: 50,
      status: 'fair',
      lastUpdated: DateTime.now(),
      categoryScores: {
        'passwords': 40,
        'device': 60,
        'habits': 50,
        'awareness': 45,
      },
    );
  }

  static Future<List<SecurityHabit>> getHabits() async {
    if (_prefs == null) await initialize();
    
    final jsonString = _prefs?.getString(_habitsKey);
    if (jsonString == null) {
      return _createDefaultHabits();
    }
    
    try {
      final json = jsonDecode(jsonString) as List<dynamic>;
      return json.map((e) => SecurityHabit.fromJson(e)).toList();
    } catch (e) {
      return _createDefaultHabits();
    }
  }

  static Future<void> saveHabits(List<SecurityHabit> habits) async {
    if (_prefs == null) await initialize();
    
    final jsonString = jsonEncode(habits.map((e) => e.toJson()).toList());
    await _prefs?.setString(_habitsKey, jsonString);
  }

  static List<SecurityHabit> _createDefaultHabits() {
    return [
      SecurityHabit(
        id: '1',
        name: 'Check app permissions',
        description: 'Review and revoke unnecessary app permissions',
        createdAt: DateTime.now(),
        completedDates: [],
        targetDaysPerWeek: 1,
        isActive: true,
      ),
      SecurityHabit(
        id: '2',
        name: 'Update passwords',
        description: 'Update critical account passwords',
        createdAt: DateTime.now(),
        completedDates: [],
        targetDaysPerWeek: 1,
        isActive: true,
      ),
      SecurityHabit(
        id: '3',
        name: 'Review security settings',
        description: 'Check device security and privacy settings',
        createdAt: DateTime.now(),
        completedDates: [],
        targetDaysPerWeek: 2,
        isActive: true,
      ),
    ];
  }

  static Future<List<ThreatCheck>> getThreatChecks() async {
    if (_prefs == null) await initialize();
    
    final jsonString = _prefs?.getString(_threatChecksKey);
    if (jsonString == null) {
      return [];
    }
    
    try {
      final json = jsonDecode(jsonString) as List<dynamic>;
      return json.map((e) => ThreatCheck.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveThreatCheck(ThreatCheck check) async {
    if (_prefs == null) await initialize();
    
    final checks = await getThreatChecks();
    checks.add(check);
    
    if (checks.length > 50) {
      checks.removeAt(0);
    }
    
    final jsonString = jsonEncode(checks.map((e) => e.toJson()).toList());
    await _prefs?.setString(_threatChecksKey, jsonString);
  }

  static Future<DateTime?> getLastScanDate() async {
    if (_prefs == null) await initialize();
    
    final timestamp = _prefs?.getInt(_lastScanKey);
    if (timestamp == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static Future<void> setLastScanDate(DateTime date) async {
    if (_prefs == null) await initialize();
    
    await _prefs?.setInt(_lastScanKey, date.millisecondsSinceEpoch);
  }

  static Future<LearningProgress> getLearningProgress() async {
    if (_prefs == null) await initialize();
    
    final jsonString = _prefs?.getString(_learningProgressKey);
    if (jsonString == null) {
      return _createDefaultProgress();
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return LearningProgress.fromJson(json);
    } catch (e) {
      return _createDefaultProgress();
    }
  }

  static Future<void> saveLearningProgress(LearningProgress progress) async {
    if (_prefs == null) await initialize();
    
    final jsonString = jsonEncode(progress.toJson());
    await _prefs?.setString(_learningProgressKey, jsonString);
  }

  static LearningProgress _createDefaultProgress() {
    return LearningProgress(
      userId: 'local_user',
      completedTopics: {},
      totalTimeSpentMinutes: 0,
      lastActivity: DateTime.now(),
    );
  }

  static Future<void> clearAll() async {
    if (_prefs == null) await initialize();
    await _prefs?.clear();
  }
}
