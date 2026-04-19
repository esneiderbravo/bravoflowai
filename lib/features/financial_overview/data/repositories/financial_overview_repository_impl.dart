import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/repositories/transfer_repository.dart';
import '../../../../domain/value_objects/money.dart';
import '../../domain/entities/category_summary.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/repositories/financial_overview_repository.dart';

/// Aggregates financial data from existing repositories in memory.
///
/// Transfers are net-zero at the portfolio level, so global [totalBalance]
/// is computed as: SUM(account.initialBalance + income txns - expense txns).
/// Per-account transfer logic is handled by [accountBalanceProvider] separately.
class FinancialOverviewRepositoryImpl implements FinancialOverviewRepository {
  const FinancialOverviewRepositoryImpl({
    required this.accountRepository,
    required this.transactionRepository,
    required this.transferRepository,
  });

  final AccountRepository accountRepository;
  final TransactionRepository transactionRepository;
  final TransferRepository transferRepository;

  @override
  Future<Either<Failure, FinancialSummary>> getFinancialSummary(DateTime month) async {
    final accountsResult = await accountRepository.getAll();
    if (accountsResult.isLeft()) return Left(accountsResult.getLeft().toNullable()!);

    final txnsResult = await transactionRepository.getAll();
    if (txnsResult.isLeft()) return Left(txnsResult.getLeft().toNullable()!);

    final accounts = accountsResult.getRight().toNullable()!;
    final allTransactions = txnsResult.getRight().toNullable()!;

    final totalBalance = _computeTotalBalance(accounts, allTransactions);
    final monthlyTotals = _computeMonthlyTotals(allTransactions, month);

    return Right(
      FinancialSummary(
        totalBalance: totalBalance,
        totalIncome: monthlyTotals.$1,
        totalExpenses: monthlyTotals.$2,
        netBalance: monthlyTotals.$1 - monthlyTotals.$2,
      ),
    );
  }

  @override
  Future<Either<Failure, List<CategorySummary>>> getCategorySummaries(DateTime month) async {
    final txnsResult = await transactionRepository.getAll();
    if (txnsResult.isLeft()) return Left(txnsResult.getLeft().toNullable()!);

    final allTransactions = txnsResult.getRight().toNullable()!;
    final categories = _computeCategorySummaries(allTransactions, month);
    return Right(categories);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Global balance = SUM per account of (initialBalance + income - expense).
  /// Transfers net to zero across the portfolio and are intentionally excluded.
  Money _computeTotalBalance(List<Account> accounts, List<Transaction> transactions) {
    double total = 0;
    for (final account in accounts) {
      total += account.initialBalance.amount;
      for (final txn in transactions.where((t) => t.accountId == account.id)) {
        if (txn.isIncome) {
          total += txn.amount.amount;
        } else {
          total -= txn.amount.amount;
        }
      }
    }
    return Money(amount: total);
  }

  /// Returns (totalIncome, totalExpenses) for the given calendar month.
  (Money, Money) _computeMonthlyTotals(List<Transaction> transactions, DateTime month) {
    final monthly = transactions.where((t) => _isSameMonth(t.date, month));
    double income = 0;
    double expenses = 0;
    for (final txn in monthly) {
      if (txn.isIncome) {
        income += txn.amount.amount;
      } else {
        expenses += txn.amount.amount;
      }
    }
    return (Money(amount: income), Money(amount: expenses));
  }

  /// Groups monthly expense transactions by category and computes percentages.
  List<CategorySummary> _computeCategorySummaries(List<Transaction> transactions, DateTime month) {
    final monthlyExpenses = transactions
        .where((t) => t.isExpense && _isSameMonth(t.date, month))
        .toList();

    if (monthlyExpenses.isEmpty) return [];

    final totalsById = <String, double>{};
    final categoryMeta = <String, Transaction>{};

    for (final txn in monthlyExpenses) {
      totalsById[txn.category.id] = (totalsById[txn.category.id] ?? 0) + txn.amount.amount;
      categoryMeta.putIfAbsent(txn.category.id, () => txn);
    }

    final grandTotal = totalsById.values.fold(0.0, (a, b) => a + b);

    final summaries = totalsById.entries.map((entry) {
      final meta = categoryMeta[entry.key]!;
      return CategorySummary(
        categoryId: entry.key,
        categoryName: meta.category.name,
        totalAmount: Money(amount: entry.value),
        percentage: grandTotal > 0 ? (entry.value / grandTotal) * 100 : 0,
        categoryIcon: meta.category.icon,
        categoryColor: meta.category.color,
      );
    }).toList()..sort((a, b) => b.totalAmount.amount.compareTo(a.totalAmount.amount));

    return summaries;
  }

  bool _isSameMonth(DateTime date, DateTime month) =>
      date.year == month.year && date.month == month.month;
}
