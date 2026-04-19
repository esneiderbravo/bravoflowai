import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'quick_add_sheet.dart';

/// Persistent bottom-navigation shell used by all main app routes.
///
/// Implements the Luminous Stratum glass bottom-nav:
/// - [AppColors.surface] @ 90 % + backdrop blur 24
/// - Rounded top corners at [AppSpacing.radiusXl]
/// - 2 tabs: Home / More with a "+" action item in the center
/// - Active tab: [AppColors.primaryFixed] pill indicator
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabPaths = ['/dashboard', '/more'];
  static const _tabIcons = [Icons.grid_view_rounded, Icons.more_horiz_rounded];

  int _locationToIndex(String location) {
    for (var i = 0; i < _tabPaths.length; i++) {
      if (location.startsWith(_tabPaths[i])) return i;
    }
    return 0;
  }

  void _openQuickAdd(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickAddSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tabs = [
      _TabItem(icon: _tabIcons[0], label: l10n.tab_home, path: _tabPaths[0]),
      _TabItem(icon: _tabIcons[1], label: l10n.tab_more, path: _tabPaths[1]),
    ];

    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: child,
      bottomNavigationBar: _GlassNavBar(
        currentIndex: currentIndex,
        tabs: tabs,
        onTap: (i) => context.go(tabs[i].path),
        onAddTap: () => _openQuickAdd(context),
      ),
    );
  }
}

// ── Glass nav bar (3 tabs + center "+" action item) ──────────────────────────

class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
    required this.onAddTap,
  });

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Split tabs: first half | "+" | second half
    final leftTabs = tabs.sublist(0, (tabs.length / 2).ceil());
    final rightTabs = tabs.sublist((tabs.length / 2).ceil());

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
            border: Border(
              top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.4), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.12),
                blurRadius: 32,
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
            children: [
              ...leftTabs.map((t) {
                final i = tabs.indexOf(t);
                return _NavTabItem(tab: t, isActive: i == currentIndex, onTap: () => onTap(i));
              }),
              _AddNavItem(onTap: onAddTap),
              ...rightTabs.map((t) {
                final i = tabs.indexOf(t);
                return _NavTabItem(tab: t, isActive: i == currentIndex, onTap: () => onTap(i));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Inline "+" action item inside the nav bar ─────────────────────────────────

class _AddNavItem extends StatefulWidget {
  const _AddNavItem({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_AddNavItem> createState() => _AddNavItemState();
}

class _AddNavItemState extends State<_AddNavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _ctrl.reverse();
  void _onTapUp(TapUpDetails _) => _ctrl.forward().then((_) => widget.onTap());
  void _onTapCancel() => _ctrl.forward();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Transform.scale(scale: _ctrl.value, child: child),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primaryFixed, AppColors.secondary],
              begin: Alignment(-0.7071, -0.7071),
              end: Alignment(0.7071, 0.7071),
            ),
            boxShadow: AppColors.aiGlow(),
          ),
          child: const Icon(Icons.add_rounded, color: AppColors.onPrimary, size: 24),
        ),
      ),
    );
  }
}

// ── Nav tab item ──────────────────────────────────────────────────────────────

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({required this.tab, required this.isActive, required this.onTap});

  final _TabItem tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryFixed : AppColors.onSurfaceVariant;

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
                    AppColors.primaryFixed.withValues(alpha: 0.18),
                    AppColors.secondary.withValues(alpha: 0.18),
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
