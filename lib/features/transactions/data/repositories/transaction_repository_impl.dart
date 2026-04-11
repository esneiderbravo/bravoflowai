import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/value_objects/date_range.dart';
import '../dtos/transaction_dto.dart';

/// Supabase implementation of [TransactionRepository].
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, List<Transaction>>> getAll({
    DateRange? range,
  }) async {
    try {
      final rows = range == null
          ? await client
              .from('transactions')
              .select('*, categories(name)')
              .order('date', ascending: false)
          : await client
              .from('transactions')
              .select('*, categories(name)')
              .gte('date', range.start.toIso8601String().substring(0, 10))
              .lte('date', range.end.toIso8601String().substring(0, 10))
              .order('date', ascending: false);

      final transactions = (rows as List)
          .map((r) => TransactionDto.fromJson(r as Map<String, dynamic>)
              .toDomain())
          .toList();
      return Right(transactions);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getById(String id) async {
    try {
      final row = await client
          .from('transactions')
          .select('*, categories(name)')
          .eq('id', id)
          .single();
      return Right(TransactionDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> create(Transaction transaction) async {
    try {
      final dto = TransactionDto.fromDomain(transaction);
      final row = await client
          .from('transactions')
          .insert(dto.toJson())
          .select('*, categories(name)')
          .single();
      return Right(TransactionDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> update(Transaction transaction) async {
    try {
      final dto = TransactionDto.fromDomain(transaction);
      final row = await client
          .from('transactions')
          .update(dto.toJson())
          .eq('id', transaction.id)
          .select('*, categories(name)')
          .single();
      return Right(TransactionDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await client.from('transactions').delete().eq('id', id);
      return const Right(unit);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
