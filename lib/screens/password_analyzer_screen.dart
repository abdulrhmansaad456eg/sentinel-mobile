import 'package:flutter/material.dart';
import '../models/password_analysis.dart';
import '../services/password_analyzer_service.dart';
import '../services/localization_service.dart';
import '../utils/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/password_strength_indicator.dart';

class PasswordAnalyzerScreen extends StatefulWidget {
  const PasswordAnalyzerScreen({super.key});

  @override
  State<PasswordAnalyzerScreen> createState() => _PasswordAnalyzerScreenState();
}

class _PasswordAnalyzerScreenState extends State<PasswordAnalyzerScreen> {
  final TextEditingController _passwordController = TextEditingController();
  PasswordAnalysis? _analysis;
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _analyzePassword() {
    if (_passwordController.text.isEmpty) return;

    final analysis = PasswordAnalyzerService.analyze(_passwordController.text);
    setState(() => _analysis = analysis);
  }

  void _generatePassword() {
    final password = PasswordAnalyzerService.generateStrongPassword();
    _passwordController.text = password;
    _analyzePassword();
    
    Helpers.showSnackBar(
      context,
      'Strong password generated!',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: CustomAppBar(
        title: 'password_analyzer',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _passwordController.text.isNotEmpty
                ? _analyzePassword
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'check_password'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a password to check its strength and get suggestions for improvement.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              onChanged: (_) => _analyzePassword(),
              decoration: InputDecoration(
                hintText: 'enter_password'.tr,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                    if (_passwordController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _passwordController.clear();
                          setState(() => _analysis = null);
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _generatePassword,
                icon: const Icon(Icons.auto_fix_high),
                label: Text('Generate Strong Password'.tr),
              ),
            ),
            if (_analysis != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: PasswordStrengthIndicator(
                  score: _analysis!.score,
                  strength: _analysis!.strength,
                ),
              ),
              const SizedBox(height: 24),
              _buildCharacterAnalysis(context),
              const SizedBox(height: 24),
              if (_analysis!.suggestions.isNotEmpty)
                _buildSuggestions(context),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterAnalysis(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Character Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCharStat(
                  context,
                  'Length',
                  '${_analysis!.length}',
                  _analysis!.length >= 12,
                  Icons.straighten,
                ),
              ),
              Expanded(
                child: _buildCharStat(
                  context,
                  'Uppercase',
                  _analysis!.hasUppercase ? 'Yes' : 'No',
                  _analysis!.hasUppercase,
                  Icons.text_fields,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCharStat(
                  context,
                  'Lowercase',
                  _analysis!.hasLowercase ? 'Yes' : 'No',
                  _analysis!.hasLowercase,
                  Icons.text_fields,
                ),
              ),
              Expanded(
                child: _buildCharStat(
                  context,
                  'Numbers',
                  _analysis!.hasNumbers ? 'Yes' : 'No',
                  _analysis!.hasNumbers,
                  Icons.numbers,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCharStat(
            context,
            'Special Characters',
            _analysis!.hasSpecialChars ? 'Yes' : 'No',
            _analysis!.hasSpecialChars,
            Icons.emoji_symbols,
          ),
        ],
      ),
    );
  }

  Widget _buildCharStat(
    BuildContext context,
    String label,
    String value,
    bool isGood,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isGood ? AppTheme.successColor : AppTheme.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isGood ? AppTheme.successColor : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isGood ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: isGood ? AppTheme.successColor : AppTheme.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
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
            children: [
              Icon(
                Icons.lightbulb,
                color: AppTheme.warningColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'suggestions'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._analysis!.suggestions.map((suggestion) => _buildSuggestionItem(context, suggestion)),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(BuildContext context, String suggestion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.priority_high,
                size: 14,
                color: AppTheme.warningColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              suggestion.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
