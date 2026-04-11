import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../../core/error/failure.dart';

/// Contract for all authentication operations.
///
/// Implementations live in [features/auth/data/repositories/].
abstract interface class AuthRepository {
  /// Sign in with email and password. Returns the authenticated [AppUser].
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  /// Create a new account. Returns the newly created [AppUser].
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out the current user and clear the session.
  Future<Either<Failure, Unit>> signOut();

  /// Returns the currently authenticated [AppUser], or [null] if signed out.
  Future<Either<Failure, AppUser?>> getCurrentUser();
}

