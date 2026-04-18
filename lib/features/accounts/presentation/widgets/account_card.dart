import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../application/account_balance_provider.dart';

/// Account card used in the Accounts list screen — Luminous Stratum style.
class AccountCard extends ConsumerWidget {
  const AccountCard({super.key, required this.account, this.onTap});

  final Account account;
  final VoidCallback? onTap;

  static IconData _iconForType(AccountType type) => switch (type) {
    AccountType.checking => Icons.account_balance_outlined,
    AccountType.savings => Icons.savings_outlined,
    AccountType.cash => Icons.payments_outlined,
    AccountType.investment => Icons.trending_up_outlined,
    AccountType.other => Icons.wallet_outlined,
  };

  static Color _accentForType(AccountType type) => switch (type) {
    AccountType.checking => AppColors.primaryFixed,
    AccountType.savings => AppColors.secondary,
    AccountType.investment => AppColors.tertiary,
    AccountType.cash => AppColors.tertiaryFixed,
    AccountType.other => AppColors.onSurfaceVariant,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(accountBalanceProvider(account.id));
    final accent = _accentForType(account.type);

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            JeweledIcon(icon: _iconForType(account.type), iconColor: accent),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    account.type.name.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                balanceAsync.when(
                  loading: () => const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryFixed),
                  ),
                  error: (e, _) => Text('—', style: AppTextStyles.bodySmall),
                  data: (balance) => Text(
                    balance.toString(),
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: balance.amount >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'AVAILABLE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryFixed,
                    fontSize: 8,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
