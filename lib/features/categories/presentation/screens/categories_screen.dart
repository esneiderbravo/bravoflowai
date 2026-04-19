import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category.dart';
import '../../application/category_providers.dart';
import '../../domain/category_icons.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: const _CategoriesAppBar(),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryFixed, strokeWidth: 2),
        ),
        error: (e, _) => Center(child: Text(e.toString(), style: AppTextStyles.bodyMedium)),
        data: (categories) {
          final defaults = categories.where((c) => c.isDefault).toList();
          final custom = categories.where((c) => !c.isDefault).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: topPad + kToolbarHeight + AppSpacing.md,
              bottom: 100,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),

                // ── Default categories ────────────────────────────────
                _SectionLabel(l10n.categories_section_default),
                const SizedBox(height: AppSpacing.sm),
                ...defaults.map(
                  (c) => _CategoryTile(
                    category: c,
                    canDelete: false,
                    onEdit: () => context.push('/more/categories/${c.id}/edit'),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Custom categories ─────────────────────────────────
                _SectionLabel(l10n.categories_section_custom),
                const SizedBox(height: AppSpacing.sm),
                if (custom.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Text(
                      l10n.categories_empty_custom,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  )
                else
                  ...custom.map(
                    (c) => _CategoryTile(
                      category: c,
                      canDelete: true,
                      onEdit: () => context.push('/more/categories/${c.id}/edit'),
                      onDelete: () => _confirmDelete(context, ref, c),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Category category) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(l10n.categories_delete_title),
        content: Text(l10n.categories_delete_body(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.categories_delete_confirm,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final error = await ref.read(categoryNotifierProvider.notifier).remove(category.id);
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.error));
      }
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: AppTextStyles.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
      letterSpacing: 2.0,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.canDelete,
    this.onEdit,
    this.onDelete,
  });

  final Category category;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
    final color = _iconColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(iconData, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              category.name,
              style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.onSurfaceVariant),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (canDelete && onDelete != null) ...[
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoriesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CategoriesAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/more');
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.primaryFixed,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primaryFixed, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        context.l10n.categories_title,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/more/categories/add'),
                    child: const Icon(Icons.add_rounded, color: AppColors.primaryFixed, size: 26),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
