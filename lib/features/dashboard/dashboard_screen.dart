import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../shared/widgets/ai_insight_chip.dart';
import '../../../shared/widgets/loading_overlay.dart';
import 'application/dashboard_providers.dart';
import 'presentation/widgets/balance_card.dart';
import 'presentation/widgets/quick_actions_row.dart';

/// BravoFlow AI — Dashboard Screen
///
/// Pure presentation: observes [dashboardNotifierProvider], renders state.
/// No business logic lives here.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(dashboardNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.app_title, style: AppTextStyles.headingLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingMd),
            child: InkWell(
              onTap: () => context.go('/profile'),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.person_outline_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (dashboard) => SafeArea(
          child: RefreshIndicator(
            color: AppColors.primaryBlue,
            onRefresh: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ──────────────────────────────────────────
                  Text(
                    l10n.greeting_with_name(
                      AppUtils.timeBasedGreeting(l10n),
                      dashboard.userName,
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(l10n.dashboard_overview, style: AppTextStyles.displayMedium),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Balance Card ───────────────────────────────────────
                  BalanceCard(
                    totalBalance: dashboard.totalBalance,
                    monthlyChangePct: dashboard.monthlyChangePct,
                    isPositiveChange: dashboard.isPositiveChange,
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── AI Insights ────────────────────────────────────────
                  Row(
                    children: [
                      Text(l10n.ai_insights, style: AppTextStyles.headingMedium),
                      const SizedBox(width: AppConstants.spacingSm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingSm,
                          vertical: AppConstants.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(l10n.beta_label, style: AppTextStyles.labelSmall),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...dashboard.aiInsightPreviews.map(
                    (insight) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
                      child: AiInsightChip(icon: Icons.lightbulb_outline_rounded, label: insight),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Quick Actions ─────────────────────────────────────
                  Text(l10n.quick_actions, style: AppTextStyles.headingMedium),
                  const SizedBox(height: AppConstants.spacingMd),
                  const QuickActionsRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
