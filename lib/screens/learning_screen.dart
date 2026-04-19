import 'package:flutter/material.dart';
import '../models/learning_topic.dart';
import '../models/security_score.dart';
import '../services/learning_service.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/learning_topic_card.dart';
import '../widgets/loading_indicator.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  List<LearningTopic> _topics = [];
  LearningProgress? _progress;
  bool _isLoading = true;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final topics = LearningService.getAllTopics();
    final progress = await StorageService.getLearningProgress();
    
    setState(() {
      _topics = topics;
      _progress = progress;
      _isLoading = false;
    });
  }

  void _markTopicComplete(String topicId) async {
    if (_progress == null) return;

    final newCompleted = Map<String, bool>.from(_progress!.completedTopics);
    newCompleted[topicId] = true;

    final updated = LearningProgress(
      userId: _progress!.userId,
      completedTopics: newCompleted,
      totalTimeSpentMinutes: _progress!.totalTimeSpentMinutes + 5,
      lastActivity: DateTime.now(),
    );

    setState(() => _progress = updated);
    await StorageService.saveLearningProgress(updated);
    await _updateSecurityScore();
  }

  Future<void> _updateSecurityScore() async {
    if (_progress == null) return;
    
    final score = await StorageService.getSecurityScore();
    
    final completed = _progress!.completedTopics.values.where((v) => v).length;
    final total = _topics.length;
    final awarenessScore = (completed / total * 100).toInt();
    
    final newCategoryScores = Map<String, int>.from(score.categoryScores);
    newCategoryScores['awareness'] = awarenessScore;
    
    final avgScore = newCategoryScores.values.reduce((a, b) => a + b) ~/ newCategoryScores.length;
    
    final newScore = score.copyWith(
      score: avgScore,
      status: Helpers.getScoreStatus(avgScore),
      categoryScores: newCategoryScores,
      lastUpdated: DateTime.now(),
    );
    
    await StorageService.saveSecurityScore(newScore);
  }

  void _showTopicDetail(LearningTopic topic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(topic.category).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getCategoryIcon(topic.category),
                        color: _getCategoryColor(topic.category),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.titleKey.tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            topic.estimatedMinutes.toString() + ' min read',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  topic.descriptionKey.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Key Points',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...topic.contentSections.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _markTopicComplete(topic.id);
                      Navigator.of(context).pop();
                      Helpers.showSnackBar(
                        context,
                        'Topic completed! Great job.',
                        isError: false,
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: Text('Mark as Complete'.tr),
                  ),
                ),
              ],
            ),
          );
        },
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
      case 'advanced':
        return const Color(0xFF7C3AED); // Purple for advanced
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
      case 'advanced':
        return Icons.star;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _progress?.completedTopics.values.where((v) => v).length ?? 0;
    final total = _topics.length;
    final progressPercent = total > 0 ? (completed / total * 100).toInt() : 0;

    final categories = ['all', ...LearningService.getCategories()];
    final filteredTopics = _selectedCategory == 'all'
        ? _topics
        : _topics.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: 'learning_center',
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'loading')
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Progress',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$completed / $total',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: total > 0 ? completed / total : 0,
                              minHeight: 12,
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant ?? Theme.of(context).colorScheme.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$progressPercent% complete',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat == 'all' ? 'All' : cat.capitalize()),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedCategory = cat),
                              backgroundColor: Theme.of(context).colorScheme.surfaceVariant ?? Theme.of(context).colorScheme.surface,
                              selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              labelStyle: TextStyle(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'learn_security'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (filteredTopics.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant ?? Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No topics in this category',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filteredTopics.map((topic) => LearningTopicCard(
                        topic: topic,
                        onTap: () => _showTopicDetail(topic),
                        isCompleted: _progress?.completedTopics[topic.id] ?? false,
                      )),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
