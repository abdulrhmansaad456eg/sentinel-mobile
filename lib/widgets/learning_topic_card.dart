import 'package:flutter/material.dart';
import '../models/learning_topic.dart';
import '../utils/app_theme.dart';
import '../services/localization_service.dart';

class LearningTopicCard extends StatelessWidget {
  final LearningTopic topic;
  final VoidCallback onTap;
  final bool isCompleted;

  const LearningTopicCard({
    required this.topic,
    required this.onTap,
    this.isCompleted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppTheme.successColor.withOpacity(0.3)
                : AppTheme.darkCard,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getCategoryColor(topic.category).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(topic.category),
                  color: _getCategoryColor(topic.category),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          topic.titleKey.tr,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: AppTheme.successColor,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.descriptionKey.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDifficultyBadge(context, topic.difficulty),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${topic.estimatedMinutes} min',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
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
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context, int difficulty) {
    final colors = [
      AppTheme.successColor,
      AppTheme.warningColor,
      AppTheme.errorColor,
    ];
    final labels = ['Beginner', 'Intermediate', 'Advanced'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[difficulty - 1].withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        labels[difficulty - 1],
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors[difficulty - 1],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'fundamentals':
        return AppTheme.primaryColor;
      case 'authentication':
        return AppTheme.secondaryColor;
      case 'awareness':
        return AppTheme.warningColor;
      case 'technical':
        return AppTheme.accentColor;
      default:
        return AppTheme.infoColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'fundamentals':
        return Icons.foundation;
      case 'authentication':
        return Icons.verified_user;
      case 'awareness':
        return Icons.psychology;
      case 'technical':
        return Icons.computer;
      default:
        return Icons.book;
    }
  }
}
