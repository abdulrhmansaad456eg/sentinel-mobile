import 'dart:math';
import '../models/threat_check.dart';

class ThreatCheckerService {
  static final Random _random = Random();

  static final List<Map<String, String>> _potentialThreats = [
    {
      'name': 'Outdated OS Version',
      'description': 'Operating system updates available',
      'severity': 'medium',
      'category': 'system',
    },
    {
      'name': 'App Permissions',
      'description': 'Some apps have excessive permissions',
      'severity': 'low',
      'category': 'privacy',
    },
    {
      'name': 'Unknown Sources',
      'description': 'Installation from unknown sources enabled',
      'severity': 'high',
      'category': 'security',
    },
    {
      'name': 'Bluetooth Enabled',
      'description': 'Bluetooth is on when not in use',
      'severity': 'low',
      'category': 'connectivity',
    },
    {
      'name': 'Location Sharing',
      'description': 'Location services always active',
      'severity': 'medium',
      'category': 'privacy',
    },
    {
      'name': 'Unencrypted Backup',
      'description': 'Device backup not encrypted',
      'severity': 'medium',
      'category': 'data',
    },
    {
      'name': 'Weak Screen Lock',
      'description': 'Screen lock is PIN-only or absent',
      'severity': 'high',
      'category': 'access',
    },
  ];

  static final List<String> _recommendations = [
    'update_os',
    'enable_encryption',
    'review_permissions',
    'disable_bluetooth',
  ];

  static ThreatCheck performCheck() {
    final threats = <ThreatItem>[];
    final selectedRecommendations = <String>[];

    final numThreats = _random.nextInt(4);
    
    if (numThreats > 0) {
      final shuffled = List<Map<String, String>>.from(_potentialThreats)..shuffle();
      
      for (int i = 0; i < numThreats && i < shuffled.length; i++) {
        final threat = shuffled[i];
        threats.add(ThreatItem(
          name: threat['name']!,
          description: threat['description']!,
          severity: threat['severity']!,
          category: threat['category']!,
        ));
      }

      final recCount = _random.nextInt(3) + 1;
      final shuffledRecs = List<String>.from(_recommendations)..shuffle();
      selectedRecommendations.addAll(shuffledRecs.take(recCount));
    }

    final riskLevel = _calculateRiskLevel(threats);

    return ThreatCheck(
      id: _generateId(),
      checkedAt: DateTime.now(),
      threatsFound: threats.isNotEmpty,
      threats: threats,
      recommendations: selectedRecommendations,
      overallRiskLevel: riskLevel,
    );
  }

  static int _calculateRiskLevel(List<ThreatItem> threats) {
    if (threats.isEmpty) return 0;

    int score = 0;
    for (final threat in threats) {
      switch (threat.severity) {
        case 'high':
          score += 30;
          break;
        case 'medium':
          score += 15;
          break;
        case 'low':
          score += 5;
          break;
      }
    }

    return score.clamp(1, 100);
  }

  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(9999);
    return 'scan_$timestamp$random';
  }

  static String getRiskLabel(int level) {
    if (level == 0) return 'no_threats';
    if (level <= 30) return 'low';
    if (level <= 60) return 'medium';
    return 'high';
  }
}
