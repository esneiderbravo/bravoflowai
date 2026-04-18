import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'animated_aura_card.dart';

/// AI insight card with an animated gradient aura border.
///
/// Displays an AI-generated insight inside an [AnimatedAuraCard] with a
/// gradient avatar, insight text, and three pill action buttons.
class AiInsightChip extends StatelessWidget {
  const AiInsightChip({
    super.key,
    required this.label,
    this.icon = Icons.auto_awesome_rounded,
    this.onApply,
    this.onLearnMore,
    this.onDismiss,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onApply;
  final VoidCallback? onLearnMore;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return AnimatedAuraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Gradient AI avatar ──────────────────────────────────────
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryFixed, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: AppColors.onPrimary, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface, height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // ── Action pills ──────────────────────────────────────────────
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _PillButton(
                label: 'Apply Now',
                icon: Icons.bolt_rounded,
                color: AppColors.primaryFixed,
                onTap: onApply,
              ),
              _PillButton(label: 'Tell me more', onTap: onLearnMore),
              _PillButton(label: 'Dismiss', onTap: onDismiss),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, this.icon, this.color, this.onTap});

  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: textColor, size: 14), const SizedBox(width: 4)],
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
