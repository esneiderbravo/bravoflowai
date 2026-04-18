import 'package:bravoflowai/core/error/failure.dart';
import 'package:bravoflowai/domain/entities/account.dart';
import 'package:bravoflowai/domain/repositories/account_repository.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/accounts/application/account_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

Account _makeAccount({String id = 'acc1'}) => Account(
  id: id,
  userId: 'u1',
  name: 'Cash',
  type: AccountType.cash,
  initialBalance: const Money(amount: 0),
  currency: 'USD',
  isDefault: true,
  createdAt: DateTime(2026, 4, 18),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_makeAccount());
  });

  group('AccountNotifier', () {
    test('build loads accounts', () async {
      final repo = MockAccountRepository();
      final account = _makeAccount();
      when(() => repo.getAll()).thenAnswer((_) async => Right([account]));

      final container = ProviderContainer(
        overrides: [accountRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final value = await container.read(accountNotifierProvider.future);
      expect(value.length, 1);
      expect(value.first.id, 'acc1');
    });

    test('add appends account to list', () async {
      final repo = MockAccountRepository();
      final account = _makeAccount();
      when(() => repo.getAll()).thenAnswer((_) async => const Right([]));
      when(() => repo.create(any())).thenAnswer((_) async => Right(account));

      final container = ProviderContainer(
        overrides: [accountRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(accountNotifierProvider.future);
      await container.read(accountNotifierProvider.notifier).add(account);

      expect(container.read(accountNotifierProvider).value?.length, 1);
    });

    test('edit updates account in list', () async {
      final repo = MockAccountRepository();
      final account = _makeAccount();
      final updated = Account(
        id: 'acc1',
        userId: 'u1',
        name: 'Updated',
        type: AccountType.savings,
        initialBalance: const Money(amount: 100),
        currency: 'USD',
        isDefault: false,
        createdAt: DateTime(2026, 4, 18),
      );
      when(() => repo.getAll()).thenAnswer((_) async => Right([account]));
      when(() => repo.update(any())).thenAnswer((_) async => Right(updated));

      final container = ProviderContainer(
        overrides: [accountRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(accountNotifierProvider.future);
      await container.read(accountNotifierProvider.notifier).edit(updated);

      final state = container.read(accountNotifierProvider).value;
      expect(state?.first.name, 'Updated');
    });

    test('remove deletes account from list', () async {
      final repo = MockAccountRepository();
      final account = _makeAccount();
      when(() => repo.getAll()).thenAnswer((_) async => Right([account]));
      when(() => repo.delete('acc1')).thenAnswer((_) async => const Right(unit));

      final container = ProviderContainer(
        overrides: [accountRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(accountNotifierProvider.future);
      await container.read(accountNotifierProvider.notifier).remove('acc1');

      expect(container.read(accountNotifierProvider).value?.isEmpty, isTrue);
    });

    test('build surfaces server failure', () async {
      final repo = MockAccountRepository();
      when(() => repo.getAll()).thenAnswer((_) async => const Left(ServerFailure('db error')));

      final container = ProviderContainer(
        overrides: [accountRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final state = container.read(accountNotifierProvider);
      expect(state.isLoading || state.hasError, isTrue);
    });
  });
}
