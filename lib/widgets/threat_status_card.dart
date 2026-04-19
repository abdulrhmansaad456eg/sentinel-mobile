import 'package:flutter/material.dart';
import '../models/threat_check.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../services/localization_service.dart';

class ThreatStatusCard extends StatelessWidget {
  final ThreatCheck? lastCheck;
  final bool isScanning;
  final VoidCallback onScan;

  const ThreatStatusCard({
    this.lastCheck,
    this.isScanning = false,
    required this.onScan,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'check_threats'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              if (lastCheck != null)
                _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: 16),
          if (isScanning)
            _buildScanningState(context)
          else if (lastCheck == null)
            _buildNoScanState(context)
          else
            _buildScanResult(context),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isScanning ? null : onScan,
              icon: isScanning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Icon(Icons.security, size: 18),
              label: Text(isScanning ? 'scanning'.tr : 'check_now'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final hasThreats = lastCheck!.threatsFound;
    final color = hasThreats ? AppTheme.warningColor : AppTheme.successColor;
    final icon = hasThreats ? Icons.warning : Icons.verified;
    final text = hasThreats ? 'threats_found'.tr : 'no_threats'.tr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'scanning'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoScanState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.security_outlined,
            size: 48,
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'last_scan'.tr + ': ' + 'never'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResult(BuildContext context) {
    final check = lastCheck!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (check.threats.isNotEmpty) ...[
          Text(
            '${check.threats.length} ' + 'threats_found'.tr.toLowerCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.warningColor,
            ),
          ),
          const SizedBox(height: 12),
          ...check.threats.map((threat) => _buildThreatItem(context, threat)),
        ] else ...[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.successColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'device_secure'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (check.recommendations.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'recommendations'.tr,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...check.recommendations.map((rec) => _buildRecommendation(context, rec)),
        ],
      ],
    );
  }

  Widget _buildThreatItem(BuildContext context, ThreatItem threat) {
    Color severityColor;
    switch (threat.severity) {
      case 'high':
        severityColor = AppTheme.errorColor;
        break;
      case 'medium':
        severityColor = AppTheme.warningColor;
        break;
      default:
        severityColor = AppTheme.infoColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: severityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  threat.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  threat.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(BuildContext context, String rec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              rec.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
