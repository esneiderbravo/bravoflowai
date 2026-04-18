import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/app_localizations.dart';

/// Persistent bottom-navigation shell used by all main app routes.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem(icon: Icons.dashboard_outlined, label: _TabLabel.home, path: '/dashboard'),
    _TabItem(
      icon: Icons.receipt_long_outlined,
      label: _TabLabel.transactions,
      path: '/transactions',
    ),
    _TabItem(icon: Icons.auto_awesome_outlined, label: _TabLabel.ai, path: '/ai'),
    _TabItem(icon: Icons.account_balance_wallet_outlined, label: _TabLabel.budget, path: '/budget'),
  ];

  int _locationToIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _tabs.map((t) {
          final label = switch (t.label) {
            _TabLabel.home => context.l10n.tab_home,
            _TabLabel.transactions => context.l10n.tab_transactions,
            _TabLabel.ai => context.l10n.tab_ai,
            _TabLabel.budget => context.l10n.tab_budget,
          };
          return NavigationDestination(
            icon: Icon(t.icon),
            selectedIcon: Icon(t.icon),
            label: label,
          );
        }).toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label, required this.path});
  final IconData icon;
  final _TabLabel label;
  final String path;
}

enum _TabLabel { home, transactions, ai, budget }
