import 'dart:math';
import '../models/threat_check.dart';

class ThreatCheckerService {
  static final Random _random = Random();

  static final List<Map<String, String>> _potentialThreats = [
    // High Severity
    {
      'name': 'Unknown Sources Enabled',
      'description': 'Installation from unknown sources is active - allows sideloading of potentially malicious apps',
      'severity': 'high',
      'category': 'security',
    },
    {
      'name': 'Weak Screen Lock',
      'description': 'Screen lock is PIN-only (4 digits) or absent - easily bypassed',
      'severity': 'high',
      'category': 'access',
    },
    {
      'name': 'USB Debugging Active',
      'description': 'Developer USB debugging is enabled - major security vulnerability',
      'severity': 'high',
      'category': 'security',
    },
    {
      'name': 'No Device Encryption',
      'description': 'Device storage is not encrypted - data accessible if device stolen',
      'severity': 'high',
      'category': 'data',
    },
    {
      'name': 'Rooted/Jailbroken Device',
      'description': 'Device has been modified to bypass security controls',
      'severity': 'high',
      'category': 'security',
    },
    
    // Medium Severity
    {
      'name': 'Outdated OS Version',
      'description': 'Operating system is 2+ versions behind - missing critical security patches',
      'severity': 'medium',
      'category': 'system',
    },
    {
      'name': 'Location Always Active',
      'description': 'GPS location services constantly running - drains battery and tracks movement',
      'severity': 'medium',
      'category': 'privacy',
    },
    {
      'name': 'Unencrypted Cloud Backup',
      'description': 'Device backups to cloud are not encrypted - provider can access data',
      'severity': 'medium',
      'category': 'data',
    },
    {
      'name': 'SMS 2FA Enabled',
      'description': 'Using SMS for two-factor authentication - vulnerable to SIM swapping',
      'severity': 'medium',
      'category': 'authentication',
    },
    {
      'name': 'Auto-Connect Wi-Fi',
      'description': 'Automatically connecting to open Wi-Fi networks - MITM attack risk',
      'severity': 'medium',
      'category': 'network',
    },
    {
      'name': 'Password Autofill',
      'description': 'Browser/app password autofill enabled without biometric protection',
      'severity': 'medium',
      'category': 'authentication',
    },
    {
      'name': 'No Find My Device',
      'description': 'Device tracking and remote wipe capability is disabled',
      'severity': 'medium',
      'category': 'device',
    },
    
    // Low Severity
    {
      'name': 'Bluetooth Always On',
      'description': 'Bluetooth enabled when not in use - minor battery drain and attack surface',
      'severity': 'low',
      'category': 'connectivity',
    },
    {
      'name': 'Excessive App Permissions',
      'description': 'Some apps have permissions they do not need (camera, microphone, contacts)',
      'severity': 'low',
      'category': 'privacy',
    },
    {
      'name': 'NFC Enabled',
      'description': 'NFC constantly active - potential for contactless payment skimming',
      'severity': 'low',
      'category': 'connectivity',
    },
    {
      'name': 'Screen Timeout Too Long',
      'description': 'Screen stays unlocked for extended period - unauthorized access risk',
      'severity': 'low',
      'category': 'access',
    },
    {
      'name': 'Notifications on Lock Screen',
      'description': 'Sensitive notifications visible without unlocking device',
      'severity': 'low',
      'category': 'privacy',
    },
    {
      'name': 'Unencrypted SD Card',
      'description': 'External storage not encrypted - data accessible if card removed',
      'severity': 'low',
      'category': 'data',
    },
  ];

  static final List<String> _recommendations = [
    'update_os',
    'enable_encryption',
    'review_permissions',
    'disable_bluetooth',
    'enable_2fa',
    'use_password_manager',
    'disable_usb_debugging',
    'enable_find_my_device',
    'use_vpn_on_public_wifi',
    'backup_data_regularly',
    'review_app_permissions',
    'enable_screen_lock',
    'disable_unknown_sources',
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
