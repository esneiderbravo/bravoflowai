import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/screens/account_detail_screen.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/accounts/presentation/screens/add_edit_account_screen.dart';
import '../../features/accounts/presentation/screens/add_transfer_screen.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/more/presentation/screens/more_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/transactions/presentation/screens/transaction_list_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../services/app_providers.dart';

// ── Router refresh notifier ───────────────────────────────────────────────────

/// Bridges Riverpod auth state changes → go_router refreshListenable.
///
/// Listens to both the Supabase raw stream and the Riverpod [authNotifierProvider]
/// so the router reacts immediately to sign-out regardless of which fires first.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (prev, next) => notifyListeners());
    ref.listen<AsyncValue<dynamic>>(authNotifierProvider, (prev, next) => notifyListeners());
  }
}

final _routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

// ── Router provider ───────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: notifier,
    debugLogDiagnostics: false,

    redirect: (BuildContext context, GoRouterState state) {
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Primary check: Riverpod notifier reflects sign-in/sign-out immediately,
      // before the Supabase stream has a chance to emit.
      final authNotifier = ref.read(authNotifierProvider);
      if (authNotifier is AsyncData) {
        final isAuthenticated = authNotifier.value != null;
        if (!isAuthenticated && !isAuthRoute) return '/auth/sign-in';
        if (isAuthenticated && isAuthRoute) return '/dashboard';
        return null;
      }

      // Fallback while the notifier is still loading (cold start):
      // use the Supabase stream + persisted session.
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      if (!isAuthenticated && !isAuthRoute) return '/auth/sign-in';
      if (isAuthenticated && isAuthRoute) return '/dashboard';

      return null; // no redirect needed
    },

    routes: [
      // ── Auth routes (no shell / no bottom nav) ──────────────────────────
      GoRoute(path: '/auth/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/auth/sign-up', builder: (context, state) => const SignUpScreen()),

      // ── App shell routes (with bottom nav) ─────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(
            path: '/transactions',
            builder: (context, state) => const TransactionListScreen(),
          ),
          GoRoute(
            path: '/transactions/add',
            builder: (context, state) => const AddTransactionScreen(),
          ),
          GoRoute(path: '/more', builder: (context, state) => const MoreScreen()),
          GoRoute(path: '/more/accounts', builder: (context, state) => const AccountsScreen()),
          GoRoute(
            path: '/more/accounts/add',
            builder: (context, state) => const AddEditAccountScreen(),
          ),
          GoRoute(
            path: '/more/accounts/transfer/add',
            builder: (context, state) => const AddTransferScreen(),
          ),
          GoRoute(
            path: '/more/accounts/:id',
            builder: (context, state) =>
                AccountDetailScreen(accountId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/more/accounts/:id/edit',
            builder: (context, state) =>
                AddEditAccountScreen(accountId: state.pathParameters['id']),
          ),
        ],
      ),
    ],
  );
});
