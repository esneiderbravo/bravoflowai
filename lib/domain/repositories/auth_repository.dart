import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/user.dart';

/// Contract for all authentication operations.
///
/// Implementations live in [features/auth/data/repositories/].
abstract interface class AuthRepository {
  /// Sign in with email and password. Returns the authenticated [AppUser].
  Future<Either<Failure, AppUser>> signIn({required String email, required String password});

  /// Create a new account.
  ///
  /// Returns the newly created [AppUser] when Supabase signs the user in
  /// immediately (email confirmation disabled).
  /// Returns `null` when email confirmation is required — the profile is
  /// created but no session exists until the user clicks the email link.
  Future<Either<Failure, AppUser?>> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out the current user and clear the session.
  Future<Either<Failure, Unit>> signOut();

  /// Returns the currently authenticated [AppUser], or [null] if signed out.
  Future<Either<Failure, AppUser?>> getCurrentUser();
}
