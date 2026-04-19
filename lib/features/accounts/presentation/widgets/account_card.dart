import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../application/account_balance_provider.dart';

String accountTypeName(AppLocalizations l10n, AccountType type) => switch (type) {
  AccountType.checking => l10n.account_type_checking,
  AccountType.savings => l10n.account_type_savings,
  AccountType.cash => l10n.account_type_cash,
  AccountType.investment => l10n.account_type_investment,
  AccountType.other => l10n.account_type_other,
};

/// Account list card — Luminous Stratum style matching the balance hero card.
class AccountCard extends ConsumerWidget {
  const AccountCard({super.key, required this.account, this.onTap});

  final Account account;
  final VoidCallback? onTap;

  static IconData _iconForType(AccountType type) => switch (type) {
    AccountType.checking => Icons.credit_card_rounded,
    AccountType.savings => Icons.savings_rounded,
    AccountType.cash => Icons.payments_rounded,
    AccountType.investment => Icons.trending_up_rounded,
    AccountType.other => Icons.account_balance_wallet_rounded,
  };

  static Color _fallbackAccent(AccountType type) => switch (type) {
    AccountType.checking => AppColors.primaryFixed,
    AccountType.savings => AppColors.secondary,
    AccountType.investment => AppColors.tertiary,
    AccountType.cash => AppColors.tertiaryFixed,
    AccountType.other => AppColors.onSurfaceVariant,
  };

  Color _accent() {
    if (account.color != null && account.color!.isNotEmpty) {
      try {
        return Color(int.parse('FF${account.color!.replaceAll('#', '')}', radix: 16));
      } catch (_) {}
    }
    return _fallbackAccent(account.type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final balanceAsync = ref.watch(accountBalanceProvider(account.id));
    final accent = _accent();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceContainerHigh, accent.withValues(alpha: 0.06)],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: Stack(
            children: [
              // Ambient glow blob
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    // Account icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Icon(_iconForType(account.type), color: accent, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),

                    // Name + type/currency/default badges
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _Chip(
                                label: accountTypeName(
                                  AppLocalizations.of(context),
                                  account.type,
                                ).toUpperCase(),
                                color: accent,
                              ),
                              _Chip(
                                label: account.currency,
                                color: AppColors.onSurfaceVariant,
                                outlined: true,
                              ),
                              if (account.isDefault)
                                _Chip(
                                  label: AppLocalizations.of(context).label_default,
                                  color: AppColors.success,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),

                    // Balance + available label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        balanceAsync.when(
                          loading: () => const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryFixed,
                            ),
                          ),
                          error: (e, _) => Text('—', style: AppTextStyles.bodySmall),
                          data: (balance) => FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              balance.toString(),
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: balance.amount >= 0 ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.account_available_label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.outline,
                            fontSize: 8,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: accent.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, this.outlined = false});

  final String label;
  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: outlined ? 0.3 : 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Manrope',
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
