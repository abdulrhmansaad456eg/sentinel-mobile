import 'package:flutter/material.dart';
import '../models/security_habit.dart';
import '../models/security_score.dart';
import '../services/storage_service.dart';
import '../services/localization_service.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/habit_list_item.dart';
import '../widgets/loading_indicator.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<SecurityHabit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await StorageService.getHabits();
    setState(() {
      _habits = habits;
      _isLoading = false;
    });
  }

  Future<void> _toggleHabit(String habitId) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final now = DateTime.now();
    
    List<DateTime> newDates;
    if (habit.isCompletedToday) {
      newDates = habit.completedDates.where((d) => !SecurityHabit.isSameDay(d, now)).toList();
    } else {
      newDates = [...habit.completedDates, now];
    }

    final updatedHabit = habit.copyWith(completedDates: newDates);
    
    setState(() {
      _habits[index] = updatedHabit;
    });

    await StorageService.saveHabits(_habits);
    await _updateSecurityScore();
  }

  Future<void> _updateSecurityScore() async {
    final score = await StorageService.getSecurityScore();
    
    final todayCompletions = _habits.where((h) => h.isCompletedToday).length;
    final habitsScore = (todayCompletions / _habits.length * 100).toInt();
    
    final newCategoryScores = Map<String, int>.from(score.categoryScores);
    newCategoryScores['habits'] = habitsScore;
    
    final avgScore = newCategoryScores.values.reduce((a, b) => a + b) ~/ newCategoryScores.length;
    
    final newScore = score.copyWith(
      score: avgScore,
      status: Helpers.getScoreStatus(avgScore),
      categoryScores: newCategoryScores,
      lastUpdated: DateTime.now(),
    );
    
    await StorageService.saveSecurityScore(newScore);
  }

  void _showAddHabitDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('add_habit'.tr, style: const TextStyle(color: AppTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'habit_name'.tr,
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              final newHabit = SecurityHabit(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                createdAt: DateTime.now(),
                completedDates: [],
                targetDaysPerWeek: 7,
                isActive: true,
              );

              setState(() => _habits.add(newHabit));
              await StorageService.saveHabits(_habits);
              
              Navigator.of(context).pop();
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _showEditHabitDialog(SecurityHabit habit) {
    final nameController = TextEditingController(text: habit.name);
    final descriptionController = TextEditingController(text: habit.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('edit'.tr + ' ' + 'habits'.tr, style: const TextStyle(color: AppTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'habit_name'.tr,
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final index = _habits.indexWhere((h) => h.id == habit.id);
              if (index == -1) return;

              final updated = habit.copyWith(
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
              );

              setState(() => _habits[index] = updated);
              await StorageService.saveHabits(_habits);
              
              Navigator.of(context).pop();
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHabit(String habitId) async {
    setState(() {
      _habits.removeWhere((h) => h.id == habitId);
    });
    await StorageService.saveHabits(_habits);
  }

  @override
  Widget build(BuildContext context) {
    final completedToday = _habits.where((h) => h.isCompletedToday).length;
    final totalStreak = _habits.fold<int>(0, (sum, h) => sum + h.currentStreak);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: CustomAppBar(
        title: 'security_habits',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHabitDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'loading')
          : RefreshIndicator(
              onRefresh: _loadHabits,
              color: AppTheme.primaryColor,
              backgroundColor: AppTheme.darkSurface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatBox(
                              context,
                              completedToday.toString(),
                              'Completed Today',
                              AppTheme.successColor,
                              Icons.check_circle,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: AppTheme.darkSurface,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Expanded(
                            child: _buildStatBox(
                              context,
                              '$totalStreak',
                              'Total Streak',
                              AppTheme.primaryColor,
                              Icons.local_fire_department,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Today',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_habits.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.track_changes_outlined,
                                size: 48,
                                color: AppTheme.textMuted.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No habits yet',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first security habit',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._habits.map((habit) => HabitListItem(
                        habit: habit,
                        onToggle: () => _toggleHabit(habit.id),
                        onEdit: () => _showEditHabitDialog(habit),
                        onDelete: () => _deleteHabit(habit.id),
                      )),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
