import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../../transactions/application/transaction_providers.dart';
import '../../application/account_balance_provider.dart';
import '../../application/account_providers.dart';
import '../../application/transfer_providers.dart';

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({super.key, required this.accountId});

  final String accountId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final transactions = ref.read(transactionNotifierProvider).valueOrNull ?? [];
    final hasTxns = transactions.any((t) => t.accountId == accountId);
    final transfers = ref.read(transferNotifierProvider(accountId)).valueOrNull ?? [];

    if (hasTxns || transfers.isNotEmpty) {
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
    final transfersAsync = ref.watch(transferNotifierProvider(accountId));

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
            top: kToolbarHeight + AppSpacing.xl,
            bottom: 120,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              // ── Balance Hero Card ─────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.account_balance.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    balanceAsync.when(
                      loading: () => const CircularProgressIndicator(
                        color: AppColors.primaryFixed,
                        strokeWidth: 2,
                      ),
                      error: (e, _) => Text(e.toString()),
                      data: (balance) =>
                          Text(balance.toString(), style: AppTextStyles.displayMedium),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      account.type.name.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryFixed),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Transactions ─────────────────────────────────────────
              Text(l10n.tab_transactions, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.md),
              if (accountTransactions.isEmpty)
                Text(
                  l10n.transactions_empty_title,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                )
              else
                ...accountTransactions.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        JeweledIcon(
                          icon: t.isIncome
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          iconColor: t.isIncome ? AppColors.success : AppColors.error,
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
                              ),
                              Text(
                                t.date.toIso8601String().substring(0, 10),
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${t.isExpense ? '-' : '+'}${t.amount}',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: t.isIncome ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),

              // ── Transfers ────────────────────────────────────────────
              Text(l10n.add_transfer, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.md),
              transfersAsync.when(
                loading: () => const CircularProgressIndicator(color: AppColors.primaryFixed),
                error: (e, _) => Text(e.toString()),
                data: (transfers) {
                  if (transfers.isEmpty) {
                    return Text(
                      l10n.transactions_empty_title,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                    );
                  }
                  return Column(
                    children: transfers.map((t) {
                      final isIncoming = t.toAccountId == accountId;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            JeweledIcon(
                              icon: isIncoming
                                  ? Icons.call_received_rounded
                                  : Icons.call_made_rounded,
                              iconColor: isIncoming ? AppColors.success : AppColors.warning,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.note ?? l10n.add_transfer,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    t.date.toIso8601String().substring(0, 10),
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isIncoming ? '+' : '-'}${t.amount}',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: isIncoming ? AppColors.success : AppColors.warning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Transfer CTA ─────────────────────────────────────────
              GradientButton(
                label: l10n.add_transfer,
                icon: Icons.swap_horiz_rounded,
                onPressed: () => context.push('/more/accounts/transfer/add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar({required this.accountName, required this.onEdit, required this.onDelete});

  final String accountName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                    onTap: () => Navigator.of(context).maybePop(),
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
