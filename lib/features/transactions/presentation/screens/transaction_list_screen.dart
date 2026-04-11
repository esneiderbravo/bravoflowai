import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../application/transaction_providers.dart';
import '../widgets/transaction_tile.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Transactions', style: AppTextStyles.headingLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {}, // TODO: date range filter
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => context.go('/transactions/add'),
        child: const Icon(Icons.add_rounded, color: AppColors.textPrimary),
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48),
              const SizedBox(height: AppConstants.spacingMd),
              Text(e.toString(), style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppConstants.spacingMd),
              ElevatedButton(
                onPressed: () =>
                    ref.read(transactionNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (transactions) => transactions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        color: AppColors.textDisabled, size: 64),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text('No transactions yet',
                        style: AppTextStyles.headingSmall),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text('Tap + to add your first one.',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              )
            : RefreshIndicator(
                color: AppColors.primaryBlue,
                onRefresh: () =>
                    ref.read(transactionNotifierProvider.notifier).refresh(),
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: AppColors.cardDark,
                    indent: 72,
                  ),
                  itemBuilder: (context, i) => TransactionTile(
                    transaction: transactions[i],
                    onDelete: () => ref
                        .read(transactionNotifierProvider.notifier)
                        .remove(transactions[i].id),
                  ),
                ),
              ),
      ),
    );
  }
}

