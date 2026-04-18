import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../domain/entities/user.dart';
import 'auth_providers.dart';

/// Manages the authenticated [AppUser] state.
///
/// [state] is:
///  - [AsyncLoading] — operation in progress
///  - [AsyncData(AppUser)] — signed in
///  - [AsyncData(null)] — signed out
///  - [AsyncError] — last operation failed
class AuthNotifier extends AsyncNotifier<AppUser?> {
  bool _isSigningOut = false;

  @override
  Future<AppUser?> build() async {
    final result = await ref.read(authRepositoryProvider).getCurrentUser();
    return result.fold((_) => null, (user) => user);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).signIn(email: email, password: password);
    state = result.match(
      (failure) => AsyncError(AppException(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signUp(email: email, password: password, name: name);
    state = result.match(
      (failure) => AsyncError(AppException(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signOut() async {
    if (_isSigningOut) return;
    _isSigningOut = true;
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).signOut();
    state = result.match(
      (_) =>
          AsyncError(const AppException(AuthFailure('close_session_failed')), StackTrace.current),
      (_) => const AsyncData(null),
    );
    _isSigningOut = false;
  }
}
