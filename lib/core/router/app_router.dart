import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/app_providers.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/ai_insights/ai_insights_screen.dart';
import '../../shared/widgets/app_shell.dart';

// ── Placeholder screens for routes not yet implemented ───────────────────────

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Text('$title — Coming soon',
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
}

// ── Router refresh notifier ───────────────────────────────────────────────────

/// Bridges Riverpod auth state changes → go_router refreshListenable.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<dynamic>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final _routerNotifierProvider = Provider<_RouterNotifier>(
  (ref) {
    final notifier = _RouterNotifier(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  },
);

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
      GoRoute(
        path: '/auth/sign-in',
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (_, __) => const SignUpScreen(),
      ),

      // ── App shell routes (with bottom nav) ─────────────────────────────
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/transactions',
            builder: (_, __) =>
                const _PlaceholderScreen(title: 'Transactions'),
          ),
          GoRoute(
            path: '/ai',
            builder: (_, __) => const AiInsightsScreen(),
          ),
          GoRoute(
            path: '/budget',
            builder: (_, __) => const _PlaceholderScreen(title: 'Budget'),
          ),
        ],
      ),
    ],
  );
});

