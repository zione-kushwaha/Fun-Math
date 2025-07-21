import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'translations/en_us.dart';
import 'translations/ne_np.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': enUS,
    'ne': neNP,
  };
  
  String get languageName {
    return locale.languageCode == 'en' ? 'English' : 'नेपाली';
  }
  
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ne'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Provider for language
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

// Language state notifier
class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en', 'US'));

  void setLanguage(String languageCode) {
    if (languageCode == 'en') {
      state = const Locale('en', 'US');
    } else if (languageCode == 'ne') {
      state = const Locale('ne', 'NP');
    }
  }
}

// Extension method for easy access to translations
extension TranslationExtension on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context).translate(this);
  }
}

// Extension method for BuildContext
extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isEnglish => AppLocalizations.of(this).locale.languageCode == 'en';
  bool get isNepali => AppLocalizations.of(this).locale.languageCode == 'ne';
}
