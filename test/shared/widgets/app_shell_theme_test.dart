import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/shared/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _buildApp({required ThemeMode themeMode}) {
  final router = GoRouter(
    initialLocation: '/dashboard',
    routes: <RouteBase>[
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AppShell(child: SizedBox.shrink()),
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizationDelegates.delegates,
    supportedLocales: AppLocalizationDelegates.supportedLocales,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: themeMode,
  );
}

void main() {
  testWidgets('AppShell uses active theme surface for navigation bar in light mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp(themeMode: ThemeMode.light));
    await tester.pumpAndSettle();

    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(nav.backgroundColor, ThemeData.light().colorScheme.surface);
  });

  testWidgets('AppShell uses active theme surface for navigation bar in dark mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp(themeMode: ThemeMode.dark));
    await tester.pumpAndSettle();

    final nav = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(nav.backgroundColor, ThemeData.dark().colorScheme.surface);
  });
}
