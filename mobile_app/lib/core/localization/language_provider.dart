import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English', 'English', false),
  dari('fa', 'دری', 'Dari', true),
  pashto('ps', 'پښتو', 'Pashto', true);

  final String code;
  final String nativeName;
  final String englishName;
  final bool isRTL;

  const AppLanguage(this.code, this.nativeName, this.englishName, this.isRTL);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Language state notifier
class LanguageNotifier extends Notifier<AppLanguage> {
  static const String _languageKey = 'selected_language';

  @override
  AppLanguage build() {
    _loadSavedLanguage();
    return AppLanguage.english;
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_languageKey);
    if (savedCode != null) {
      state = AppLanguage.fromCode(savedCode);
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }

  /// Get translation for a key
  String translate(String key, {Map<String, String>? args}) {
    final translations = AppTranslations.translations[state.code];
    String value = translations?[key] ?? AppTranslations.translations['en']?[key] ?? key;
    
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}

/// Provider for language state
final languageProvider = NotifierProvider<LanguageNotifier, AppLanguage>(() {
  return LanguageNotifier();
});

/// Extension to easily get translations
extension TranslationsExtension on WidgetRef {
  String tr(String key, {Map<String, String>? args}) {
    final language = watch(languageProvider);
    final translations = AppTranslations.translations[language.code];
    String value = translations?[key] ?? AppTranslations.translations['en']?[key] ?? key;
    
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}

/// Extension for BuildContext to get text direction
extension LanguageExtension on AppLanguage {
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;
  
  Locale get locale => Locale(code);
}

/// Helper class for translations usage in widgets
class Tr {
  static String of(WidgetRef ref, String key, {Map<String, String>? args}) {
    final language = ref.read(languageProvider);
    final translations = AppTranslations.translations[language.code];
    String value = translations?[key] ?? AppTranslations.translations['en']?[key] ?? key;
    
    if (args != null) {
      args.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}
