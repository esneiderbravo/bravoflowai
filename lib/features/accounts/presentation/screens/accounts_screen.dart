import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/account_providers.dart';
import '../widgets/account_card.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final accountsAsync = ref.watch(accountNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accounts_title, style: AppTextStyles.headingLarge)),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 64),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(l10n.accounts_title, style: AppTextStyles.headingMedium),
                  const SizedBox(height: AppConstants.spacingSm),
                  ElevatedButton(
                    onPressed: () => context.push('/more/accounts/add'),
                    child: Text(l10n.add_account),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                child: AccountCard(
                  account: account,
                  onTap: () => context.push('/more/accounts/${account.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/more/accounts/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
