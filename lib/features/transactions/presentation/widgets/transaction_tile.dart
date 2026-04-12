import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../domain/entities/transaction.dart';

/// A single row in the transaction list.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap, this.onDelete});

  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final amountPrefix = isIncome ? '+' : '-';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingXs,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: amountColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Icon(
          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: amountColor,
          size: 20,
        ),
      ),
      title: Text(transaction.description, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        '${transaction.category.name} · ${transaction.date.day}/${transaction.date.month}',
        style: AppTextStyles.labelMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$amountPrefix${AppUtils.formatCurrency(transaction.amount.amount)}',
            style: AppTextStyles.headingSmall.copyWith(color: amountColor),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppConstants.spacingXs),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.textDisabled,
                size: 18,
              ),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}
