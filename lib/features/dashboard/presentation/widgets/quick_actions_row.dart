import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Row of quick-action icon buttons with routes.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  static const _actions = [
    _Action(Icons.add_circle_outline_rounded, '/transactions', _ActionLabel.addTransaction),
    _Action(Icons.account_balance_wallet_outlined, '/budget', _ActionLabel.budget),
    _Action(Icons.bar_chart_rounded, '/transactions', _ActionLabel.reports),
    _Action(Icons.auto_awesome_rounded, '/ai', _ActionLabel.aiChat),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions.map((a) => _ActionButton(action: a)).toList(),
    );
  }
}

class _Action {
  const _Action(this.icon, this.path, this.label);
  final IconData icon;
  final String path;
  final _ActionLabel label;
}

enum _ActionLabel { addTransaction, budget, reports, aiChat }

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});
  final _Action action;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = switch (action.label) {
      _ActionLabel.addTransaction => l10n.add_transaction,
      _ActionLabel.budget => l10n.budget,
      _ActionLabel.reports => l10n.reports,
      _ActionLabel.aiChat => l10n.ai_chat,
    };

    return GestureDetector(
      onTap: () => context.go(action.path),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              boxShadow: AppColors.aiGlow(AppColors.primaryBlue),
            ),
            child: Icon(action.icon, color: AppColors.primaryBlue, size: 26),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(label, style: AppTextStyles.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
