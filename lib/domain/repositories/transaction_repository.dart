import 'package:fpdart/fpdart.dart';
import '../entities/transaction.dart';
import '../value_objects/date_range.dart';
import '../../core/error/failure.dart';

/// Contract for transaction CRUD operations against the data source.
abstract interface class TransactionRepository {
  /// Returns all transactions, optionally filtered by [range].
  Future<Either<Failure, List<Transaction>>> getAll({DateRange? range});

  /// Returns a single transaction by [id].
  Future<Either<Failure, Transaction>> getById(String id);

  /// Persists a new [transaction] and returns the saved entity.
  Future<Either<Failure, Transaction>> create(Transaction transaction);

  /// Updates an existing [transaction] and returns the updated entity.
  Future<Either<Failure, Transaction>> update(Transaction transaction);

  /// Permanently deletes a transaction by [id].
  Future<Either<Failure, Unit>> delete(String id);
}

