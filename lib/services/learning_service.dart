import '../models/learning_topic.dart';

class LearningService {
  static final List<LearningTopic> _topics = [
    // Fundamentals
    LearningTopic(
      id: 'password_security',
      titleKey: 'password_security',
      descriptionKey: 'Create and manage strong, unique passwords for all accounts',
      category: 'fundamentals',
      difficulty: 1,
      estimatedMinutes: 8,
      contentSections: [
        'Understanding password entropy and length requirements',
        'Why common passwords are easily cracked',
        'Password manager setup and best practices',
        'Creating memorable yet secure passphrases',
        'Password rotation myths and realities',
        'Breached password detection and response',
      ],
    ),
    LearningTopic(
      id: 'two_factor_auth',
      titleKey: 'two_factor_auth',
      descriptionKey: 'Add an extra layer of security beyond passwords',
      category: 'fundamentals',
      difficulty: 2,
      estimatedMinutes: 10,
      contentSections: [
        'Understanding authentication factors',
        'SMS vs Authenticator apps vs Hardware keys',
        'Setting up Google Authenticator or Authy',
        'Backup codes and account recovery',
        'When and where to enable 2FA',
        'Advanced: FIDO2 and WebAuthn standards',
      ],
    ),
    LearningTopic(
      id: 'device_security',
      titleKey: 'device_security',
      descriptionKey: 'Secure your smartphones, tablets, and computers',
      category: 'fundamentals',
      difficulty: 1,
      estimatedMinutes: 7,
      contentSections: [
        'Screen lock types: PIN, Pattern, Password, Biometric',
        'Full disk encryption explained',
        'Remote wipe and device tracking setup',
        'What to do when device is lost or stolen',
        'USB debugging and developer options risks',
        'Jailbreaking and rooting dangers',
      ],
    ),
    LearningTopic(
      id: 'software_updates',
      titleKey: 'software_updates',
      descriptionKey: 'Keep your systems patched and secure',
      category: 'fundamentals',
      difficulty: 1,
      estimatedMinutes: 5,
      contentSections: [
        'Why updates matter: vulnerability patches',
        'Automatic vs manual updates',
        'Operating system update procedures',
        'Application update strategies',
        'Firmware updates for hardware devices',
        'End-of-life software risks',
      ],
    ),
    
    // Threat Awareness
    LearningTopic(
      id: 'phishing',
      titleKey: 'phishing',
      descriptionKey: 'Recognize and avoid deceptive attacks',
      category: 'awareness',
      difficulty: 2,
      estimatedMinutes: 12,
      contentSections: [
        'How phishing works: psychological manipulation',
        'Email phishing: spear phishing and whaling',
        'Vishing (voice phishing) and smishing (SMS)',
        'Clone phishing and credential harvesting',
        'Spoofed websites and domain tricks',
        'QR code phishing and modern techniques',
        'Immediate steps if you clicked a phishing link',
        'Reporting phishing attempts',
      ],
    ),
    LearningTopic(
      id: 'social_engineering',
      titleKey: 'social_engineering',
      descriptionKey: 'Understand manipulation tactics used by attackers',
      category: 'awareness',
      difficulty: 3,
      estimatedMinutes: 15,
      contentSections: [
        'The psychology of social engineering',
        'Pretexting: creating convincing scenarios',
        'Baiting and quid pro quo attacks',
        'Tailgating and physical security bypasses',
        'Shoulder surfing and visual hacking',
        'Dumpster diving and information leakage',
        'Building security awareness habits',
        'Verifying identities in communications',
      ],
    ),
    LearningTopic(
      id: 'malware',
      titleKey: 'malware',
      descriptionKey: 'Understand viruses, trojans, worms, and spyware',
      category: 'awareness',
      difficulty: 2,
      estimatedMinutes: 14,
      contentSections: [
        'Types of malware explained',
        'Viruses vs worms vs trojans',
        'Ransomware: encryption and extortion',
        'Spyware and keyloggers',
        'Adware and potentially unwanted programs',
        'Rootkits and bootkits',
        'Fileless malware and living off the land',
        'Malware infection signs and symptoms',
        'Malware removal best practices',
      ],
    ),
    LearningTopic(
      id: 'ransomware',
      titleKey: 'ransomware',
      descriptionKey: 'Protect against data encryption attacks',
      category: 'awareness',
      difficulty: 3,
      estimatedMinutes: 12,
      contentSections: [
        'How ransomware encrypts your files',
        'Ransomware delivery methods',
        'Famous ransomware strains and impact',
        'To pay or not to pay the ransom',
        'Prevention: 3-2-1 backup strategy',
        'Network segmentation importance',
        'Email filtering and attachment policies',
        'Incident response for ransomware',
      ],
    ),
    
    // Network Security
    LearningTopic(
      id: 'network_security',
      titleKey: 'network_security',
      descriptionKey: 'Secure your home and mobile networks',
      category: 'technical',
      difficulty: 3,
      estimatedMinutes: 18,
      contentSections: [
        'Router security hardening checklist',
        'Wi-Fi encryption: WPA3 vs WPA2 vs WEP',
        'Changing default router credentials',
        'Guest network isolation',
        'Port forwarding risks and alternatives',
        'Network monitoring and intrusion detection',
        'DNS security and secure DNS services',
        'MAC address filtering effectiveness',
      ],
    ),
    LearningTopic(
      id: 'vpn_usage',
      titleKey: 'vpn_usage',
      descriptionKey: 'When and how to use Virtual Private Networks',
      category: 'technical',
      difficulty: 2,
      estimatedMinutes: 10,
      contentSections: [
        'What VPNs do and do not protect',
        'VPN protocols: WireGuard, OpenVPN, IKEv2',
        'Choosing a reputable VPN provider',
        'When to use a VPN',
        'VPN limitations and false security',
        'Split tunneling configuration',
        'Kill switches and leak protection',
        'Corporate vs personal VPN usage',
      ],
    ),
    LearningTopic(
      id: 'public_wifi',
      titleKey: 'public_wifi',
      descriptionKey: 'Stay safe on public and shared networks',
      category: 'technical',
      difficulty: 2,
      estimatedMinutes: 8,
      contentSections: [
        'Man-in-the-middle attacks on public Wi-Fi',
        'Evil twin and rogue access points',
        'Session hijacking risks',
        'HTTPS and certificate pinning',
        'Using mobile hotspot as alternative',
        'VPN necessity on public networks',
        'Disabling auto-connect to open networks',
      ],
    ),
    
    // Privacy
    LearningTopic(
      id: 'privacy',
      titleKey: 'privacy',
      descriptionKey: 'Control your personal data and digital footprint',
      category: 'fundamentals',
      difficulty: 2,
      estimatedMinutes: 10,
      contentSections: [
        'Data minimization principles',
        'Privacy settings on major platforms',
        'Browser privacy: cookies, tracking, fingerprinting',
        'Search engines and privacy alternatives',
        'Social media privacy configuration',
        'Location tracking and geotagging risks',
        'Digital footprint assessment tools',
        'GDPR, CCPA, and your rights',
      ],
    ),
    LearningTopic(
      id: 'browser_security',
      titleKey: 'browser_security',
      descriptionKey: 'Configure browsers for maximum security',
      category: 'technical',
      difficulty: 2,
      estimatedMinutes: 12,
      contentSections: [
        'Secure browser configuration checklist',
        'Extension security: permissions and risks',
        'Password manager integration',
        'HTTPS-Only mode and HSTS',
        'Content blockers and script blocking',
        'Private browsing limitations',
        'Browser isolation techniques',
        'Sandboxing and site isolation',
      ],
    ),
    
    LearningTopic(
      id: 'identity_theft',
      titleKey: 'identity_theft',
      descriptionKey: 'Protect against identity fraud and theft',
      category: 'awareness',
      difficulty: 2,
      estimatedMinutes: 10,
      contentSections: [
        'How identity theft happens',
        'Credit monitoring and freezes',
        'Document security and disposal',
        'Synthetic identity fraud',
        'Account takeover prevention',
        'Tax identity theft protection',
        'Medical identity theft risks',
        'Recovery steps after identity theft',
      ],
    ),
    LearningTopic(
      id: 'data_backup',
      titleKey: 'data_backup',
      descriptionKey: 'Implement reliable backup strategies',
      category: 'fundamentals',
      difficulty: 2,
      estimatedMinutes: 12,
      contentSections: [
        '3-2-1 backup rule explained',
        'Cloud vs local vs hybrid backups',
        'Backup automation and scheduling',
        'Versioning and retention policies',
        'Testing backup restoration',
        'Offsite and disaster recovery',
        'Mobile device backup strategies',
        'Encrypted backups and key management',
      ],
    ),
    LearningTopic(
      id: 'mobile_security',
      titleKey: 'mobile_security',
      descriptionKey: 'Advanced smartphone and tablet protection',
      category: 'technical',
      difficulty: 2,
      estimatedMinutes: 14,
      contentSections: [
        'iOS vs Android security models',
        'App permissions and privacy controls',
        'Sideloading risks and protection',
        'Mobile banking security best practices',
        'Bluetooth and NFC security considerations',
        'Public charging station risks (juice jacking)',
        'Mobile device management (MDM)',
        'Lost device location and remote wipe',
      ],
    ),
    LearningTopic(
      id: 'cloud_security',
      titleKey: 'cloud_security',
      descriptionKey: 'Secure your cloud storage and services',
      category: 'technical',
      difficulty: 3,
      estimatedMinutes: 16,
      contentSections: [
        'Shared responsibility model explained',
        'Cloud storage encryption and keys',
        'Multi-factor authentication for cloud',
        'API keys and access tokens management',
        'Cloud access security brokers (CASB)',
        'Data residency and sovereignty',
        'Cloud exit strategy and data portability',
        'Shadow IT and unsanctioned cloud apps',
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
