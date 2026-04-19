import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../features/accounts/presentation/widgets/accounts_scroll_widget.dart';
import '../../../features/financial_overview/application/financial_overview_providers.dart';
import '../../../features/financial_overview/presentation/widgets/financial_overview_section.dart';
import '../../../shared/widgets/loading_overlay.dart';
import 'application/dashboard_providers.dart';

/// BravoFlow AI — Dashboard Screen (Luminous Stratum redesign)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _GlassAppBar(l10n: l10n),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (dashboard) => SafeArea(
          top: false,
          child: RefreshIndicator(
            color: AppColors.primaryFixed,
            backgroundColor: AppColors.surfaceContainerHigh,
            onRefresh: () async {
              await ref.read(dashboardNotifierProvider.notifier).refresh();
              ref.invalidate(financialSummaryProvider);
              ref.invalidate(categorySummaryProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: kToolbarHeight + AppSpacing.xl + AppSpacing.lg,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppUtils.timeBasedGreeting(l10n)}, ${dashboard.userName} 👋',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(l10n.dashboard_overview, style: AppTextStyles.headingMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Financial Overview ────────────────────────────────
                  const FinancialOverviewSection(),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Accounts Horizontal Scroll ────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(l10n.accounts_title, style: AppTextStyles.titleLarge),
                        GestureDetector(
                          onTap: () => context.go('/more/accounts'),
                          child: Text(
                            'VIEW ALL',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primaryFixed,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AccountsScrollWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphism app bar pinned at top.
class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GlassAppBar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primaryFixed, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'BravoFlow AI',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Notification bell
                  const Icon(Icons.notifications_outlined, color: AppColors.primaryFixed, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
