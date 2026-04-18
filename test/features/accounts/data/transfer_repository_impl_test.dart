import 'package:bravoflowai/domain/entities/transfer.dart';
import 'package:bravoflowai/domain/repositories/transfer_repository.dart';
import 'package:bravoflowai/domain/value_objects/money.dart';
import 'package:bravoflowai/features/accounts/application/transfer_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTransferRepository extends Mock implements TransferRepository {}

Transfer _makeTransfer({String id = 'tr1'}) => Transfer(
  id: id,
  userId: 'u1',
  fromAccountId: 'acc1',
  toAccountId: 'acc2',
  amount: const Money(amount: 50),
  date: DateTime(2026, 4, 18),
  createdAt: DateTime(2026, 4, 18),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_makeTransfer());
  });

  group('TransferNotifier', () {
    test('build loads transfers by account', () async {
      final repo = MockTransferRepository();
      final transfer = _makeTransfer();
      when(() => repo.getByAccount('acc1')).thenAnswer((_) async => Right([transfer]));

      final container = ProviderContainer(
        overrides: [transferRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final value = await container.read(transferNotifierProvider('acc1').future);
      expect(value.length, 1);
      expect(value.first.id, 'tr1');
    });

    test('add appends transfer to list', () async {
      final repo = MockTransferRepository();
      final transfer = _makeTransfer();
      when(() => repo.getByAccount('acc1')).thenAnswer((_) async => const Right([]));
      when(() => repo.create(any())).thenAnswer((_) async => Right(transfer));

      final container = ProviderContainer(
        overrides: [transferRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(transferNotifierProvider('acc1').future);
      await container.read(transferNotifierProvider('acc1').notifier).add(transfer);

      expect(container.read(transferNotifierProvider('acc1')).value?.length, 1);
    });

    test('remove deletes transfer from list', () async {
      final repo = MockTransferRepository();
      final transfer = _makeTransfer();
      when(() => repo.getByAccount('acc1')).thenAnswer((_) async => Right([transfer]));
      when(() => repo.delete('tr1')).thenAnswer((_) async => const Right(unit));

      final container = ProviderContainer(
        overrides: [transferRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(transferNotifierProvider('acc1').future);
      await container.read(transferNotifierProvider('acc1').notifier).remove('tr1');

      expect(container.read(transferNotifierProvider('acc1')).value?.isEmpty, isTrue);
    });
  });
}
