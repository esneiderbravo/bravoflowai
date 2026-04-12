import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'supabase_service.dart';

/// Provides the singleton [sb.SupabaseClient].
/// Features inject this — never call [SupabaseService.client] directly.
final supabaseClientProvider = Provider<sb.SupabaseClient>((ref) => SupabaseService.client);

/// Streams Supabase [sb.AuthState] changes (sign-in, sign-out, token refresh).
/// The router listens to this provider to redirect between auth/app flows.
final authStateProvider = StreamProvider<sb.AuthState>(
  (ref) => SupabaseService.client.auth.onAuthStateChange,
);

/// Returns `true` when a valid session exists.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider).valueOrNull;
  if (authState != null) {
    return authState.session != null;
  }

  // Stream might not have emitted yet on cold start. Fall back to the
  // persisted session restored by Supabase client initialization.
  return ref.read(supabaseClientProvider).auth.currentSession != null;
});

/// Current authenticated user id, empty when signed out.
final currentUserIdProvider = Provider<String>(
  (ref) => ref.read(supabaseClientProvider).auth.currentUser?.id ?? '',
);
