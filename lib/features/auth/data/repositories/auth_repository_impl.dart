import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../dtos/user_dto.dart';

/// Supabase implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.client});

  final sb.SupabaseClient client;

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth
          .signInWithPassword(email: email, password: password);
      if (response.user == null) {
        return const Left(AuthFailure('Sign in failed.'));
      }
      return _fetchProfile(response.user!);
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response =
          await client.auth.signUp(email: email, password: password);
      if (response.user == null) {
        return const Left(AuthFailure('Sign up failed.'));
      }
      await client.from('profiles').upsert({
        'id': response.user!.id,
        'name': name,
        'currency': 'USD',
      });
      final dto = UserDto.fromSupabaseUser(response.user!, name: name);
      return Right(dto.toDomain());
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await client.auth.signOut();
      return const Right(unit);
    } on sb.AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return const Right(null);
      return _fetchProfile(user);
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<Either<Failure, AppUser>> _fetchProfile(sb.User user) async {
    final row = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (row == null) return const Left(ServerFailure('Profile not found.'));
    final dto = UserDto.fromJson({...row, 'email': user.email ?? ''});
    return Right(dto.toDomain());
  }
}

