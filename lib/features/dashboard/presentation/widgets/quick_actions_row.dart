import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

/// Row of quick-action icon buttons with routes.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  static const _actions = [
    _Action(Icons.add_circle_outline_rounded, 'Add\nTransaction', '/transactions'),
    _Action(Icons.account_balance_wallet_outlined, 'Budget', '/budget'),
    _Action(Icons.bar_chart_rounded, 'Reports', '/transactions'),
    _Action(Icons.auto_awesome_rounded, 'AI Chat', '/ai'),
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
  const _Action(this.icon, this.label, this.path);
  final IconData icon;
  final String label;
  final String path;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});
  final _Action action;

  @override
  Widget build(BuildContext context) {
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
          Text(
            action.label,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

