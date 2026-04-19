import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/category_summary.dart';
import '../entities/financial_summary.dart';

/// Contract for computing aggregated financial data.
///
/// Implementations fetch accounts and transactions via the existing
/// repositories and perform all aggregation in memory — no new DB tables.
abstract interface class FinancialOverviewRepository {
  /// Returns a [FinancialSummary] with global totals and the current-month
  /// income / expense / net summary.
  Future<Either<Failure, FinancialSummary>> getFinancialSummary(DateTime month);

  /// Returns expense [CategorySummary] items for [month], sorted by
  /// total amount descending.
  Future<Either<Failure, List<CategorySummary>>> getCategorySummaries(DateTime month);
}
