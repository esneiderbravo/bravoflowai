import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/ai_insight.dart';
import '../../shared/widgets/animated_aura_card.dart';
import '../../shared/widgets/jeweled_icon.dart';
import '../../shared/widgets/loading_overlay.dart';
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
    AiInsightType.spending => AppColors.primaryFixed,
    AiInsightType.saving => AppColors.success,
    AiInsightType.prediction => AppColors.secondary,
    AiInsightType.alert => AppColors.warning,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(aiNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.primaryFixed, AppColors.secondary],
          ).createShader(b),
          child: Text(
            l10n.ai_insights,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryFixed),
            onPressed: () => ref.read(aiNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(color: AppColors.secondary),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (insights) => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          itemCount: insights.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, i) {
            final insight = insights[i];
            final color = _colorForType(insight.type);
            return AnimatedAuraCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JeweledIcon(icon: _iconForType(insight.type), iconColor: color),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight.type.name.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: color,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          insight.title,
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          insight.body,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
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
