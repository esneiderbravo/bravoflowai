import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/i18n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/ai_insight.dart';
import '../../../shared/widgets/loading_overlay.dart';
import 'application/ai_providers.dart';

/// BravoFlow AI — AI Insights Screen (ConsumerWidget)
class AiInsightsScreen extends ConsumerWidget {
  const AiInsightsScreen({super.key});

  IconData _iconForType(AiInsightType type) => switch (type) {
    AiInsightType.spending => Icons.show_chart_rounded,
    AiInsightType.saving => Icons.savings_outlined,
    AiInsightType.prediction => Icons.lightbulb_outline_rounded,
    AiInsightType.alert => Icons.warning_amber_rounded,
  };

  Color _colorForType(AiInsightType type) => switch (type) {
    AiInsightType.spending => AppColors.primaryBlue,
    AiInsightType.saving => AppColors.success,
    AiInsightType.prediction => AppColors.violetAI,
    AiInsightType.alert => AppColors.warning,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.ai_insights, style: AppTextStyles.headingLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(aiNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(color: AppColors.violetAI),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (insights) => ListView.separated(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          itemCount: insights.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacingMd),
          itemBuilder: (context, i) {
            final insight = insights[i];
            final color = _colorForType(insight.type);
            return Container(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: color.withValues(alpha: 0.25)),
                boxShadow: AppColors.aiGlow(color),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_iconForType(insight.type), color: color, size: 20),
                      const SizedBox(width: AppConstants.spacingXs),
                      Text(
                        insight.type.name.toUpperCase(),
                        style: AppTextStyles.aiLabel.copyWith(color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(insight.title, style: AppTextStyles.headingSmall),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    insight.body,
                    style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
