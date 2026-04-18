import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Persistent bottom-navigation shell used by all main app routes.
///
/// Implements the Luminous Stratum glass bottom-nav:
/// - [AppColors.surface] @ 90 % + backdrop blur 24
/// - Rounded top corners at [AppSpacing.radiusXl]
/// - 4 tabs: Home / Flow / Bravo AI / More
/// - Active tab: [AppColors.primaryFixed] pill indicator
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem(icon: Icons.grid_view_rounded, label: 'Home', path: '/dashboard'),
    _TabItem(icon: Icons.swap_horiz_rounded, label: 'Flow', path: '/transactions'),
    _TabItem(icon: Icons.more_horiz_rounded, label: 'More', path: '/more'),
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: child,
      bottomNavigationBar: _GlassNavBar(
        currentIndex: currentIndex,
        tabs: _tabs,
        onTap: (i) => context.go(_tabs[i].path),
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({required this.currentIndex, required this.tabs, required this.onTap});

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSpacing.radiusXl),
        topRight: Radius.circular(AppSpacing.radiusXl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusXl),
              topRight: Radius.circular(AppSpacing.radiusXl),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: AppSpacing.md,
            bottom: bottomPadding + AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isActive = i == currentIndex;
              return _NavTabItem(tab: tabs[i], isActive: isActive, onTap: () => onTap(i));
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({required this.tab, required this.isActive, required this.onTap});

  final _TabItem tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryFixed : AppColors.outline.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColors.primaryFixed.withValues(alpha: 0.10),
                    AppColors.secondary.withValues(alpha: 0.10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              tab.label.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label, required this.path});
  final IconData icon;
  final String label;
  final String path;
}
