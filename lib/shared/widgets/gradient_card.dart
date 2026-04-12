import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

/// A card with the BravoFlow AI primary gradient background.
class GradientCard extends StatelessWidget {
  const GradientCard({super.key, required this.child, this.borderRadius = 16.0});

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.aiGlow(AppColors.primaryBlue),
      ),
      child: child,
    );
  }
}
