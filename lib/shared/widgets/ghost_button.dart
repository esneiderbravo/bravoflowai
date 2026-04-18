import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Ghost / secondary CTA button with a translucent border and no fill.
///
/// Uses [AppColors.outline] at 20 % opacity as the border, fully rounded.
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.height = 52,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Text and border color — defaults to [AppColors.onSurface].
  final Color? color;
  final double? width;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.onSurface;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveColor,
          side: BorderSide(color: AppColors.outline.withValues(alpha: 0.20), width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: effectiveColor, size: 18),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: effectiveColor)),
          ],
        ),
      ),
    );
  }
}
