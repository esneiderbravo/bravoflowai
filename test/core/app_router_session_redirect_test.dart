import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/core/router/app_router.dart';
import 'package:bravoflowai/core/services/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final _testAuthStateProvider = StateProvider<bool>((ref) => true);

void main() {
  ProviderContainer buildContainer({required bool isAuthenticated}) {
    final container = ProviderContainer(
      overrides: <Override>[
        _testAuthStateProvider.overrideWith((ref) => isAuthenticated),
        isAuthenticatedProvider.overrideWith((ref) => ref.watch(_testAuthStateProvider)),
        authStateProvider.overrideWith((ref) => const Stream<sb.AuthState>.empty()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  testWidgets('redirects to sign-in after auth state becomes unauthenticated', (
    WidgetTester tester,
  ) async {
    final container = buildContainer(isAuthenticated: true);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    router.go('/profile');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.toString(), '/profile');

    container.read(_testAuthStateProvider.notifier).state = false;
    router.refresh();
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.toString(), '/auth/sign-in');
  });

  testWidgets('does not redirect to auth routes while auth state remains authenticated', (
    WidgetTester tester,
  ) async {
    final container = buildContainer(isAuthenticated: true);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          routerConfig: router,
        ),
      ),
    );

    router.go('/profile');
    await tester.pumpAndSettle();

    router.refresh();
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.toString(), '/profile');
  });
}
