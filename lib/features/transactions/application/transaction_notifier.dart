import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../domain/entities/transaction.dart';
import 'transaction_providers.dart';

/// Manages the list of [Transaction] entities.
class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  Future<List<Transaction>> build() async {
    final result =
        await ref.read(transactionRepositoryProvider).getAll();
    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> add(Transaction transaction) async {
    final result =
        await ref.read(transactionRepositoryProvider).create(transaction);
    result.match(
      (failure) => state =
          AsyncError(AppException(failure), StackTrace.current),
      (saved) => state = AsyncData([
        saved,
        ...state.valueOrNull ?? [],
      ]),
    );
  }

  Future<void> remove(String id) async {
    final result =
        await ref.read(transactionRepositoryProvider).delete(id);
    result.match(
      (failure) => state =
          AsyncError(AppException(failure), StackTrace.current),
      (_) => state = AsyncData(
        (state.valueOrNull ?? []).where((t) => t.id != id).toList(),
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

