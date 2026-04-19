import 'package:flutter/material.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/category_summary.dart';

/// Shows the top spending categories for the current month with percentage bars.
class CategoryBreakdownCard extends StatelessWidget {
  const CategoryBreakdownCard({super.key, required this.categories});

  final List<CategorySummary> categories;

  static const int _maxCategories = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = categories.take(_maxCategories).toList();

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.financial_overview_top_spending.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (top.isEmpty)
            _EmptyState(message: l10n.financial_overview_no_expenses)
          else
            Column(
              children: [
                for (int i = 0; i < top.length; i++) ...[
                  _CategoryRow(summary: top[i]),
                  if (i < top.length - 1) const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.summary});

  final CategorySummary summary;

  Color get _barColor {
    if (summary.percentage >= 50) return AppColors.error;
    if (summary.percentage >= 25) return AppColors.warning;
    return AppColors.primaryFixed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (summary.categoryIcon != null) ...[
                    Text(summary.categoryIcon!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      summary.categoryName,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              summary.totalAmount.toString(),
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurface),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  value: summary.percentage / 100,
                  minHeight: 4,
                  backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(_barColor),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 36,
              child: Text(
                '${summary.percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
