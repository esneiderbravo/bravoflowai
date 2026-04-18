import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A widget that wraps its [child] with a continuously rotating gradient
/// border — the "AI Aura" effect from the Luminous Stratum design system.
///
/// The border uses a [SweepGradient] cycling between [AppColors.primaryFixed]
/// and [AppColors.secondary] that rotates every 3 seconds. Opacity pulses
/// between 0.4 and 0.7 on a 2-second sine cycle.
class AnimatedAuraCard extends StatefulWidget {
  const AnimatedAuraCard({
    super.key,
    required this.child,
    this.borderRadius = AppSpacing.radiusXl,
    this.borderWidth = 2.0,
  });

  final Widget child;

  /// Corner radius applied to both the aura container and the inner clip.
  /// Defaults to [AppSpacing.radiusXl] (48). Pass [AppSpacing.radiusFull]
  /// for pill-shaped elements such as [GradientButton].
  final double borderRadius;

  /// Width of the visible gradient border in logical pixels. Defaults to 2.
  final double borderWidth;

  @override
  State<AnimatedAuraCard> createState() => _AnimatedAuraCardState();
}

class _AnimatedAuraCardState extends State<AnimatedAuraCard> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(
      begin: 0.4,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseAnim]),
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius + widget.borderWidth),
          gradient: SweepGradient(
            colors: [
              AppColors.primaryFixed.withValues(alpha: _pulseAnim.value),
              AppColors.secondary.withValues(alpha: _pulseAnim.value),
              AppColors.primaryFixed.withValues(alpha: _pulseAnim.value),
            ],
            transform: GradientRotation(_rotationController.value * 2 * math.pi),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: ClipRRect(borderRadius: BorderRadius.circular(widget.borderRadius), child: child),
        ),
      ),
      child: widget.child,
    );
  }
}
