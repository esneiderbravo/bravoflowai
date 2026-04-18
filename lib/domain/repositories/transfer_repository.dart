import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../entities/transfer.dart';

abstract interface class TransferRepository {
  Future<Either<Failure, List<Transfer>>> getByAccount(String accountId);
  Future<Either<Failure, Transfer>> create(Transfer transfer);
  Future<Either<Failure, Unit>> delete(String id);
}
