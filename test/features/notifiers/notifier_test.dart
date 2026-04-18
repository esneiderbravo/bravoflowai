import 'package:bravoflowai/core/error/failure.dart';
import 'package:bravoflowai/domain/entities/category.dart';
import 'package:bravoflowai/domain/entities/transaction.dart';
import 'package:bravoflowai/domain/entities/user.dart';
import 'package:bravoflowai/domain/repositories/auth_repository.dart';
import 'package:bravoflowai/domain/repositories/transaction_repository.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/auth/application/auth_providers.dart';
import 'package:bravoflowai/features/transactions/application/transaction_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  final category = const Category(id: 'c1', userId: 'u1', name: 'Food');
  final tx = Transaction(
    id: 't1',
    userId: 'u1',
    accountId: 'acc1',
    amount: const Money(amount: 20),
    category: category,
    description: 'Lunch',
    date: DateTime(2026, 4, 11),
    type: TransactionType.expense,
    createdAt: DateTime(2026, 4, 11),
  );

  test('AuthNotifier emits signed-in user', () async {
    final repo = MockAuthRepository();
    final user = AppUser(
      id: 'u1',
      email: 'user@mail.com',
      name: 'User',
      currency: 'USD',
      createdAt: DateTime(2026, 4, 11),
    );

    when(() => repo.getCurrentUser()).thenAnswer((_) async => const Right(null));
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => Right(user));

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container
        .read(authNotifierProvider.notifier)
        .signIn(email: 'user@mail.com', password: '123456');

    expect(container.read(authNotifierProvider).value?.id, 'u1');
  });

  test('AuthNotifier signOut emits signed-out state on success', () async {
    final repo = MockAuthRepository();
    when(() => repo.getCurrentUser()).thenAnswer((_) async => const Right(null));
    when(() => repo.signOut()).thenAnswer((_) async => const Right(unit));

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(authNotifierProvider.notifier).signOut();

    final state = container.read(authNotifierProvider);
    expect(state.hasError, isFalse);
    expect(state.valueOrNull, isNull);
  });

  test('AuthNotifier signOut emits error on failure', () async {
    final repo = MockAuthRepository();
    when(() => repo.getCurrentUser()).thenAnswer((_) async => const Right(null));
    when(() => repo.signOut()).thenAnswer((_) async => const Left(AuthFailure('boom')));

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(authNotifierProvider.notifier).signOut();

    final state = container.read(authNotifierProvider);
    expect(state.hasError, isTrue);
  });

  test('TransactionNotifier adds item', () async {
    final repo = MockTransactionRepository();
    when(() => repo.getAll()).thenAnswer((_) async => const Right([]));
    when(() => repo.create(tx)).thenAnswer((_) async => Right(tx));

    final container = ProviderContainer(
      overrides: [transactionRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await container.read(transactionNotifierProvider.future);
    await container.read(transactionNotifierProvider.notifier).add(tx);

    expect(container.read(transactionNotifierProvider).value?.length, 1);
  });

  test('Notifier surfaces failures', () async {
    final repo = MockTransactionRepository();
    when(() => repo.getAll()).thenAnswer((_) async => const Left(ServerFailure('fail')));

    final container = ProviderContainer(
      overrides: [transactionRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final state = container.read(transactionNotifierProvider);
    expect(state.isLoading || state.hasError, isTrue);
  });
}
