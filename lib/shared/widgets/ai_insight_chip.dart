import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// A pill-shaped chip that surfaces an AI-generated insight with an icon.
class AiInsightChip extends StatelessWidget {
  const AiInsightChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.violetAI.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.violetAI, size: 20),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

