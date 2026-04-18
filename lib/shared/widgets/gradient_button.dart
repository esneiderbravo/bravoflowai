import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Primary CTA button with the Luminous Stratum gradient fill.
///
/// Background: linear gradient [AppColors.primaryFixed] → [AppColors.secondary]
/// at 135°, fully rounded, with a subtle outer glow.
/// Tap feedback: scale to 0.95 over 100 ms.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 52,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Defaults to full-width; pass a fixed value for icon-only or compact forms.
  final double? width;
  final double height;
  final IconData? icon;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _scaleController.reverse(),
      onTapUp: isDisabled ? null : (_) => _scaleController.forward(),
      onTapCancel: () => _scaleController.forward(),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDisabled
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.primaryFixed, AppColors.secondary],
                      begin: Alignment(-0.7071, -0.7071),
                      end: Alignment(0.7071, 0.7071),
                    ),
              color: isDisabled ? AppColors.surfaceContainerHigh : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primaryFixed.withValues(alpha: 0.20),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: AppColors.onPrimary, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          widget.label,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isDisabled ? AppColors.onSurfaceVariant : AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
