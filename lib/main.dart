import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
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
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Dark-first theme
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // go_router replaces `home:`
      routerConfig: router,
    );
  }
}
