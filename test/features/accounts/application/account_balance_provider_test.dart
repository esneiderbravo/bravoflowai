import 'package:bravoflowai/domain/entities/account.dart';
import 'package:bravoflowai/domain/entities/category.dart';
import 'package:bravoflowai/domain/entities/transaction.dart';
import 'package:bravoflowai/domain/repositories/account_repository.dart';
import 'package:bravoflowai/domain/repositories/transaction_repository.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/accounts/application/account_balance_provider.dart';
import 'package:bravoflowai/features/accounts/application/account_providers.dart';
import 'package:bravoflowai/features/transactions/application/transaction_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

Account _makeAccount({double initialBalance = 100}) => Account(
  id: 'acc1',
  userId: 'u1',
  name: 'Cash',
  type: AccountType.cash,
  initialBalance: Money(amount: initialBalance),
  currency: 'USD',
  isDefault: true,
  createdAt: DateTime(2026, 4, 18),
);

const _category = Category(id: 'c1', userId: 'u1', name: 'General');

Transaction _makeTxn({required TransactionType type, required double amount}) => Transaction(
  id: 't1',
  userId: 'u1',
  accountId: 'acc1',
  amount: Money(amount: amount),
  category: _category,
  description: 'test',
  date: DateTime(2026, 4, 18),
  type: type,
  createdAt: DateTime(2026, 4, 18),
);

void main() {
  group('accountBalanceProvider', () {
    test('no transactions → returns initialBalance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(() => txRepo.getAll()).thenAnswer((_) async => const Right([]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 100.0);
    });

    test('income transaction adds to balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(
        () => txRepo.getAll(),
      ).thenAnswer((_) async => Right([_makeTxn(type: TransactionType.income, amount: 50)]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 150.0);
    });

    test('expense transaction subtracts from balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(
        () => txRepo.getAll(),
      ).thenAnswer((_) async => Right([_makeTxn(type: TransactionType.expense, amount: 30)]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 70.0);
    });

    test('income and expense together compute net balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(() => txRepo.getAll()).thenAnswer(
        (_) async => Right([
          _makeTxn(type: TransactionType.income, amount: 50),
          _makeTxn(type: TransactionType.expense, amount: 30),
        ]),
      );

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 120.0); // 100 + 50 - 30
    });
  });
}
