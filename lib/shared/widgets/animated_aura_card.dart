import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';

/// A [GlassCard] variant surrounded by an animated rotating gradient "Aura"
/// border — used exclusively for AI-generated content.
///
/// The aura draws a 2 px gradient stroke (neon-cyan → electric-violet) that
/// rotates continuously (3 s period) while its opacity pulses from 0.4 → 0.7
/// on a 2 s sine cycle.
class AnimatedAuraCard extends StatefulWidget {
  const AnimatedAuraCard({
    super.key,
    required this.child,
    this.borderRadius = AppSpacing.radiusLg,
    this.padding,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  State<AnimatedAuraCard> createState() => _AnimatedAuraCardState();
}

class _AnimatedAuraCardState extends State<AnimatedAuraCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Opacity pulses between 0.4 and 0.7 on a sine wave over 2 s
        // (controller drives at 3 s, so pulse is 3/2 = 1.5 cycles during full rotation)
        final pulse = 0.4 + 0.3 * ((math.sin(_controller.value * 2 * math.pi * 1.5) + 1) / 2);

        return CustomPaint(
          painter: _AuraPainter(
            rotation: _controller.value,
            opacity: pulse,
            borderRadius: widget.borderRadius + 2,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: GlassCard(
              borderRadius: widget.borderRadius,
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class _AuraPainter extends CustomPainter {
  _AuraPainter({required this.rotation, required this.opacity, required this.borderRadius});

  final double rotation;
  final double opacity;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Sweep gradient rotates by mapping rotation (0→1) to angle (0→2π)
    final angle = rotation * 2 * math.pi;
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: angle,
      endAngle: angle + 2 * math.pi,
      colors: [
        AppColors.primaryFixed.withValues(alpha: opacity),
        AppColors.secondary.withValues(alpha: opacity),
        AppColors.primaryFixed.withValues(alpha: opacity),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(_AuraPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.opacity != opacity;
}
