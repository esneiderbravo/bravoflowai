import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A frosted-glass container implementing the Luminous Stratum glassmorphism
/// pattern.
///
/// Uses [BackdropFilter] with a 12σ blur, a [surfaceVariant] tinted background
/// at 40 % opacity, and a ghost border at 15 % opacity — replacing all usage
/// of the standard [Card] widget.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppSpacing.radiusLg,
    this.padding,
    this.backgroundColor,
    this.margin,
  });

  final Widget child;

  /// Corner radius — defaults to [AppSpacing.radiusLg] (32).
  final double borderRadius;

  /// Optional inner padding applied to [child].
  final EdgeInsetsGeometry? padding;

  /// Overrides the default `surfaceVariant @ 40 %` glass tint.
  final Color? backgroundColor;

  /// Optional outer margin.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.surfaceVariant.withValues(alpha: 0.4);
    final radius = BorderRadius.circular(borderRadius);

    Widget content = Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: radius,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15), width: 1.0),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), child: content),
      ),
    );
  }
}
