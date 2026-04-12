import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/budget.dart';

/// Contract for budget CRUD operations.
abstract interface class BudgetRepository {
  /// Returns all budgets for the current user.
  Future<Either<Failure, List<Budget>>> getAll();

  /// Persists a new [budget] and returns the saved entity.
  Future<Either<Failure, Budget>> create(Budget budget);

  /// Updates an existing [budget] and returns the updated entity.
  Future<Either<Failure, Budget>> update(Budget budget);

  /// Permanently deletes a budget by [id].
  Future<Either<Failure, Unit>> delete(String id);
}
