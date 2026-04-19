import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../shared/widgets/glass_card.dart';

/// A single transaction row — Luminous Stratum style.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap, this.onDelete});

  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final accentColor = isIncome ? AppColors.success : AppColors.error;
    final amountPrefix = isIncome ? '+' : '-';
    final fallbackIcon = isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    final hasEmoji = transaction.category.icon != null && transaction.category.icon!.isNotEmpty;

    final dateStr =
        '${transaction.date.day.toString().padLeft(2, '0')}/'
        '${transaction.date.month.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            // ── Leading indicator ───────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: hasEmoji
                    ? Text(transaction.category.icon!, style: const TextStyle(fontSize: 20))
                    : Icon(fallbackIcon, color: accentColor, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // ── Body ────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transaction.category.name} · $dateStr',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // ── Trailing ────────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix\$${transaction.amount.amount.toStringAsFixed(2)}',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                if (onDelete != null) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.outline,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
