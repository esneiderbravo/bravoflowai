import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/jeweled_icon.dart';

/// 2 × 2 quick-action grid for the dashboard.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const _actions = [
    _Action(
      icon: Icons.add_circle_outline_rounded,
      iconColor: AppColors.primaryFixed,
      path: '/transactions/add',
      title: 'Add Transaction',
      subtitle: 'Record recent spend',
    ),
    _Action(
      icon: Icons.pie_chart_outline_rounded,
      iconColor: AppColors.secondary,
      path: '/budget',
      title: 'Budget',
      subtitle: 'Adjust limits',
    ),
    _Action(
      icon: Icons.bar_chart_rounded,
      iconColor: AppColors.tertiary,
      path: '/transactions',
      title: 'Reports',
      subtitle: 'Monthly summary',
    ),
    _Action(
      icon: Icons.auto_awesome_rounded,
      iconColor: AppColors.primaryFixed,
      path: '/ai',
      title: 'AI Chat',
      subtitle: 'Ask anything',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: _actions.map((a) => _ActionTile(action: a)).toList(),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});
  final _Action action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(action.path),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JeweledIcon(icon: action.icon, iconColor: action.iconColor),
            const Spacer(),
            Text(
              action.title,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(action.subtitle, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _Action {
  const _Action({
    required this.icon,
    required this.iconColor,
    required this.path,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final Color iconColor;
  final String path;
  final String title;
  final String subtitle;
}
