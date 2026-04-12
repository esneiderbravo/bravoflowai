import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../application/budget_providers.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetNotifierProvider);
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tab_budget, style: AppTextStyles.headingLarge)),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (budgets) => budgets.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.textDisabled,
                      size: 64,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(l10n.budget_empty_title, style: AppTextStyles.headingSmall),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(l10n.budget_empty_message, style: AppTextStyles.bodySmall),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                itemCount: budgets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppConstants.spacingMd),
                itemBuilder: (context, i) {
                  final budget = budgets[i];
                  return Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(budget.category.name, style: AppTextStyles.headingSmall),
                              Text(budget.period.name, style: AppTextStyles.labelMedium),
                            ],
                          ),
                        ),
                        Text(
                          AppUtils.formatCurrency(budget.amount.amount),
                          style: AppTextStyles.headingMedium.copyWith(color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
