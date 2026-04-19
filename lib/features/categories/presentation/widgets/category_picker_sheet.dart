import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category.dart';
import '../../application/category_providers.dart';
import '../../domain/category_icons.dart';

/// Modal bottom sheet for picking a [Category].
///
/// Returns the selected [Category] via [Navigator.pop].
class CategoryPickerSheet extends ConsumerWidget {
  const CategoryPickerSheet({super.key});

  static Future<Category?> show(BuildContext context) {
    return showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CategoryPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          child: Column(
            children: [
              // ── Handle ──────────────────────────────────────────────
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Title ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(children: [Text('Select Category', style: AppTextStyles.headingSmall)]),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.outlineVariant),

              // ── List ─────────────────────────────────────────────────
              Expanded(
                child: categoriesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
                  ),
                  error: (e, _) => Center(child: Text(e.toString())),
                  data: (categories) {
                    final defaults = categories.where((c) => c.isDefault).toList();
                    final custom = categories.where((c) => !c.isDefault).toList();

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      children: [
                        if (defaults.isNotEmpty) ...[
                          const _SectionHeader('DEFAULT'),
                          ...defaults.map(
                            (c) => _CategoryItem(
                              category: c,
                              onTap: () => Navigator.of(context).pop(c),
                            ),
                          ),
                        ],
                        if (custom.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const _SectionHeader('CUSTOM'),
                          ...custom.map(
                            (c) => _CategoryItem(
                              category: c,
                              onTap: () => Navigator.of(context).pop(c),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
    child: Text(
      label,
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.onSurfaceVariant,
        letterSpacing: 2.0,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  Color get _iconColor {
    final hex = category.color;
    if (hex != null && hex.startsWith('#') && hex.length == 7) {
      try {
        return Color(int.parse('0xFF${hex.substring(1)}'));
      } catch (_) {}
    }
    return AppColors.primaryFixed;
  }

  @override
  Widget build(BuildContext context) {
    final iconData = resolveCategoryIcon(category.icon);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(iconData, color: _iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              category.name,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
