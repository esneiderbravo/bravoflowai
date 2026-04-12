import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/services/app_providers.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../data/repositories/budget_repository_impl.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => BudgetRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

final budgetNotifierProvider = AsyncNotifierProvider<BudgetNotifier, List<Budget>>(
  BudgetNotifier.new,
);

/// Manages the list of [Budget] entities.
class BudgetNotifier extends AsyncNotifier<List<Budget>> {
  @override
  Future<List<Budget>> build() async {
    final result = await ref.read(budgetRepositoryProvider).getAll();
    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> add(Budget budget) async {
    final result = await ref.read(budgetRepositoryProvider).create(budget);
    result.match(
      (f) => state = AsyncError(AppException(f), StackTrace.current),
      (saved) => state = AsyncData([saved, ...state.valueOrNull ?? []]),
    );
  }

  Future<void> remove(String id) async {
    final result = await ref.read(budgetRepositoryProvider).delete(id);
    result.match(
      (f) => state = AsyncError(AppException(f), StackTrace.current),
      (_) => state = AsyncData((state.valueOrNull ?? []).where((b) => b.id != id).toList()),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
