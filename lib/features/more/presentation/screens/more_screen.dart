import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tab_more, style: AppTextStyles.headingLarge)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: Text(l10n.more_accounts, style: AppTextStyles.bodyLarge),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go('/more/accounts'),
          ),
        ],
      ),
    );
  }
}
