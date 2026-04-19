import '../models/learning_topic.dart';

class LearningService {
  static final List<LearningTopic> _topics = [
    LearningTopic(
      id: 'password_security',
      titleKey: 'password_security',
      descriptionKey: 'tip_1_desc',
      category: 'fundamentals',
      difficulty: 1,
      estimatedMinutes: 5,
      contentSections: [
        'What makes a strong password',
        'Common password mistakes',
        'Password manager benefits',
        'Creating memorable passwords',
      ],
    ),
    LearningTopic(
      id: 'two_factor_auth',
      titleKey: 'two_factor_auth',
      descriptionKey: 'tip_2_desc',
      category: 'authentication',
      difficulty: 2,
      estimatedMinutes: 7,
      contentSections: [
        'What is 2FA',
        'Types of 2FA',
        'Setting up 2FA',
        'Backup codes',
      ],
    ),
    LearningTopic(
      id: 'phishing',
      titleKey: 'phishing',
      descriptionKey: 'tip_4_desc',
      category: 'awareness',
      difficulty: 2,
      estimatedMinutes: 8,
      contentSections: [
        'What is phishing',
        'Common phishing tactics',
        'Identifying phishing emails',
        'What to do if you clicked',
      ],
    ),
    LearningTopic(
      id: 'social_engineering',
      titleKey: 'social_engineering',
      descriptionKey: 'tip_4_desc',
      category: 'awareness',
      difficulty: 3,
      estimatedMinutes: 10,
      contentSections: [
        'Understanding manipulation',
        'Pretexting and baiting',
        'Tailgating and shoulder surfing',
        'Protecting yourself',
      ],
    ),
    LearningTopic(
      id: 'device_security',
      titleKey: 'device_security',
      descriptionKey: 'tip_3_desc',
      category: 'fundamentals',
      difficulty: 1,
      estimatedMinutes: 6,
      contentSections: [
        'Screen locks',
        'Encryption',
        'Remote wipe',
        'Lost device procedures',
      ],
    ),
    LearningTopic(
      id: 'network_security',
      titleKey: 'network_security',
      descriptionKey: 'tip_3_desc',
      category: 'technical',
      difficulty: 3,
      estimatedMinutes: 12,
      contentSections: [
        'Public Wi-Fi risks',
        'VPN usage',
        'Network monitoring',
        'Secure connections',
      ],
    ),
    LearningTopic(
      id: 'privacy',
      titleKey: 'privacy',
      descriptionKey: 'tip_4_desc',
      category: 'fundamentals',
      difficulty: 2,
      estimatedMinutes: 7,
      contentSections: [
        'Data minimization',
        'Privacy settings',
        'Tracking prevention',
        'Digital footprint',
      ],
    ),
  ];

  static List<LearningTopic> getAllTopics() {
    return List<LearningTopic>.from(_topics);
  }

  static LearningTopic? getTopicById(String id) {
    try {
      return _topics.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<LearningTopic> getTopicsByCategory(String category) {
    return _topics.where((t) => t.category == category).toList();
  }

  static List<LearningTopic> getTopicsByDifficulty(int difficulty) {
    return _topics.where((t) => t.difficulty == difficulty).toList();
  }

  static List<String> getCategories() {
    return _topics.map((t) => t.category).toSet().toList();
  }

  static LearningProgress calculateProgress(LearningProgress progress) {
    final completed = progress.completedTopics.values.where((v) => v).length;
    final total = _topics.length;
    
    return progress;
  }
}
