import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/value_objects/money.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../accounts/application/account_providers.dart';
import '../../../categories/presentation/widgets/category_picker_sheet.dart';
import '../../application/transaction_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.preselectedAccountId});

  final String? preselectedAccountId;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String? _selectedAccountId;
  Category? _selectedCategory;
  bool _categoryError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.preselectedAccountId;
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final categoryValid = _selectedCategory != null;
    if (!categoryValid) setState(() => _categoryError = true);
    if (!formValid || !categoryValid) return;
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0;
    final transaction = Transaction(
      id: '',
      userId: '',
      accountId: _selectedAccountId ?? '',
      amount: Money(amount: amount),
      category: _selectedCategory!,
      description: _descController.text.trim(),
      date: DateTime.now(),
      type: _type,
      createdAt: DateTime.now(),
    );

    await ref.read(transactionNotifierProvider.notifier).add(transaction);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accountsAsync = ref.watch(accountNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _GlassAppBar(l10n: l10n),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + AppSpacing.xl,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Type pill toggle ────────────────────────────────────
                _TypeToggle(
                  selected: _type,
                  onSelect: (t) => setState(() => _type = t),
                  l10n: l10n,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Form fields card ────────────────────────────────────
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Account picker
                      accountsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, st) => const SizedBox.shrink(),
                        data: (accounts) => _StyledDropdown<String>(
                          value: _selectedAccountId,
                          label: l10n.account_name_label,
                          icon: Icons.account_balance_wallet_outlined,
                          items: accounts
                              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedAccountId = v),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Category picker
                      _CategoryPickerField(
                        selected: _selectedCategory,
                        label: l10n.transaction_category_label,
                        errorText: _categoryError ? l10n.transaction_category_required : null,
                        onTap: () async {
                          final picked = await CategoryPickerSheet.show(context);
                          if (picked != null) {
                            setState(() {
                              _selectedCategory = picked;
                              _categoryError = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Amount field
                      _StyledTextField(
                        controller: _amountController,
                        label: l10n.transaction_amount_label,
                        icon: Icons.attach_money_rounded,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        prefixText: '\$ ',
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.transaction_amount_required;
                          if (double.tryParse(v) == null) return l10n.transaction_amount_invalid;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Description field
                      _StyledTextField(
                        controller: _descController,
                        label: l10n.transaction_description_label,
                        icon: Icons.notes_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.transaction_description_required
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Save button ─────────────────────────────────────────
                GradientButton(
                  label: l10n.save_transaction_button,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Glass app bar ─────────────────────────────────────────────────────────────

class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GlassAppBar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.onSurface,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(l10n.add_transaction_title, style: AppTextStyles.titleLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Type pill toggle ──────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.selected, required this.onSelect, required this.l10n});

  final TransactionType selected;
  final ValueChanged<TransactionType> onSelect;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final options = [
      (TransactionType.expense, l10n.transaction_type_expense, Icons.arrow_upward_rounded),
      (TransactionType.income, l10n.transaction_type_income, Icons.arrow_downward_rounded),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: options.map((opt) {
          final (type, label, icon) = opt;
          final isActive = selected == type;
          final accentColor = type == TransactionType.income ? AppColors.success : AppColors.error;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isActive ? accentColor.withValues(alpha: 0.15) : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: isActive ? accentColor : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isActive ? accentColor : AppColors.onSurfaceVariant,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Styled form field helpers ─────────────────────────────────────────────────

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.prefixText,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
        prefixText: prefixText,
        prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primaryFixed),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      validator: validator,
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final String label;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      style: AppTextStyles.bodyMedium,
      dropdownColor: AppColors.surfaceContainerHigh,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
        prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        filled: true,
        fillColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primaryFixed),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

// ── Category picker field ─────────────────────────────────────────────────────

class _CategoryPickerField extends StatelessWidget {
  const _CategoryPickerField({
    required this.selected,
    required this.label,
    required this.onTap,
    this.errorText,
  });

  final Category? selected;
  final String label;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final borderColor = hasError
        ? AppColors.error
        : AppColors.outlineVariant.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.category_outlined, color: AppColors.onSurfaceVariant, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: selected == null
                  ? Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                    )
                  : Text(selected!.name, style: AppTextStyles.bodyMedium),
            ),
            const Icon(Icons.expand_more_rounded, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
