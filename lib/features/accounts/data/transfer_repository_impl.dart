import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../core/error/failure.dart';
import '../../../domain/entities/transfer.dart';
import '../../../domain/repositories/transfer_repository.dart';
import 'dtos/transfer_dto.dart';

/// Supabase implementation of [TransferRepository].
class TransferRepositoryImpl implements TransferRepository {
  const TransferRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, List<Transfer>>> getByAccount(String accountId) async {
    try {
      final rows = await client
          .from('transfers')
          .select()
          .or('from_account_id.eq.$accountId,to_account_id.eq.$accountId')
          .order('date', ascending: false);
      final transfers = (rows as List)
          .map((r) => TransferDto.fromJson(r as Map<String, dynamic>).toDomain())
          .toList();
      return Right(transfers);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transfer>> create(Transfer transfer) async {
    try {
      final dto = TransferDto.fromDomain(transfer);
      final row = await client.from('transfers').insert(dto.toJson()).select().single();
      return Right(TransferDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await client.from('transfers').delete().eq('id', id);
      return const Right(unit);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
