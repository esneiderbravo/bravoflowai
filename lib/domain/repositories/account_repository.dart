import 'package:fpdart/fpdart.dart';
import '../../core/error/failure.dart';
import '../entities/account.dart';

abstract interface class AccountRepository {
  Future<Either<Failure, List<Account>>> getAll();
  Future<Either<Failure, Account>> getById(String id);
  Future<Either<Failure, Account>> create(Account account);
  Future<Either<Failure, Account>> update(Account account);
  Future<Either<Failure, Unit>> delete(String id);
}
