import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';

/// Gradient balance summary card.
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
    final changeColor = isPositiveChange ? AppColors.success : AppColors.error;
    final changeIcon = isPositiveChange ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    final sign = isPositiveChange ? '+' : '';

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: AppColors.aiGlow(AppColors.primaryBlue),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Balance', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppConstants.spacingSm),
            Text(AppUtils.formatCurrency(totalBalance), style: AppTextStyles.displayLarge),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                Icon(changeIcon, color: changeColor, size: 16),
                const SizedBox(width: AppConstants.spacingXs),
                Text(
                  '$sign${monthlyChangePct.toStringAsFixed(1)}% this month',
                  style: AppTextStyles.bodySmall.copyWith(color: changeColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
