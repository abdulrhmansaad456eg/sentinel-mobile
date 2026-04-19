import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../services/localization_service.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int score;
  final String strength;

  const PasswordStrengthIndicator({
    required this.score,
    required this.strength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Helpers.getStrengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'strength'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strength.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$score/100',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.darkSurface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                flex: score,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                flex: 100 - score,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStrengthLabel('very_weak', 0, score, context),
            _buildStrengthLabel('weak', 20, score, context),
            _buildStrengthLabel('moderate', 40, score, context),
            _buildStrengthLabel('strong', 60, score, context),
            _buildStrengthLabel('very_strong', 80, score, context),
          ],
        ),
      ],
    );
  }

  Widget _buildStrengthLabel(String label, int threshold, int score, BuildContext context) {
    final isActive = score >= threshold;
    final color = isActive ? Helpers.getStrengthColor(strength) : AppTheme.textMuted;

    return Text(
      label.tr,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
