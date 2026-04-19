import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../application/account_balance_provider.dart';
import '../../application/account_providers.dart';
import 'account_card.dart';

/// Horizontal scrollable accounts strip for the Dashboard.
class AccountsScrollWidget extends ConsumerWidget {
  const AccountsScrollWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountNotifierProvider);

    return accountsAsync.when(
      loading: () => const SizedBox(
        height: 192,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
      data: (accounts) {
        if (accounts.isEmpty) {
          return SizedBox(
            height: 192,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [_AddAccountCard(onTap: () => context.push('/more/accounts/add'))],
            ),
          );
        }

        return SizedBox(
          height: 192,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: accounts.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final account = accounts[index];
              return _AccountHeroCard(
                account: account,
                onTap: () => context.push('/more/accounts/${account.id}'),
              );
            },
          ),
        );
      },
    );
  }
}

/// Individual scrollable account card.
class _AccountHeroCard extends ConsumerWidget {
  const _AccountHeroCard({required this.account, this.onTap});

  final Account account;
  final VoidCallback? onTap;

  static Color _accentForType(AccountType type) => switch (type) {
    AccountType.checking => AppColors.primaryFixed,
    AccountType.savings => AppColors.secondary,
    AccountType.investment => AppColors.tertiary,
    AccountType.cash => AppColors.tertiaryFixed,
    AccountType.other => AppColors.onSurfaceVariant,
  };

  static IconData _iconForType(AccountType type) => switch (type) {
    AccountType.checking => Icons.account_balance_wallet_outlined,
    AccountType.savings => Icons.savings_outlined,
    AccountType.cash => Icons.payments_outlined,
    AccountType.investment => Icons.trending_up_outlined,
    AccountType.other => Icons.wallet_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = _accentForType(account.type);
    final balanceAsync = ref.watch(accountBalanceProvider(account.id));

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 280,
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Header row ─────────────────────────────────────────────
              Row(
                children: [
                  // Accent bar
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    accountTypeName(AppLocalizations.of(context), account.type).toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              // ── Balance ───────────────────────────────────────────────
              balanceAsync.when(
                loading: () => const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryFixed),
                ),
                error: (e, _) => Text('—', style: AppTextStyles.headingSmall),
                data: (b) => Text(
                  b.toString(),
                  style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              // ── Footer row ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(account.name, style: AppTextStyles.bodySmall),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconForType(account.type), color: accent, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAccountCard extends StatelessWidget {
  const _AddAccountCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: AppColors.primaryFixed, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Add Account',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryFixed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
