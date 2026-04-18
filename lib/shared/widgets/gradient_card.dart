import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_spacing.dart';
import 'glass_card.dart';

/// A card with the BravoFlow AI gradient overlay on a glass base.
///
/// Wraps [GlassCard] with an optional gradient overlay for hero moments.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.borderRadius = AppSpacing.radiusLg,
    this.applyGradient = true,
  });

  final Widget child;
  final double borderRadius;

  /// When true, overlays the [AppGradients.aiSolid] gradient at 15 % opacity.
  final bool applyGradient;

  @override
  Widget build(BuildContext context) {
    if (!applyGradient) {
      return GlassCard(borderRadius: borderRadius, child: child);
    }

    return GlassCard(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppGradients.aiSolid.colors.first.withValues(alpha: 0.15),
                    AppGradients.aiSolid.colors.last.withValues(alpha: 0.15),
                  ],
                  begin: AppGradients.aiSolid.begin,
                  end: AppGradients.aiSolid.end,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
