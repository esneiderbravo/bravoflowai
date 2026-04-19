import 'package:flutter/material.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/financial_summary.dart';

/// Displays the user's aggregated total balance across all accounts.
class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key, required this.summary});

  final FinancialSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.financial_overview_total_balance.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            summary.totalBalance.toString(),
            style: AppTextStyles.headingLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: summary.totalBalance.amount >= 0 ? AppColors.onSurface : AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.financial_overview_across_accounts,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
