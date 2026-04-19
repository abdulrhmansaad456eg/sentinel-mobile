import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  static Locale currentLocale = const Locale('en');
  static Map<String, String> _localizedStrings = {};

  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('ko'),
  ];

  static Future<void> load(Locale locale) async {
    currentLocale = locale;
    final jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static String translateWithArgs(String key, Map<String, String> args) {
    String value = translate(key);
    args.forEach((key, val) {
      value = value.replaceAll('{$key}', val);
    });
    return value;
  }

  static bool isRtl() {
    return currentLocale.languageCode == 'ar';
  }

  static TextDirection getTextDirection() {
    return isRtl() ? TextDirection.rtl : TextDirection.ltr;
  }
}

extension StringTranslation on String {
  String get tr => LocalizationService.translate(this);
}
