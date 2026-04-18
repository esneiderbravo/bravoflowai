import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/transfer.dart';
import '../../../../domain/value_objects/money.dart';
import '../../application/account_balance_provider.dart';
import '../../application/account_providers.dart';
import '../../application/transfer_providers.dart';

class AddTransferScreen extends ConsumerStatefulWidget {
  const AddTransferScreen({super.key});

  @override
  ConsumerState<AddTransferScreen> createState() => _AddTransferScreenState();
}

class _AddTransferScreenState extends ConsumerState<AddTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _fromAccountId;
  String? _toAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0;

    final transfer = Transfer(
      id: '',
      userId: '',
      fromAccountId: _fromAccountId!,
      toAccountId: _toAccountId!,
      amount: Money(amount: amount),
      date: _selectedDate,
      createdAt: DateTime.now(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    await ref.read(transferNotifierProvider(_fromAccountId!).notifier).add(transfer);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final accounts = ref.watch(accountNotifierProvider).valueOrNull ?? [];

    // Check if amount exceeds fromAccount balance
    final fromBalance = _fromAccountId != null
        ? ref.watch(accountBalanceProvider(_fromAccountId!)).valueOrNull
        : null;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;
    final exceedsBalance = fromBalance != null && enteredAmount > fromBalance.amount;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.add_transfer, style: AppTextStyles.headingLarge)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── From account ────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _fromAccountId,
                decoration: InputDecoration(
                  labelText: l10n.transfer_from,
                  prefixIcon: const Icon(Icons.call_made_rounded),
                ),
                items: accounts
                    .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                    .toList(),
                onChanged: (v) => setState(() => _fromAccountId = v),
                validator: (v) => v == null ? l10n.account_name_required : null,
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── To account ──────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _toAccountId,
                decoration: InputDecoration(
                  labelText: l10n.transfer_to,
                  prefixIcon: const Icon(Icons.call_received_rounded),
                ),
                items: accounts
                    .where((a) => a.id != _fromAccountId)
                    .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                    .toList(),
                onChanged: (v) => setState(() => _toAccountId = v),
                validator: (v) {
                  if (v == null) return l10n.account_name_required;
                  if (v == _fromAccountId) return l10n.transfer_same_account;
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Amount ──────────────────────────────────────────────────
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.transfer_amount,
                  prefixText: '\$ ',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                  suffixIcon: exceedsBalance
                      ? const Tooltip(
                          message: 'Exceeds balance',
                          child: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.transfer_amount_required;
                  final val = double.tryParse(v);
                  if (val == null || val <= 0) return l10n.transfer_amount_invalid;
                  return null;
                },
              ),
              if (exceedsBalance) ...[
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  l10n.transfer_insufficient_balance,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
                ),
              ],
              const SizedBox(height: AppConstants.spacingMd),

              // ── Date picker ─────────────────────────────────────────────
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(
                  _selectedDate.toIso8601String().substring(0, 10),
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // ── Note ────────────────────────────────────────────────────
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.transfer_note,
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
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
                      : Text(l10n.save_transfer_button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
