import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/budget.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/repositories/budget_repository.dart';
import '../../../../domain/value_objects/money.dart';

/// Supabase implementation of [BudgetRepository].
class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, List<Budget>>> getAll() async {
    try {
      final rows = await client
          .from('budgets')
          .select('*, categories(name)')
          .order('starts_at', ascending: false);
      final budgets = (rows as List).map((r) => _fromRow(r as Map<String, dynamic>)).toList();
      return Right(budgets);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> create(Budget budget) async {
    try {
      final row = await client
          .from('budgets')
          .insert(_toJson(budget))
          .select('*, categories(name)')
          .single();
      return Right(_fromRow(row));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> update(Budget budget) async {
    try {
      final row = await client
          .from('budgets')
          .update(_toJson(budget))
          .eq('id', budget.id)
          .select('*, categories(name)')
          .single();
      return Right(_fromRow(row));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await client.from('budgets').delete().eq('id', id);
      return const Right(unit);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Budget _fromRow(Map<String, dynamic> row) {
    final category = Category(
      id: row['category_id'] as String? ?? '',
      userId: row['user_id'] as String,
      name: (row['categories'] as Map?)?['name'] as String? ?? 'General',
    );
    final period = switch (row['period'] as String) {
      'weekly' => BudgetPeriod.weekly,
      'yearly' => BudgetPeriod.yearly,
      _ => BudgetPeriod.monthly,
    };
    return Budget(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      category: category,
      amount: Money(amount: (row['amount'] as num).toDouble()),
      period: period,
      startsAt: DateTime.parse(row['starts_at'] as String),
    );
  }

  Map<String, dynamic> _toJson(Budget budget) => {
    'user_id': budget.userId,
    'category_id': budget.category.id.isEmpty ? null : budget.category.id,
    'amount': budget.amount.amount,
    'period': budget.period.name,
    'starts_at': budget.startsAt.toIso8601String().substring(0, 10),
  };
}
