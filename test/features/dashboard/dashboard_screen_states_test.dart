import 'dart:async';

import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/features/dashboard/application/dashboard_notifier.dart';
import 'package:bravoflowai/features/dashboard/application/dashboard_providers.dart';
import 'package:bravoflowai/features/dashboard/application/dashboard_state.dart';
import 'package:bravoflowai/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _LoadingDashboardNotifier extends DashboardNotifier {
  @override
  Future<DashboardState> build() {
    // Keep the provider in loading state without creating pending timers.
    return Completer<DashboardState>().future;
  }
}

class _DataDashboardNotifier extends DashboardNotifier {
  @override
  Future<DashboardState> build() async {
    return const DashboardState(userName: 'User', totalBalance: 1250, monthlyChangePct: 1.2);
  }
}

class _ErrorDashboardNotifier extends DashboardNotifier {
  @override
  Future<DashboardState> build() async {
    throw Exception('boom');
  }
}

void main() {
  testWidgets('DashboardScreen shows loading state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dashboardNotifierProvider.overrideWith(_LoadingDashboardNotifier.new)],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const DashboardScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardScreen shows data state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dashboardNotifierProvider.overrideWith(_DataDashboardNotifier.new)],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tu resumen financiero'), findsOneWidget);
  });

  testWidgets('DashboardScreen shows error state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dashboardNotifierProvider.overrideWith(_ErrorDashboardNotifier.new)],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizationDelegates.delegates,
          supportedLocales: AppLocalizationDelegates.supportedLocales,
          home: const DashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Exception: boom'), findsOneWidget);
  });
}
