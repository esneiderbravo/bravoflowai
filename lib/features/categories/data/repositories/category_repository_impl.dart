import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../dtos/category_dto.dart';

/// Supabase implementation of [CategoryRepository].
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, List<Category>>> fetchAll() async {
    try {
      final rows = await client.from('categories').select().order('is_default', ascending: false);
      final categories = (rows as List)
          .map((r) => CategoryDto.fromJson(r as Map<String, dynamic>).toDomain())
          .toList();
      return Right(categories);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> add(Category category) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('Not authenticated'));
      final dto = CategoryDto.fromDomain(category);
      final payload = dto.toJson()..['user_id'] = userId;
      final row = await client.from('categories').insert(payload).select().single();
      return Right(CategoryDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> update(Category category) async {
    try {
      final dto = CategoryDto.fromDomain(category);
      // Exclude user_id from update payload — ownership enforced by RLS
      final payload = dto.toJson()..remove('user_id');
      final row = await client
          .from('categories')
          .update(payload)
          .eq('id', category.id)
          .select()
          .single();
      return Right(CategoryDto.fromJson(row).toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(String id) async {
    try {
      await client.from('categories').delete().eq('id', id);
      return const Right(unit);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
