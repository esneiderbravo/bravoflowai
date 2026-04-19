import 'package:flutter/material.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/financial_summary.dart';

/// Shows monthly income, expenses, and net balance for the current month.
class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({super.key, required this.summary});

  final FinancialSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final netPositive = summary.netBalance.amount >= 0;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.financial_overview_this_month.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: l10n.financial_overview_income,
                  value: summary.totalIncome.toString(),
                  valueColor: AppColors.success,
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricTile(
                  label: l10n.financial_overview_expenses,
                  value: summary.totalExpenses.toString(),
                  valueColor: AppColors.error,
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: (netPositive ? AppColors.success : AppColors.error).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.financial_overview_net_balance,
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceVariant),
                ),
                Text(
                  summary.netBalance.toString(),
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: netPositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 12),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 9,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700, color: valueColor),
        ),
      ],
    );
  }
}
