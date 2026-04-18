import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../core/error/failure.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/repositories/account_repository.dart';
import 'dtos/account_dto.dart';

/// Supabase implementation of [AccountRepository].
class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, List<Account>>> getAll() async {
    try {
      final rows = await client.from('accounts').select().order('created_at', ascending: true);
      final accounts = (rows as List)
          .map((r) => AccountDto.fromJson(r as Map<String, dynamic>).toDomain())
          .toList();
      return Right(accounts);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> getById(String id) async {
    try {
      final row = await client.from('accounts').select().eq('id', id).single();
      return Right(AccountDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> create(Account account) async {
    try {
      final dto = AccountDto.fromDomain(account);
      final row = await client.from('accounts').insert(dto.toJson()).select().single();
      return Right(AccountDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> update(Account account) async {
    try {
      final dto = AccountDto.fromDomain(account);
      final row = await client
          .from('accounts')
          .update(dto.toJson())
          .eq('id', account.id)
          .select()
          .single();
      return Right(AccountDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await client.from('accounts').delete().eq('id', id);
      return const Right(unit);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
