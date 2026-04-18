import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/domain/entities/account.dart';
import 'package:bravoflowai/features/accounts/application/account_providers.dart';
import 'package:bravoflowai/features/accounts/presentation/screens/add_edit_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeAccountNotifier extends AccountNotifier {
  bool addCalled = false;

  @override
  Future<List<Account>> build() async => [];

  @override
  Future<void> add(Account account) async {
    addCalled = true;
  }
}

Widget _wrap(Widget child, List<Override> overrides) {
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => child)],
  );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizationDelegates.delegates,
      supportedLocales: AppLocalizationDelegates.supportedLocales,
    ),
  );
}

void main() {
  group('AddEditAccountScreen', () {
    testWidgets('shows validation error when name is empty', (tester) async {
      final notifier = _FakeAccountNotifier();

      await tester.pumpWidget(
        _wrap(const AddEditAccountScreen(), [accountNotifierProvider.overrideWith(() => notifier)]),
      );
      await tester.pumpAndSettle();

      // Tap save without filling name
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Enter an account name'), findsOneWidget);
    });

    testWidgets('shows invalid amount error for non-numeric balance', (tester) async {
      final notifier = _FakeAccountNotifier();

      await tester.pumpWidget(
        _wrap(const AddEditAccountScreen(), [accountNotifierProvider.overrideWith(() => notifier)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Test Account');
      await tester.pump();

      // Enter invalid balance
      await tester.enterText(find.byType(TextFormField).last, 'abc');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Invalid amount'), findsOneWidget);
    });

    testWidgets('submits form with valid data', (tester) async {
      final notifier = _FakeAccountNotifier();

      await tester.pumpWidget(
        _wrap(const AddEditAccountScreen(), [accountNotifierProvider.overrideWith(() => notifier)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Savings Account');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // notifier.add should have been called (name was valid, balance defaults to 0)
      expect(notifier.addCalled, isTrue);
    });
  });
}
