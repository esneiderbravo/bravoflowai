import 'package:bravoflowai/core/theme/app_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppThemeController', () {
    test('defaults to system on build', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appThemeControllerProvider), ThemeMode.system);
    });

    test('setThemeModeCode maps known values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appThemeControllerProvider.notifier);
      notifier.setThemeModeCode('dark');
      expect(container.read(appThemeControllerProvider), ThemeMode.dark);

      notifier.setThemeModeCode('light');
      expect(container.read(appThemeControllerProvider), ThemeMode.light);
    });

    test('setThemeModeCode falls back to system for unsupported values', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appThemeControllerProvider.notifier).setThemeModeCode('auto');

      expect(container.read(appThemeControllerProvider), ThemeMode.system);
    });
  });

  group('AppThemeController mapping', () {
    test('fromThemeModeCode maps to ThemeMode', () {
      expect(AppThemeController.fromThemeModeCode('system'), ThemeMode.system);
      expect(AppThemeController.fromThemeModeCode('dark'), ThemeMode.dark);
      expect(AppThemeController.fromThemeModeCode('light'), ThemeMode.light);
      expect(AppThemeController.fromThemeModeCode('other'), ThemeMode.system);
      expect(AppThemeController.fromThemeModeCode(null), ThemeMode.system);
    });

    test('toThemeModeCode maps from ThemeMode', () {
      expect(AppThemeController.toThemeModeCode(ThemeMode.system), 'system');
      expect(AppThemeController.toThemeModeCode(ThemeMode.dark), 'dark');
      expect(AppThemeController.toThemeModeCode(ThemeMode.light), 'light');
    });
  });
}
