import 'package:bravoflowai/core/i18n/app_locale_controller.dart';
import 'package:bravoflowai/core/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocaleController', () {
    test('defaults to Spanish on build', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appLocaleControllerProvider), const Locale('es'));
    });

    test('setLanguageCode updates to English', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appLocaleControllerProvider.notifier).setLanguageCode('en');

      expect(container.read(appLocaleControllerProvider), const Locale('en'));
    });

    test('setLanguageCode falls back to Spanish for unsupported code', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appLocaleControllerProvider.notifier).setLanguageCode('fr');

      expect(container.read(appLocaleControllerProvider), const Locale('es'));
    });

    test('setLanguageCode falls back to Spanish for empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appLocaleControllerProvider.notifier).setLanguageCode('');

      expect(container.read(appLocaleControllerProvider), const Locale('es'));
    });

    test('resetToDefault restores Spanish after English was set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appLocaleControllerProvider.notifier).setLanguageCode('en');
      container.read(appLocaleControllerProvider.notifier).resetToDefault();

      expect(container.read(appLocaleControllerProvider), const Locale('es'));
    });
  });

  group('AppLocaleConfig', () {
    test('sanitize returns Spanish for null locale', () {
      expect(AppLocaleConfig.sanitize(null), const Locale('es'));
    });

    test('sanitize returns English for en locale', () {
      expect(AppLocaleConfig.sanitize(const Locale('en')), const Locale('en'));
    });

    test('sanitize returns Spanish for unsupported locale', () {
      expect(AppLocaleConfig.sanitize(const Locale('pt')), const Locale('es'));
    });

    test('fromLanguageCode maps known codes correctly', () {
      expect(AppLocaleConfig.fromLanguageCode('en'), const Locale('en'));
      expect(AppLocaleConfig.fromLanguageCode('es'), const Locale('es'));
      expect(AppLocaleConfig.fromLanguageCode('de'), const Locale('es'));
      expect(AppLocaleConfig.fromLanguageCode(null), const Locale('es'));
    });

    test('toLanguageCode extracts language tag', () {
      expect(AppLocaleConfig.toLanguageCode(const Locale('en')), 'en');
      expect(AppLocaleConfig.toLanguageCode(const Locale('es')), 'es');
    });
  });
}

