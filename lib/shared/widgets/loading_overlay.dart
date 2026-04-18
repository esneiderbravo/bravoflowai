import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Full-screen centered loading indicator using the Luminous Stratum accent colour.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.color = AppColors.primaryFixed});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: color, strokeWidth: 2.5));
  }
}
