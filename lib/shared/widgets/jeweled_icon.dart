import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A circular icon container — the "Jeweled Icon" pattern from the Luminous
/// Stratum design system.
///
/// Provides an [AppColors.surfaceContainerHighest] circle with 8 dp padding
/// around [icon], colored with [iconColor].
class JeweledIcon extends StatelessWidget {
  const JeweledIcon({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primaryFixed,
    this.containerColor = AppColors.surfaceContainerHighest,
    this.size = 24,
    this.padding = AppSpacing.sm,
  });

  final IconData icon;
  final Color iconColor;
  final Color containerColor;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: containerColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}
