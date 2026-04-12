/// BravoFlow AI — Typed Failure Hierarchy
///
/// All repository methods return [Either<Failure, T>] instead of throwing.
/// The UI maps [Failure] → user-readable messages via [FailureExtension].
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// A Supabase / HTTP server returned an error response.
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// No internet connection or DNS/socket failure.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Authentication / authorisation error (401, 403, session expired).
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Local storage read/write error.
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Input did not pass domain validation rules.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Catch-all for truly unexpected errors.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}

/// Extension to convert a [Failure] to a user-facing message string.
extension FailureExtension on Failure {
  String get userMessage => switch (this) {
    ServerFailure(message: final m) => m,
    NetworkFailure() => 'Please check your internet connection.',
    AuthFailure(message: final m) => m,
    CacheFailure() => 'Failed to access local storage.',
    ValidationFailure(message: final m) => m,
    UnknownFailure() => 'Something went wrong. Please try again.',
  };
}
