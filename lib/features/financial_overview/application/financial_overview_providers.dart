import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../features/accounts/application/account_providers.dart';
import '../../../features/accounts/application/transfer_providers.dart';
import '../../../features/transactions/application/transaction_providers.dart';
import '../data/repositories/financial_overview_repository_impl.dart';
import '../domain/entities/category_summary.dart';
import '../domain/entities/financial_summary.dart';
import '../domain/repositories/financial_overview_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────

final financialOverviewRepositoryProvider = Provider<FinancialOverviewRepository>(
  (ref) => FinancialOverviewRepositoryImpl(
    accountRepository: ref.read(accountRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    transferRepository: ref.read(transferRepositoryProvider),
  ),
);

// ── Financial summary notifier ────────────────────────────────────────────

class FinancialOverviewNotifier extends AsyncNotifier<FinancialSummary> {
  @override
  Future<FinancialSummary> build() async {
    // Re-evaluate whenever accounts or transactions change.
    ref.watch(accountNotifierProvider);
    ref.watch(transactionNotifierProvider);

    final result = await ref
        .read(financialOverviewRepositoryProvider)
        .getFinancialSummary(DateTime.now());

    return result.getOrElse((f) => throw AppException(f));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

/// Provides the current [FinancialSummary] (global balance + monthly totals).
final financialSummaryProvider = AsyncNotifierProvider<FinancialOverviewNotifier, FinancialSummary>(
  FinancialOverviewNotifier.new,
);

// ── Category summary provider ─────────────────────────────────────────────

/// Provides the list of [CategorySummary] for the current calendar month,
/// sorted by total amount descending.
///
/// Re-evaluates whenever accounts or transactions change.
final categorySummaryProvider = FutureProvider<List<CategorySummary>>((ref) async {
  ref.watch(accountNotifierProvider);
  ref.watch(transactionNotifierProvider);

  final result = await ref
      .read(financialOverviewRepositoryProvider)
      .getCategorySummaries(DateTime.now());

  return result.getOrElse((f) => throw AppException(f));
});
