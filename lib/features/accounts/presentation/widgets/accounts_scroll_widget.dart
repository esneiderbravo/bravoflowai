import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/account_providers.dart';
import 'account_card.dart';

class AccountsScrollWidget extends ConsumerWidget {
  const AccountsScrollWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountNotifierProvider);

    return accountsAsync.when(
      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (accounts) {
        if (accounts.isEmpty) {
          return SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: InkWell(
                      onTap: () => context.push('/more/accounts/add'),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primaryBlue,
                            size: 32,
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
                          Text(
                            context.l10n.add_account,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return SizedBox(
                width: 200,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < accounts.length - 1 ? AppConstants.spacingMd : 0,
                  ),
                  child: AccountCard(
                    account: account,
                    onTap: () => context.push('/more/accounts/${account.id}'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
