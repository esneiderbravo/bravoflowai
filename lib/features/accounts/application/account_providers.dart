import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/services/app_providers.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/repositories/account_repository.dart';
import '../data/account_repository_impl.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

class AccountNotifier extends AsyncNotifier<List<Account>> {
  @override
  Future<List<Account>> build() async {
    final result = await ref.read(accountRepositoryProvider).getAll();
    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> add(Account account) async {
    final result = await ref.read(accountRepositoryProvider).create(account);
    result.match(
      (failure) => state = AsyncError(AppException(failure), StackTrace.current),
      (saved) => state = AsyncData([...state.valueOrNull ?? [], saved]),
    );
  }

  Future<void> edit(Account account) async {
    final result = await ref.read(accountRepositoryProvider).update(account);
    result.match(
      (failure) => state = AsyncError(AppException(failure), StackTrace.current),
      (updated) => state = AsyncData(
        (state.valueOrNull ?? []).map((a) => a.id == updated.id ? updated : a).toList(),
      ),
    );
  }

  Future<void> remove(String id) async {
    final result = await ref.read(accountRepositoryProvider).delete(id);
    result.match(
      (failure) => state = AsyncError(AppException(failure), StackTrace.current),
      (_) => state = AsyncData((state.valueOrNull ?? []).where((a) => a.id != id).toList()),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final accountNotifierProvider = AsyncNotifierProvider<AccountNotifier, List<Account>>(
  AccountNotifier.new,
);
