import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/app_theme.dart';
import 'storage_service.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  Future<void> loadTheme() async {
    final settings = await StorageService.getSettings();
    _isDarkMode = settings.isDarkMode;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final settings = await StorageService.getSettings();
    final updated = settings.copyWith(isDarkMode: _isDarkMode);
    await StorageService.saveSettings(updated);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      final settings = await StorageService.getSettings();
      final updated = settings.copyWith(isDarkMode: _isDarkMode);
      await StorageService.saveSettings(updated);
      notifyListeners();
    }
  }

  static bool getSystemDarkMode() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
