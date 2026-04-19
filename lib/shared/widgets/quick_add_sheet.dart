import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/value_objects/money.dart';
import '../../features/accounts/application/account_providers.dart';
import '../../features/financial_overview/application/financial_overview_providers.dart';
import '../../features/transactions/application/transaction_providers.dart';
import 'gradient_button.dart';

/// Modal bottom sheet for quickly recording an income or expense transaction.
///
/// Opened from the center "+" FAB in [AppShell]. Stays on the current screen.
/// On successful save, invalidates financial providers so the dashboard
/// and flow screen update reactively.
class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key});

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  TransactionType _type = TransactionType.expense;
  final _amountCtrl = TextEditingController();
  String? _selectedAccountId;
  bool _amountError = false;
  bool _accountError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final rawAmount = _amountCtrl.text.trim();
    final amount = double.tryParse(rawAmount);
    final amountOk = amount != null && amount > 0;
    final accountOk = _selectedAccountId != null;

    if (!amountOk || !accountOk) {
      setState(() {
        _amountError = !amountOk;
        _accountError = !accountOk;
      });
      return;
    }

    setState(() => _isLoading = true);

    final transaction = Transaction(
      id: '',
      userId: '',
      accountId: _selectedAccountId!,
      amount: Money(amount: amount),
      category: const Category(id: '', userId: '', name: 'General', isDefault: true),
      description: '',
      date: DateTime.now(),
      type: _type,
      createdAt: DateTime.now(),
    );

    await ref.read(transactionNotifierProvider.notifier).add(transaction);
    ref.invalidate(financialSummaryProvider);
    ref.invalidate(categorySummaryProvider);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accountsAsync = ref.watch(accountNotifierProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: bottomInset + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Drag handle ────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
          ),

          // ── Title ──────────────────────────────────────────────────────────
          Center(child: Text(l10n.quick_add_title, style: AppTextStyles.headingMedium)),
          const SizedBox(height: AppSpacing.lg),

          // ── Type toggle ────────────────────────────────────────────────────
          _TypeToggle(selected: _type, onSelect: (t) => setState(() => _type = t), l10n: l10n),
          const SizedBox(height: AppSpacing.lg),

          // ── Amount field ───────────────────────────────────────────────────
          _SheetTextField(
            controller: _amountCtrl,
            label: l10n.transaction_amount_label,
            icon: Icons.attach_money_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hasError: _amountError,
            onChanged: (_) {
              if (_amountError) setState(() => _amountError = false);
            },
          ),
          if (_amountError) ...[
            const SizedBox(height: AppSpacing.xs),
            _ErrorText(l10n.transaction_amount_required),
          ],
          const SizedBox(height: AppSpacing.md),

          // ── Account dropdown ───────────────────────────────────────────────
          accountsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
            data: (accounts) => _SheetDropdown<String>(
              value: _selectedAccountId,
              hint: l10n.quick_add_select_account,
              icon: Icons.account_balance_wallet_outlined,
              hasError: _accountError,
              items: accounts
                  .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedAccountId = v;
                if (_accountError) _accountError = false;
              }),
            ),
          ),
          if (_accountError) ...[
            const SizedBox(height: AppSpacing.xs),
            _ErrorText(l10n.quick_add_account_required),
          ],
          const SizedBox(height: AppSpacing.xl),

          // ── Save button ────────────────────────────────────────────────────
          GradientButton(
            label: l10n.save_transaction_button,
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
    );
  }
}

// ── Type toggle ───────────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.selected, required this.onSelect, required this.l10n});

  final TransactionType selected;
  final ValueChanged<TransactionType> onSelect;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        children: [
          _Pill(
            label: l10n.transaction_type_expense,
            active: selected == TransactionType.expense,
            activeColor: AppColors.error,
            onTap: () => onSelect(TransactionType.expense),
          ),
          _Pill(
            label: l10n.transaction_type_income,
            active: selected == TransactionType.income,
            activeColor: AppColors.primaryFixed,
            onTap: () => onSelect(TransactionType.income),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: active ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: active
                ? Border.all(color: activeColor.withValues(alpha: 0.40), width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? activeColor : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sheet text field ──────────────────────────────────────────────────────────

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.hasError = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: hasError
              ? AppColors.error.withValues(alpha: 0.6)
              : AppColors.outline.withValues(alpha: 0.15),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

// ── Sheet dropdown ────────────────────────────────────────────────────────────

class _SheetDropdown<T> extends StatelessWidget {
  const _SheetDropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.hasError = false,
  });

  final T? value;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: hasError
              ? AppColors.error.withValues(alpha: 0.6)
              : AppColors.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                hint,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          isExpanded: true,
          dropdownColor: AppColors.surfaceContainerHigh,
          style: AppTextStyles.bodyMedium,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Error text ────────────────────────────────────────────────────────────────

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
    );
  }
}
