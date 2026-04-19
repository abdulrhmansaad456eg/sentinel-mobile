import '../models/password_analysis.dart';

class PasswordAnalyzerService {
  static final List<String> _commonPasswords = [
    'password', '123456', '12345678', 'qwerty', 'abc123',
    'monkey', 'letmein', 'dragon', '111111', 'baseball',
    'iloveyou', 'trustno1', 'sunshine', 'princess', 'admin',
    'welcome', 'shadow', 'ashley', 'football', 'jesus',
    'michael', 'ninja', 'mustang', 'password1', '123456789',
  ];

  static final List<String> _commonPatterns = [
    '123', '234', '345', '456', '567', '678', '789', '890',
    'abc', 'bcd', 'cde', 'def', 'efg', 'fgh', 'ghi', 'hij',
    'qwe', 'wer', 'ert', 'rty', 'tyu', 'yui', 'uio', 'iop',
    'asd', 'sdf', 'dfg', 'fgh', 'ghj', 'hjk', 'jkl', 'zxc',
    'xcv', 'cvb', 'vbn', 'bnm',
  ];

  static PasswordAnalysis analyze(String password) {
    if (password.isEmpty) {
      return _createEmptyAnalysis();
    }

    final length = password.length;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\[\]\\\/_\-=+`~;]'));

    int score = _calculateScore(
      length,
      hasUppercase,
      hasLowercase,
      hasNumbers,
      hasSpecialChars,
      password,
    );

    final strength = _getStrengthLabel(score);
    final suggestions = _generateSuggestions(
      length,
      hasUppercase,
      hasLowercase,
      hasNumbers,
      hasSpecialChars,
      password,
    );

    return PasswordAnalysis(
      password: password,
      score: score,
      strength: strength,
      suggestions: suggestions,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumbers: hasNumbers,
      hasSpecialChars: hasSpecialChars,
      length: length,
      analyzedAt: DateTime.now(),
    );
  }

  static int _calculateScore(
    int length,
    bool hasUppercase,
    bool hasLowercase,
    bool hasNumbers,
    bool hasSpecialChars,
    String password,
  ) {
    int score = 0;

    if (length >= 12) {
      score += 20;
    } else if (length >= 8) {
      score += 10;
    } else {
      score += 5;
    }

    if (hasUppercase) score += 15;
    if (hasLowercase) score += 15;
    if (hasNumbers) score += 15;
    if (hasSpecialChars) score += 20;

    final varietyCount = [hasUppercase, hasLowercase, hasNumbers, hasSpecialChars]
        .where((e) => e)
        .length;
    
    if (varietyCount >= 4) score += 15;
    else if (varietyCount >= 3) score += 10;

    final lowerPassword = password.toLowerCase();
    if (_commonPasswords.contains(lowerPassword)) {
      score = score ~/ 4;
    }

    for (final pattern in _commonPatterns) {
      if (lowerPassword.contains(pattern)) {
        score -= 5;
        break;
      }
    }

    if (RegExp(r'(.)\1{2,}').hasMatch(password)) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  static String _getStrengthLabel(int score) {
    if (score < 20) return 'very_weak';
    if (score < 40) return 'weak';
    if (score < 60) return 'moderate';
    if (score < 80) return 'strong';
    return 'very_strong';
  }

  static List<String> _generateSuggestions(
    int length,
    bool hasUppercase,
    bool hasLowercase,
    bool hasNumbers,
    bool hasSpecialChars,
    String password,
  ) {
    final suggestions = <String>[];

    if (length < 12) {
      suggestions.add('password_length');
    }
    if (!hasUppercase) {
      suggestions.add('password_uppercase');
    }
    if (!hasLowercase) {
      suggestions.add('password_lowercase');
    }
    if (!hasNumbers) {
      suggestions.add('password_numbers');
    }
    if (!hasSpecialChars) {
      suggestions.add('password_special');
    }

    final lowerPassword = password.toLowerCase();
    if (_commonPasswords.contains(lowerPassword) ||
        _commonPatterns.any((p) => lowerPassword.contains(p))) {
      suggestions.add('password_unique');
    }

    return suggestions;
  }

  static PasswordAnalysis _createEmptyAnalysis() {
    return PasswordAnalysis(
      password: '',
      score: 0,
      strength: 'very_weak',
      suggestions: ['password_length', 'password_unique'],
      hasUppercase: false,
      hasLowercase: false,
      hasNumbers: false,
      hasSpecialChars: false,
      length: 0,
      analyzedAt: DateTime.now(),
    );
  }

  static String generateStrongPassword({int length = 16}) {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    final all = uppercase + lowercase + numbers + special;
    final buffer = StringBuffer();
    
    buffer.write(uppercase[DateTime.now().millisecond % uppercase.length]);
    buffer.write(lowercase[(DateTime.now().millisecond + 1) % lowercase.length]);
    buffer.write(numbers[(DateTime.now().millisecond + 2) % numbers.length]);
    buffer.write(special[(DateTime.now().millisecond + 3) % special.length]);
    
    for (int i = 4; i < length; i++) {
      final index = (DateTime.now().millisecond + i) % all.length;
      buffer.write(all[index]);
    }
    
    final chars = buffer.toString().split('')..shuffle();
    return chars.join();
  }
}
