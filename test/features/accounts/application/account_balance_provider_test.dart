import 'package:bravoflowai/domain/entities/account.dart';
import 'package:bravoflowai/domain/entities/category.dart';
import 'package:bravoflowai/domain/entities/transaction.dart';
import 'package:bravoflowai/domain/entities/transfer.dart';
import 'package:bravoflowai/domain/repositories/account_repository.dart';
import 'package:bravoflowai/domain/repositories/transaction_repository.dart';
import 'package:bravoflowai/domain/repositories/transfer_repository.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/accounts/application/account_balance_provider.dart';
import 'package:bravoflowai/features/accounts/application/account_providers.dart';
import 'package:bravoflowai/features/accounts/application/transfer_providers.dart';
import 'package:bravoflowai/features/transactions/application/transaction_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockTransferRepository extends Mock implements TransferRepository {}

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

Transfer _makeTransfer({required String toAccount, required double amount}) => Transfer(
  id: 'tr1',
  userId: 'u1',
  fromAccountId: toAccount == 'acc1' ? 'acc2' : 'acc1',
  toAccountId: toAccount,
  amount: Money(amount: amount),
  date: DateTime(2026, 4, 18),
  createdAt: DateTime(2026, 4, 18),
);

void main() {
  group('accountBalanceProvider', () {
    test('no transactions → returns initialBalance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();
      final transferRepo = MockTransferRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(() => txRepo.getAll()).thenAnswer((_) async => const Right([]));
      when(() => transferRepo.getByAccount('acc1')).thenAnswer((_) async => const Right([]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
          transferRepositoryProvider.overrideWithValue(transferRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 100.0);
    });

    test('income transaction adds to balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();
      final transferRepo = MockTransferRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(
        () => txRepo.getAll(),
      ).thenAnswer((_) async => Right([_makeTxn(type: TransactionType.income, amount: 50)]));
      when(() => transferRepo.getByAccount('acc1')).thenAnswer((_) async => const Right([]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
          transferRepositoryProvider.overrideWithValue(transferRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 150.0);
    });

    test('expense transaction subtracts from balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();
      final transferRepo = MockTransferRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(
        () => txRepo.getAll(),
      ).thenAnswer((_) async => Right([_makeTxn(type: TransactionType.expense, amount: 30)]));
      when(() => transferRepo.getByAccount('acc1')).thenAnswer((_) async => const Right([]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
          transferRepositoryProvider.overrideWithValue(transferRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 70.0);
    });

    test('incoming transfer adds to balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();
      final transferRepo = MockTransferRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(() => txRepo.getAll()).thenAnswer((_) async => const Right([]));
      when(
        () => transferRepo.getByAccount('acc1'),
      ).thenAnswer((_) async => Right([_makeTransfer(toAccount: 'acc1', amount: 20)]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
          transferRepositoryProvider.overrideWithValue(transferRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 120.0);
    });

    test('outgoing transfer subtracts from balance', () async {
      final accountRepo = MockAccountRepository();
      final txRepo = MockTransactionRepository();
      final transferRepo = MockTransferRepository();

      when(() => accountRepo.getAll()).thenAnswer((_) async => Right([_makeAccount()]));
      when(() => txRepo.getAll()).thenAnswer((_) async => const Right([]));
      when(
        () => transferRepo.getByAccount('acc1'),
      ).thenAnswer((_) async => Right([_makeTransfer(toAccount: 'acc2', amount: 25)]));

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(accountRepo),
          transactionRepositoryProvider.overrideWithValue(txRepo),
          transferRepositoryProvider.overrideWithValue(transferRepo),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(accountBalanceProvider('acc1').future);
      expect(balance.amount, 75.0);
    });
  });
}
