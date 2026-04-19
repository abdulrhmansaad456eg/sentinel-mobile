import 'package:flutter/material.dart';
import '../models/threat_check.dart';
import '../services/threat_checker_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/threat_status_card.dart';
import '../widgets/loading_indicator.dart';

class ThreatCheckerScreen extends StatefulWidget {
  const ThreatCheckerScreen({super.key});

  @override
  State<ThreatCheckerScreen> createState() => _ThreatCheckerScreenState();
}

class _ThreatCheckerScreenState extends State<ThreatCheckerScreen> {
  ThreatCheck? _lastCheck;
  List<ThreatCheck> _checkHistory = [];
  bool _isLoading = true;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final checks = await StorageService.getThreatChecks();
    
    setState(() {
      _checkHistory = checks.reversed.toList();
      _lastCheck = checks.isNotEmpty ? checks.last : null;
      _isLoading = false;
    });
  }

  Future<void> _performScan() async {
    setState(() => _isScanning = true);

    await Future.delayed(const Duration(seconds: 2));

    final check = ThreatCheckerService.performCheck();
    await StorageService.saveThreatCheck(check);
    await StorageService.setLastScanDate(DateTime.now());

    setState(() {
      _lastCheck = check;
      _checkHistory.insert(0, check);
      if (_checkHistory.length > 10) {
        _checkHistory = _checkHistory.take(10).toList();
      }
      _isScanning = false;
    });

    _showScanResult(check);
  }

  void _showScanResult(ThreatCheck check) {
    final hasThreats = check.threatsFound;
    final color = hasThreats ? AppTheme.warningColor : AppTheme.successColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              hasThreats ? Icons.warning_amber : Icons.verified,
              color: color,
            ),
            const SizedBox(width: 12),
            Text(
              hasThreats ? 'threats_found'.tr : 'no_threats'.tr,
              style: TextStyle(color: color),
            ),
          ],
        ),
        content: Text(
          hasThreats
              ? '${check.threats.length} ' + 'threats_found'.tr.toLowerCase() + '. ' + 'Review the recommendations below to improve your security.'
              : 'device_secure'.tr,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ok'.tr, style: const TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: const CustomAppBar(
        title: 'threat_checker',
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
                    ThreatStatusCard(
                      lastCheck: _lastCheck,
                      isScanning: _isScanning,
                      onScan: _performScan,
                    ),
                    if (_checkHistory.length > 1) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Scan History',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._checkHistory.skip(1).take(5).map((check) => _buildHistoryItem(context, check)),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, ThreatCheck check) {
    final hasThreats = check.threatsFound;
    final color = hasThreats ? AppTheme.warningColor : AppTheme.successColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              hasThreats ? Icons.warning_amber : Icons.verified,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Helpers.formatDateTime(check.checkedAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  hasThreats
                      ? '${check.threats.length} ' + 'threats_found'.tr.toLowerCase()
                      : 'no_threats'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppTheme.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}
