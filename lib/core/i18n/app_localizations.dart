import 'package:flutter/widgets.dart';

import 'gen/app_localizations.g.dart' as gen;

// Re-export the generated class so callers only import this file.
typedef AppLocalizations = gen.AppLocalizations;

abstract final class AppLocaleConfig {
  static const Locale defaultLocale = Locale('es');
  static const List<Locale> supportedLocales = <Locale>[Locale('es'), Locale('en')];

  static Locale sanitize(Locale? locale) {
    final languageCode = locale?.languageCode.toLowerCase();
    if (languageCode == null) return defaultLocale;
    if (languageCode == 'en') return const Locale('en');
    return defaultLocale;
  }

  static Locale fromLanguageCode(String? value) =>
      sanitize((value == null || value.trim().isEmpty) ? null : Locale(value.trim().toLowerCase()));

  static String toLanguageCode(Locale locale) => sanitize(locale).languageCode;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => gen.AppLocalizations.of(this);
}
