import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../application/transaction_providers.dart';
import '../widgets/transaction_tile.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionNotifierProvider);
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tab_transactions, style: AppTextStyles.headingLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {}, // TODO: date range filter
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () => context.go('/transactions/add'),
        child: Icon(Icons.add_rounded, color: colorScheme.onPrimary),
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: AppConstants.spacingMd),
              Text(e.toString(), style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppConstants.spacingMd),
              ElevatedButton(
                onPressed: () => ref.read(transactionNotifierProvider.notifier).refresh(),
                child: Text(l10n.retry_button),
              ),
            ],
          ),
        ),
        data: (transactions) => transactions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      color: AppColors.textDisabled,
                      size: 64,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(l10n.transactions_empty_title, style: AppTextStyles.headingSmall),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(l10n.transactions_empty_message, style: AppTextStyles.bodySmall),
                  ],
                ),
              )
            : RefreshIndicator(
                color: AppColors.primaryBlue,
                onRefresh: () => ref.read(transactionNotifierProvider.notifier).refresh(),
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: colorScheme.outlineVariant, indent: 72),
                  itemBuilder: (context, i) => TransactionTile(
                    transaction: transactions[i],
                    onDelete: () =>
                        ref.read(transactionNotifierProvider.notifier).remove(transactions[i].id),
                  ),
                ),
              ),
      ),
    );
  }
}
