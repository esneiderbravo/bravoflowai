import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
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
    final hasTransfers = transfers.isNotEmpty;

    if (hasTxns || hasTransfers) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.delete_account_has_transactions)));
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
            child: Text(l10n.delete_account, style: const TextStyle(color: Colors.red)),
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
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name, style: AppTextStyles.headingLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/more/accounts/$accountId/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Balance card ─────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.account_balance, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppConstants.spacingSm),
                    balanceAsync.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text(e.toString()),
                      data: (balance) =>
                          Text(balance.toString(), style: AppTextStyles.displayMedium),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // ── Transactions ─────────────────────────────────────────────
            Text(l10n.tab_transactions, style: AppTextStyles.headingMedium),
            const SizedBox(height: AppConstants.spacingMd),
            if (accountTransactions.isEmpty)
              Text(l10n.transactions_empty_title, style: AppTextStyles.bodyMedium)
            else
              ...accountTransactions.map(
                (t) => ListTile(
                  leading: Icon(
                    t.isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                    color: t.isIncome ? Colors.green : Colors.red,
                  ),
                  title: Text(t.description),
                  subtitle: Text(t.date.toIso8601String().substring(0, 10)),
                  trailing: Text(
                    '${t.isExpense ? '-' : '+'}${t.amount}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: t.isIncome ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppConstants.spacingLg),

            // ── Transfers ────────────────────────────────────────────────
            Text(l10n.add_transfer, style: AppTextStyles.headingMedium),
            const SizedBox(height: AppConstants.spacingMd),
            transfersAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
              data: (transfers) {
                if (transfers.isEmpty) {
                  return Text(l10n.transactions_empty_title, style: AppTextStyles.bodyMedium);
                }
                return Column(
                  children: transfers.map((t) {
                    final isIncoming = t.toAccountId == accountId;
                    return ListTile(
                      leading: Icon(
                        isIncoming ? Icons.call_received_rounded : Icons.call_made_rounded,
                        color: isIncoming ? Colors.green : Colors.orange,
                      ),
                      title: Text(t.note ?? l10n.add_transfer),
                      subtitle: Text(t.date.toIso8601String().substring(0, 10)),
                      trailing: Text(
                        '${isIncoming ? '+' : '-'}${t.amount}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isIncoming ? Colors.green : Colors.orange,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'add_transfer',
            onPressed: () => context.push('/more/accounts/transfer/add'),
            child: const Icon(Icons.swap_horiz_rounded),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          FloatingActionButton(
            heroTag: 'add_transaction',
            onPressed: () => context.push('/transactions/add'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
