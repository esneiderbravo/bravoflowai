import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<Category>>> fetchAll();
  Future<Either<Failure, Category>> add(Category category);
  Future<Either<Failure, Category>> update(Category category);
  Future<Either<Failure, Unit>> delete(String id);
}
