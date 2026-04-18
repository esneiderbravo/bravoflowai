import 'package:bravoflowai/core/i18n/app_localizations_delegate.dart';
import 'package:bravoflowai/domain/entities/account.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/accounts/application/account_balance_provider.dart';
import 'package:bravoflowai/features/accounts/application/account_providers.dart';
import 'package:bravoflowai/features/accounts/presentation/widgets/account_card.dart';
import 'package:bravoflowai/features/accounts/presentation/widgets/accounts_scroll_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Account _makeAccount() => Account(
  id: 'acc1',
  userId: 'u1',
  name: 'My Cash',
  type: AccountType.cash,
  initialBalance: const Money(amount: 200),
  currency: 'USD',
  isDefault: true,
  createdAt: DateTime(2026, 4, 18),
);

class _FakeAccountNotifier extends AccountNotifier {
  final List<Account> accounts;
  _FakeAccountNotifier(this.accounts);

  @override
  Future<List<Account>> build() async => accounts;
}

Widget _wrap(Widget child, List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    localizationsDelegates: AppLocalizationDelegates.delegates,
    supportedLocales: AppLocalizationDelegates.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  group('AccountCard', () {
    testWidgets('renders account name and balance', (tester) async {
      final account = _makeAccount();

      await tester.pumpWidget(
        _wrap(AccountCard(account: account), [
          accountBalanceProvider('acc1').overrideWith((ref) async => const Money(amount: 200)),
        ]),
      );
      await tester.pump();

      expect(find.text('My Cash'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      final account = _makeAccount();
      var tapped = false;

      await tester.pumpWidget(
        _wrap(AccountCard(account: account, onTap: () => tapped = true), [
          accountBalanceProvider('acc1').overrideWith((ref) async => const Money(amount: 200)),
        ]),
      );
      await tester.pump();

      await tester.tap(find.byType(AccountCard));
      expect(tapped, isTrue);
    });
  });

  group('AccountsScrollWidget', () {
    testWidgets('shows add account prompt when empty', (tester) async {
      await tester.pumpWidget(
        _wrap(const AccountsScrollWidget(), [
          accountNotifierProvider.overrideWith(() => _FakeAccountNotifier([])),
        ]),
      );
      await tester.pump();

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('renders account cards when accounts exist', (tester) async {
      final account = _makeAccount();

      await tester.pumpWidget(
        _wrap(const AccountsScrollWidget(), [
          accountNotifierProvider.overrideWith(() => _FakeAccountNotifier([account])),
          accountBalanceProvider('acc1').overrideWith((ref) async => const Money(amount: 200)),
        ]),
      );
      await tester.pump();

      expect(find.byType(AccountCard), findsOneWidget);
    });
  });
}
