import 'package:equatable/equatable.dart';

import '../../../../domain/value_objects/money.dart';

/// Aggregated financial snapshot for a user.
///
/// Computed entirely in memory from existing account and transaction data.
class FinancialSummary extends Equatable {
  const FinancialSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
  });

  /// Sum of all account derived balances.
  final Money totalBalance;

  /// Total income for the current calendar month.
  final Money totalIncome;

  /// Total expenses for the current calendar month.
  final Money totalExpenses;

  /// `totalIncome - totalExpenses` for the current calendar month.
  final Money netBalance;

  /// Returns a zero-value summary using [currency].
  factory FinancialSummary.zero({Currency currency = Currency.usd}) => FinancialSummary(
    totalBalance: Money(amount: 0, currency: currency),
    totalIncome: Money(amount: 0, currency: currency),
    totalExpenses: Money(amount: 0, currency: currency),
    netBalance: Money(amount: 0, currency: currency),
  );

  @override
  List<Object> get props => [totalBalance, totalIncome, totalExpenses, netBalance];
}
