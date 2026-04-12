import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/i18n/app_locale_controller.dart';
import 'core/i18n/app_localizations.dart';
import 'core/i18n/app_localizations_delegate.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: BravoFlowApp()));
}

/// Root application widget.
class BravoFlowApp extends ConsumerWidget {
  const BravoFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appLocaleBootstrapProvider);
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.app_title,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizationDelegates.delegates,
      supportedLocales: AppLocalizationDelegates.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        final target = AppLocaleConfig.sanitize(deviceLocale);
        return supportedLocales.contains(target) ? target : AppLocaleConfig.defaultLocale;
      },

      // Dark-first theme
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // go_router replaces `home:`
      routerConfig: router,
    );
  }
}
