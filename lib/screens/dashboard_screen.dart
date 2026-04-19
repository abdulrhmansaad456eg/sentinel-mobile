import 'package:flutter/material.dart';
import '../models/security_score.dart';
import '../models/threat_check.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/security_score_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/threat_status_card.dart';
import '../widgets/loading_indicator.dart';
import 'password_analyzer_screen.dart';
import 'habits_screen.dart';
import 'learning_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SecurityScore? _score;
  ThreatCheck? _lastThreatCheck;
  DateTime? _lastScanDate;
  bool _isLoading = true;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await StorageService.initialize();
    
    final score = await StorageService.getSecurityScore();
    final checks = await StorageService.getThreatChecks();
    final scanDate = await StorageService.getLastScanDate();
    
    setState(() {
      _score = score;
      _lastThreatCheck = checks.isNotEmpty ? checks.last : null;
      _lastScanDate = scanDate;
      _isLoading = false;
    });
  }

  Future<void> _performThreatCheck() async {
    setState(() => _isScanning = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final check = ThreatCheckerService.performCheck();
    await StorageService.saveThreatCheck(check);
    await StorageService.setLastScanDate(DateTime.now());
    
    await _updateSecurityScore();
    
    setState(() {
      _lastThreatCheck = check;
      _lastScanDate = DateTime.now();
      _isScanning = false;
    });
  }

  Future<void> _updateSecurityScore() async {
    if (_score == null) return;
    
    final checks = await StorageService.getThreatChecks();
    final lastCheck = checks.isNotEmpty ? checks.last : null;
    
    int deviceScore = 50;
    if (lastCheck != null) {
      if (!lastCheck.threatsFound) {
        deviceScore = 85;
      } else {
        final highThreats = lastCheck.threats.where((t) => t.severity == 'high').length;
        deviceScore = (85 - (highThreats * 20)).clamp(30, 85);
      }
    }
    
    final newCategoryScores = Map<String, int>.from(_score!.categoryScores);
    newCategoryScores['device'] = deviceScore;
    
    final avgScore = newCategoryScores.values.reduce((a, b) => a + b) ~/ newCategoryScores.length;
    
    final newScore = _score!.copyWith(
      score: avgScore,
      status: Helpers.getScoreStatus(avgScore),
      categoryScores: newCategoryScores,
      lastUpdated: DateTime.now(),
    );
    
    await StorageService.saveSecurityScore(newScore);
    
    setState(() => _score = newScore);
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          'dashboard'.tr,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.darkSurface,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _navigateToScreen(const SettingsScreen()),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'loading')
          : RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.primaryColor,
              backgroundColor: AppTheme.darkSurface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_score != null)
                      SecurityScoreCard(
                        score: _score!,
                        onTap: () {},
                      ),
                    const SizedBox(height: 20),
                    Text(
                      'security_tips'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTipCard(context, 1),
                    const SizedBox(height: 20),
                    Text(
                      'quick_actions'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                      children: [
                        FeatureCard(
                          titleKey: 'password_analyzer',
                          subtitleKey: 'check_password',
                          icon: Icons.lock_outline,
                          color: AppTheme.primaryColor,
                          isLarge: true,
                          onTap: () => _navigateToScreen(const PasswordAnalyzerScreen()),
                        ),
                        FeatureCard(
                          titleKey: 'habits',
                          subtitleKey: 'track_habits',
                          icon: Icons.track_changes_outlined,
                          color: AppTheme.secondaryColor,
                          isLarge: true,
                          onTap: () => _navigateToScreen(const HabitsScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ThreatStatusCard(
                      lastCheck: _lastThreatCheck,
                      isScanning: _isScanning,
                      onScan: _performThreatCheck,
                    ),
                    const SizedBox(height: 20),
                    FeatureCard(
                      titleKey: 'learning',
                      subtitleKey: 'learn_security',
                      icon: Icons.school_outlined,
                      color: AppTheme.accentColor,
                      onTap: () => _navigateToScreen(const LearningScreen()),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTipCard(BuildContext context, int tipNumber) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'tip_${tipNumber}_title'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'tip_${tipNumber}_desc'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ThreatCheckerService {
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
  ];

  static ThreatCheck performCheck() {
    final random = DateTime.now().millisecond;
    final threats = <ThreatItem>[];

    if (random % 3 == 0) {
      threats.add(ThreatItem(
        name: 'Outdated OS Version',
        description: 'Operating system updates available',
        severity: 'medium',
        category: 'system',
      ));
    }

    if (random % 5 == 0) {
      threats.add(ThreatItem(
        name: 'Unknown Sources',
        description: 'Installation from unknown sources enabled',
        severity: 'high',
        category: 'security',
      ));
    }

    return ThreatCheck(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      checkedAt: DateTime.now(),
      threatsFound: threats.isNotEmpty,
      threats: threats,
      recommendations: threats.isNotEmpty
          ? ['update_os', 'review_permissions']
          : [],
      overallRiskLevel: threats.isEmpty ? 0 : (threats.length * 25),
    );
  }
}
