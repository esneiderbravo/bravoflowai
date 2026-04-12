import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_insights/ai_insights_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/transactions/presentation/screens/transaction_list_screen.dart';
import '../../shared/widgets/app_shell.dart';
import '../services/app_providers.dart';

// ── Router refresh notifier ───────────────────────────────────────────────────

/// Bridges Riverpod auth state changes → go_router refreshListenable.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(authStateProvider, (prev, next) => notifyListeners());
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
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Not signed in → send to sign-in (unless already on an auth route)
      if (!isAuthenticated && !isAuthRoute) return '/auth/sign-in';

      // Already signed in → skip auth routes
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
          GoRoute(path: '/ai', builder: (context, state) => const AiInsightsScreen()),
          GoRoute(path: '/budget', builder: (context, state) => const BudgetScreen()),
        ],
      ),
    ],
  );
});
