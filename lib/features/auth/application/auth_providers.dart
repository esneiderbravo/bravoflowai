import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/app_providers.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import 'auth_notifier.dart';

/// Provides the [AuthRepository] implementation (Supabase).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

/// Provides the [AuthNotifier] — the single source of truth for auth state.
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);
