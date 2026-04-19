import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/financial_overview_providers.dart';
import 'category_breakdown_card.dart';
import 'monthly_summary_card.dart';
import 'total_balance_card.dart';

/// Composing widget that renders the full financial overview section.
///
/// Watches [financialSummaryProvider] and [categorySummaryProvider],
/// handles loading/error/data states, and delegates rendering to the
/// individual card widgets.
class FinancialOverviewSection extends ConsumerWidget {
  const FinancialOverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financialSummaryProvider);
    final categoriesAsync = ref.watch(categorySummaryProvider);

    return summaryAsync.when(
      loading: () => const _LoadingPlaceholder(),
      error: (e, _) => _ErrorPlaceholder(message: e.toString()),
      data: (summary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TotalBalanceCard(summary: summary),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: MonthlySummaryCard(summary: summary),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: categoriesAsync.when(
              loading: () => const _LoadingPlaceholder(height: 80),
              error: (e, _) => _ErrorPlaceholder(message: e.toString()),
              data: (categories) => CategoryBreakdownCard(categories: categories),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({this.height = 160});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
    );
  }
}
