import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../services/app_providers.dart';
import 'app_localizations.dart';

final appLocaleControllerProvider = NotifierProvider<AppLocaleController, Locale>(
  AppLocaleController.new,
);

final appLocaleBootstrapProvider = Provider<void>((ref) {
  final controller = ref.read(appLocaleControllerProvider.notifier);
  final client = ref.read(supabaseClientProvider);

  Future<void> syncFromSession() async {
    if (client.auth.currentSession == null) {
      controller.resetToDefault();
      return;
    }
    await controller.loadPreferredLocaleForCurrentUser();
  }

  // Defer to avoid modifying provider state during build phase.
  Future.microtask(syncFromSession);

  ref.listen<AsyncValue<sb.AuthState>>(authStateProvider, (prev, next) {
    Future.microtask(syncFromSession);
  });
});

class AppLocaleController extends Notifier<Locale> {
  @override
  Locale build() => AppLocaleConfig.defaultLocale;

  void setLocale(Locale locale) {
    state = AppLocaleConfig.sanitize(locale);
  }

  void setLanguageCode(String languageCode) {
    state = AppLocaleConfig.fromLanguageCode(languageCode);
  }

  void resetToDefault() {
    state = AppLocaleConfig.defaultLocale;
  }

  Future<void> loadPreferredLocaleForCurrentUser() async {
    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        resetToDefault();
        return;
      }

      final row = await client
          .from('profiles')
          .select('language_code')
          .eq('id', userId)
          .maybeSingle();

      setLanguageCode(row?['language_code'] as String? ?? 'es');
    } catch (_) {
      resetToDefault();
    }
  }
}
