import 'package:flutter/material.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Balance summary hero card (glass + gradient).
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlyChangePct,
    required this.isPositiveChange,
  });

  final double totalBalance;
  final double monthlyChangePct;
  final bool isPositiveChange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final changeColor = isPositiveChange ? AppColors.success : AppColors.error;
    final changeIcon = isPositiveChange ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    final sign = isPositiveChange ? '+' : '';

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.total_balance,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(AppUtils.formatCurrency(totalBalance), style: AppTextStyles.displayMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(changeIcon, color: changeColor, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.monthly_change('$sign${monthlyChangePct.toStringAsFixed(1)}'),
                style: AppTextStyles.bodySmall.copyWith(color: changeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
