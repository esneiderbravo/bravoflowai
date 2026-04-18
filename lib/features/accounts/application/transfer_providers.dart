import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/services/app_providers.dart';
import '../../../domain/entities/transfer.dart';
import '../../../domain/repositories/transfer_repository.dart';
import '../data/transfer_repository_impl.dart';

final transferRepositoryProvider = Provider<TransferRepository>(
  (ref) => TransferRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

class TransferNotifier extends FamilyAsyncNotifier<List<Transfer>, String> {
  @override
  Future<List<Transfer>> build(String arg) async {
    final result = await ref.read(transferRepositoryProvider).getByAccount(arg);
    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> add(Transfer transfer) async {
    final result = await ref.read(transferRepositoryProvider).create(transfer);
    result.match(
      (failure) => state = AsyncError(AppException(failure), StackTrace.current),
      (saved) => state = AsyncData([saved, ...state.valueOrNull ?? []]),
    );
  }

  Future<void> remove(String id) async {
    final result = await ref.read(transferRepositoryProvider).delete(id);
    result.match(
      (failure) => state = AsyncError(AppException(failure), StackTrace.current),
      (_) => state = AsyncData((state.valueOrNull ?? []).where((t) => t.id != id).toList()),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

final transferNotifierProvider =
    AsyncNotifierProviderFamily<TransferNotifier, List<Transfer>, String>(TransferNotifier.new);
