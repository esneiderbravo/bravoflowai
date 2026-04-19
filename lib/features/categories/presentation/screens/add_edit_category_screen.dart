import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../application/category_providers.dart';
import '../../domain/category_icons.dart';

class AddEditCategoryScreen extends ConsumerStatefulWidget {
  const AddEditCategoryScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends ConsumerState<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  String? _selectedIcon;
  bool _isLoading = false;
  Category? _editingCategory;

  bool get _isEditing => widget.categoryId != null;

  // Preset colour swatches
  static const _swatches = [
    '#3A86FF',
    '#7B61FF',
    '#00D4FF',
    '#EF4444',
    '#10B981',
    '#F59E0B',
    '#EC4899',
    '#8B5CF6',
    '#06B6D4',
    '#84CC16',
    '#F97316',
    '#6366F1',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadCategory());
    }
  }

  void _loadCategory() {
    final categories = ref.read(categoryNotifierProvider).valueOrNull ?? [];
    final category = categories.where((c) => c.id == widget.categoryId).firstOrNull;
    if (category != null) {
      setState(() {
        _editingCategory = category;
        _nameController.text = category.name;
        _selectedIcon = category.icon;
        _colorController.text = category.color ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final color = _colorController.text.trim().isEmpty ? null : _colorController.text.trim();

    final category = Category(
      id: _editingCategory?.id ?? '',
      userId: _editingCategory?.userId ?? '',
      name: _nameController.text.trim(),
      isDefault: false,
      icon: _selectedIcon,
      color: color,
    );

    final String? error;
    if (_isEditing) {
      error = await ref.read(categoryNotifierProvider.notifier).edit(category);
    } else {
      error = await ref.read(categoryNotifierProvider.notifier).add(category);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppColors.error));
      return;
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/more/categories');
    }
  }

  Future<void> _pickIcon() async {
    final lang = Localizations.localeOf(context).languageCode;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IconPickerSheet(selected: _selectedIcon, languageCode: lang),
    );
    if (picked != null) setState(() => _selectedIcon = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    final selectedColor = _parseColor(_colorController.text);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _FormAppBar(title: _isEditing ? l10n.edit_category_title : l10n.add_category_title),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + AppSpacing.xxl + AppSpacing.lg,
            bottom: 100,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Preview ────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: (selectedColor ?? AppColors.primaryFixed).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    resolveCategoryIcon(_selectedIcon),
                    color: selectedColor ?? AppColors.primaryFixed,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Name ──────────────────────────────────────────────────
              Text(
                l10n.category_name_label.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.category_name_hint,
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.category_name_required : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Icon picker ────────────────────────────────────────────
              Text(
                l10n.category_icon_section.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _pickIcon,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        resolveCategoryIcon(_selectedIcon),
                        color: selectedColor ?? AppColors.primaryFixed,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          _selectedIcon != null
                              ? resolveCategoryIconLabel(_selectedIcon!, lang)
                              : l10n.category_icon_hint,
                          style: _selectedIcon != null
                              ? AppTextStyles.bodyMedium
                              : AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ),
                      const Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Colour swatches ─────────────────────────────────────────
              Text(
                l10n.category_colour_section.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _swatches.map((hex) {
                  final isSelected = _colorController.text.trim() == hex;
                  final color = Color(int.parse('0xFF${hex.substring(1)}'));
                  return GestureDetector(
                    onTap: () => setState(() => _colorController.text = hex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Custom hex input
              Text(
                l10n.category_colour_custom_label.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  hintText: l10n.category_colour_hint,
                  prefixIcon: const Icon(Icons.color_lens_outlined),
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(v.trim())) {
                    return l10n.category_colour_invalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Submit ─────────────────────────────────────────────────
              GradientButton(
                label: _isEditing ? l10n.save_changes_button : l10n.add_category_button,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color? _parseColor(String hex) {
    final t = hex.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('#') && t.length == 7) {
      try {
        return Color(int.parse('0xFF${t.substring(1)}'));
      } catch (_) {}
    }
    return null;
  }
}

// ── Icon picker bottom sheet ──────────────────────────────────────────────────

class _IconPickerSheet extends StatefulWidget {
  const _IconPickerSheet({this.selected, required this.languageCode});
  final String? selected;
  final String languageCode;

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  String _query = '';

  List<MapEntry<String, IconData>> get _filtered {
    if (_query.isEmpty) return kCategoryIcons.entries.toList();
    final q = _query.toLowerCase();
    return kCategoryIcons.entries.where((e) {
      final label = resolveCategoryIconLabel(e.key, widget.languageCode).toLowerCase();
      return label.contains(q) || e.key.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          child: Column(
            children: [
              // ── Handle ───────────────────────────────────────────────
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  context.l10n.category_choose_icon_title,
                  style: AppTextStyles.headingSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Search ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: context.l10n.category_icon_search_hint,
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    filled: true,
                    fillColor: AppColors.surface.withValues(alpha: 0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.outlineVariant),

              // ── Grid ─────────────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final entry = _filtered[i];
                    final isSelected = entry.key == widget.selected;
                    final label = resolveCategoryIconLabel(entry.key, widget.languageCode);
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryFixed.withValues(alpha: 0.2)
                              : AppColors.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryFixed
                                : AppColors.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              entry.value,
                              size: 24,
                              color: isSelected
                                  ? AppColors.primaryFixed
                                  : AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: isSelected
                                      ? AppColors.primaryFixed
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

// ── Glass app bar ─────────────────────────────────────────────────────────────

class _FormAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FormAppBar({required this.title});

  final String title;

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
                    onTap: () => context.canPop() ? context.pop() : context.go('/more/categories'),
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
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
