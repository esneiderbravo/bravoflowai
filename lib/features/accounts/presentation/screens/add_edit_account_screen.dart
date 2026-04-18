import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/value_objects/money.dart';
import '../../application/account_providers.dart';

class AddEditAccountScreen extends ConsumerStatefulWidget {
  const AddEditAccountScreen({super.key, this.accountId});

  final String? accountId;

  @override
  ConsumerState<AddEditAccountScreen> createState() => _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends ConsumerState<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  AccountType _selectedType = AccountType.cash;
  bool _isLoading = false;
  Account? _editingAccount;

  bool get _isEditing => widget.accountId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAccount());
    }
  }

  void _loadAccount() {
    final accounts = ref.read(accountNotifierProvider).valueOrNull ?? [];
    final account = accounts.where((a) => a.id == widget.accountId).firstOrNull;
    if (account != null) {
      setState(() {
        _editingAccount = account;
        _nameController.text = account.name;
        _balanceController.text = account.initialBalance.amount.toStringAsFixed(2);
        _selectedType = account.type;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final balance = double.tryParse(_balanceController.text) ?? 0;

    // Warn user if editing an account with existing balance
    if (_isEditing && (_editingAccount?.initialBalance.amount ?? 0) > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Balance will be recalculated based on transactions.'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }

    setState(() => _isLoading = true);

    final account = Account(
      id: _editingAccount?.id ?? '',
      userId: _editingAccount?.userId ?? '',
      name: _nameController.text.trim(),
      type: _selectedType,
      initialBalance: Money(amount: balance),
      currency: _editingAccount?.currency ?? 'USD',
      isDefault: _editingAccount?.isDefault ?? false,
      createdAt: _editingAccount?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      await ref.read(accountNotifierProvider.notifier).edit(account);
    } else {
      await ref.read(accountNotifierProvider.notifier).add(account);
    }

    if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/more/accounts');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.edit_account : l10n.add_account,
          style: AppTextStyles.headingLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Account name ────────────────────────────────────────────
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.account_name_label,
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.account_name_required : null,
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Account type ────────────────────────────────────────────
              DropdownButtonFormField<AccountType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: l10n.account_type_label,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: AccountType.values.map((type) {
                  final label = switch (type) {
                    AccountType.checking => l10n.account_type_checking,
                    AccountType.savings => l10n.account_type_savings,
                    AccountType.cash => l10n.account_type_cash,
                    AccountType.investment => l10n.account_type_investment,
                    AccountType.other => l10n.account_type_other,
                  };
                  return DropdownMenuItem(value: type, child: Text(label));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedType = v);
                },
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Initial balance ─────────────────────────────────────────
              TextFormField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.initial_balance,
                  prefixText: '\$ ',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return null; // optional
                  final val = double.tryParse(v);
                  if (val == null) return l10n.transfer_amount_invalid;
                  if (val < 0) return l10n.transfer_amount_invalid;
                  return null;
                },
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
                      : Text(l10n.save_account_button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
