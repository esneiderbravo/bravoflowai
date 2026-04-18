import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../services/app_providers.dart';

final appThemeControllerProvider = NotifierProvider<AppThemeController, ThemeMode>(
  AppThemeController.new,
);

final appThemeBootstrapProvider = Provider<void>((ref) {
  final controller = ref.read(appThemeControllerProvider.notifier);
  final client = ref.read(supabaseClientProvider);

  Future<void> syncFromSession() async {
    if (client.auth.currentSession == null) {
      controller.resetToDefault();
      return;
    }
    await controller.loadPreferredThemeForCurrentUser();
  }

  // Defer to avoid modifying provider state during build phase.
  Future.microtask(syncFromSession);

  ref.listen<AsyncValue<sb.AuthState>>(authStateProvider, (prev, next) {
    Future.microtask(syncFromSession);
  });
});

class AppThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void setThemeModeCode(String? modeCode) {
    state = fromThemeModeCode(modeCode);
  }

  void resetToDefault() {
    state = ThemeMode.system;
  }

  Future<void> loadPreferredThemeForCurrentUser() async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        resetToDefault();
        return;
      }

      final row = await client.from('profiles').select('theme_mode').eq('id', userId).maybeSingle();
      setThemeModeCode(row?['theme_mode'] as String?);
    } catch (_) {
      resetToDefault();
    }
  }

  static ThemeMode fromThemeModeCode(String? modeCode) {
    switch (modeCode?.trim().toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String toThemeModeCode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}
