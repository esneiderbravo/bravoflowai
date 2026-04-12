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
  Future<Either<Failure, AppUser>> signIn({required String email, required String password}) async {
    try {
      final response = await client.auth.signInWithPassword(email: email, password: password);
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
  Future<Either<Failure, AppUser?>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Pass name in metadata so the handle_new_user() trigger writes it to
      // public.profiles server-side (SECURITY DEFINER, bypasses RLS).
      // This avoids the 42501 error that occurs when the client has no session
      // (email confirmation required → anon role → RLS rejects the upsert).
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'full_name': name, 'currency': 'USD'},
      );
      if (response.user == null) {
        return const Left(AuthFailure('Sign up failed.'));
      }

      // No session → Supabase requires email confirmation.
      // The trigger already created the profile row — nothing left to do here.
      if (response.session == null) return const Right(null);

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
    try {
      final row = await client.from('profiles').select().eq('id', user.id).maybeSingle();

      if (row == null) {
        // Profile missing — the trigger may not have been applied yet or
        // the user pre-dates the migration. Recover with a metadata fallback.
        final fallbackName =
            user.userMetadata?['name'] as String? ?? user.email?.split('@').first ?? 'User';
        await client.from('profiles').upsert({
          'id': user.id,
          'name': fallbackName,
          'full_name': fallbackName,
          'email': user.email,
          'currency': 'USD',
        });
        final dto = UserDto.fromSupabaseUser(user, name: fallbackName);
        return Right(dto.toDomain());
      }

      final dto = UserDto.fromJson({...row, 'email': user.email ?? ''});
      return Right(dto.toDomain());
    } on sb.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
