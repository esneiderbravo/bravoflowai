import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/value_objects/money.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../../transactions/application/transaction_providers.dart';
import '../../application/account_balance_provider.dart';
import '../../application/account_providers.dart';
import '../widgets/account_card.dart';

final _currencyFmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({super.key, required this.accountId});

  final String accountId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final transactions = ref.read(transactionNotifierProvider).valueOrNull ?? [];
    final hasTxns = transactions.any((t) => t.accountId == accountId);

    if (hasTxns) {
      context.showErrorSnack(l10n.delete_account_has_transactions);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete_account),
        content: Text(l10n.delete_account_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.close_session_confirm_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete_account, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(accountNotifierProvider.notifier).remove(accountId);
      if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accounts = ref.watch(accountNotifierProvider).valueOrNull ?? [];
    final account = accounts.where((a) => a.id == accountId).firstOrNull;
    final balanceAsync = ref.watch(accountBalanceProvider(accountId));
    final allTransactions = ref.watch(transactionNotifierProvider).valueOrNull ?? [];
    final accountTransactions = allTransactions.where((t) => t.accountId == accountId).toList();
    final incomeTransactions = accountTransactions.where((t) => t.isIncome).toList();
    final expenseTransactions = accountTransactions.where((t) => t.isExpense).toList();

    final totalIncome = incomeTransactions.fold<double>(0, (sum, t) => sum + t.amount.amount);
    final totalExpenses = expenseTransactions.fold<double>(0, (sum, t) => sum + t.amount.amount);

    if (account == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primaryFixed)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _DetailAppBar(
        accountName: account.name,
        onEdit: () => context.push('/more/accounts/$accountId/edit'),
        onDelete: () => _confirmDelete(context, ref),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + AppSpacing.xxl + AppSpacing.lg,
            bottom: 120,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              // ── Balance Hero Card ───────────────────────────────────────
              _BalanceHeroCard(
                account: account,
                balanceAsync: balanceAsync,
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
                l10n: l10n,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Stats Row ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: l10n.flow_monthly_income,
                      value: _currencyFmt.format(totalIncome),
                      count: incomeTransactions.length,
                      icon: Icons.arrow_downward_rounded,
                      color: AppColors.success,
                      onTap: () => _showTransactionSheet(
                        context,
                        title: l10n.flow_monthly_income,
                        transactions: incomeTransactions,
                        color: AppColors.success,
                        icon: Icons.arrow_downward_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: l10n.flow_monthly_expenses,
                      value: _currencyFmt.format(totalExpenses),
                      count: expenseTransactions.length,
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.error,
                      onTap: () => _showTransactionSheet(
                        context,
                        title: l10n.flow_monthly_expenses,
                        transactions: expenseTransactions,
                        color: AppColors.error,
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Second row: Transfers + Total Transactions ──────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: l10n.transfers,
                      value: '0',
                      count: 0,
                      icon: Icons.swap_horiz_rounded,
                      color: AppColors.secondary,
                      onTap: () => _showTransferSheet(context),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: l10n.tab_transactions,
                      value: '${accountTransactions.length}',
                      count: accountTransactions.length,
                      icon: Icons.receipt_long_rounded,
                      color: AppColors.tertiary,
                      onTap: () => _showTransactionSheet(
                        context,
                        title: l10n.tab_transactions,
                        transactions: accountTransactions,
                        color: AppColors.tertiary,
                        icon: Icons.receipt_long_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransferSheet(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const JeweledIcon(
                    icon: Icons.swap_horiz_rounded,
                    iconColor: AppColors.secondary,
                    size: 36,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(l10n.transfers, style: AppTextStyles.titleLarge),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.outlineVariant, height: 1),
            Expanded(
              child: Center(
                child: Text(
                  l10n.accounts_no_transfers,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionSheet(
    BuildContext context, {
    required String title,
    required List<Transaction> transactions,
    required Color color,
    required IconData icon,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  JeweledIcon(icon: icon, iconColor: color, size: 36),
                  const SizedBox(width: AppSpacing.md),
                  Text(title, style: AppTextStyles.titleLarge),
                  const Spacer(),
                  Text(
                    '${transactions.length}',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.outlineVariant, height: 1),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.accounts_no_records,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: transactions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (_, i) {
                        final t = transactions[i];
                        return Row(
                          children: [
                            JeweledIcon(
                              icon: t.isIncome
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              iconColor: t.isIncome ? AppColors.success : AppColors.error,
                              size: 36,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.description,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    t.date.toIso8601String().substring(0, 10),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${t.isExpense ? '-' : '+'} ${_currencyFmt.format(t.amount.amount)}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: t.isIncome ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Balance Hero Card ─────────────────────────────────────────────────────────

class _BalanceHeroCard extends StatelessWidget {
  const _BalanceHeroCard({
    required this.account,
    required this.balanceAsync,
    required this.totalIncome,
    required this.totalExpenses,
    required this.l10n,
  });

  final Account account;
  final AsyncValue<Money> balanceAsync;
  final double totalIncome;
  final double totalExpenses;
  final AppLocalizations l10n;

  Color get _accentColor {
    if (account.color != null) {
      try {
        return Color(int.parse('FF${account.color!.replaceAll('#', '')}', radix: 16));
      } catch (_) {}
    }
    return AppColors.primaryFixed;
  }

  IconData get _accountIcon {
    switch (account.type) {
      case AccountType.savings:
        return Icons.savings_rounded;
      case AccountType.cash:
        return Icons.payments_rounded;
      case AccountType.investment:
        return Icons.trending_up_rounded;
      case AccountType.other:
        return Icons.account_balance_wallet_rounded;
      case AccountType.checking:
        return Icons.credit_card_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;
    final net = totalIncome - totalExpenses;
    final isPositiveNet = net >= 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceContainerHigh, accent.withValues(alpha: 0.08)],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Stack(
          children: [
            // Ambient glow blob
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: icon + type badge + currency ──────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Icon(_accountIcon, color: accent, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.name,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  accountTypeName(l10n, account.type).toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  account.currency,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                              if (account.isDefault) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    l10n.label_default,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Balance label ──────────────────────────────────────
                  Text(
                    l10n.account_balance.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // ── Balance amount ─────────────────────────────────────
                  balanceAsync.when(
                    loading: () => SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: accent, strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (e, _) => Text(
                      e.toString(),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                    ),
                    data: (balance) => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        balance.toString(),
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: accent.withValues(alpha: 0.15), height: 1),
                  const SizedBox(height: AppSpacing.md),

                  // ── Income / Expense / Net row ─────────────────────────
                  Row(
                    children: [
                      _MiniStat(
                        label: l10n.label_income,
                        value: _currencyFmt.format(totalIncome),
                        color: AppColors.success,
                        icon: Icons.arrow_downward_rounded,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _MiniStat(
                        label: l10n.label_expenses,
                        value: _currencyFmt.format(totalExpenses),
                        color: AppColors.error,
                        icon: Icons.arrow_upward_rounded,
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.label_net,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 9,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${isPositiveNet ? '+' : ''}${_currencyFmt.format(net.abs())}',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: isPositiveNet ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Stat summary card ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String value;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 16),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              count == 1
                  ? context.l10n.label_record_one(count)
                  : context.l10n.label_record_other(count),
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.outline, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar({required this.accountName, required this.onEdit, required this.onDelete});

  final String accountName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop() ? context.pop() : context.go('/more/accounts'),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.primaryFixed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primaryFixed, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        accountName,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
