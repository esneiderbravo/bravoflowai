import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
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
  @override
  Future<AppUser?> build() async {
    final result = await ref.read(authRepositoryProvider).getCurrentUser();
    return result.getOrElse((_) => null);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password);
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
    final result = await ref.read(authRepositoryProvider).signUp(
          email: email,
          password: password,
          name: name,
        );
    state = result.match(
      (failure) => AsyncError(AppException(failure), StackTrace.current),
      AsyncData.new,
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}

