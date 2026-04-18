import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/value_objects/money.dart';
import '../../../accounts/application/account_providers.dart';
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
  bool _isLoading = false;

  // Placeholder category until categories feature is built
  final _placeholderCategory = const Category(id: '', userId: '', name: 'General', isDefault: true);

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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0;
    final transaction = Transaction(
      id: '',
      userId: '',
      accountId: _selectedAccountId ?? '',
      amount: Money(amount: amount),
      category: _placeholderCategory,
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
    final colorScheme = Theme.of(context).colorScheme;
    final accountsAsync = ref.watch(accountNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.add_transaction_title, style: AppTextStyles.headingLarge)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Type toggle ─────────────────────────────────────────────
              SegmentedButton<TransactionType>(
                segments: <ButtonSegment<TransactionType>>[
                  ButtonSegment<TransactionType>(
                    value: TransactionType.expense,
                    label: Text(l10n.transaction_type_expense),
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.income,
                    label: Text(l10n.transaction_type_income),
                    icon: const Icon(Icons.arrow_downward_rounded),
                  ),
                ],
                showSelectedIcon: false,
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll<TextStyle>(AppTextStyles.labelMedium),
                ),
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // ── Account picker ──────────────────────────────────────────
              accountsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (accounts) => DropdownButtonFormField<String>(
                  initialValue: _selectedAccountId,
                  decoration: InputDecoration(
                    labelText: l10n.account_name_label,
                    prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  ),
                  items: accounts
                      .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAccountId = v),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Amount ──────────────────────────────────────────────────
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.transaction_amount_label,
                  prefixText: '\$ ',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.transaction_amount_required;
                  if (double.tryParse(v) == null) return l10n.transaction_amount_invalid;
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Description ─────────────────────────────────────────────
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: l10n.transaction_description_label,
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.transaction_description_required : null,
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Submit ──────────────────────────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(l10n.save_transaction_button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
