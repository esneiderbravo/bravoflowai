import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/services/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/account.dart';
import '../../../../domain/value_objects/money.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/formatters/currency_input_formatter.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/jeweled_icon.dart';
import '../../application/account_providers.dart';

// ── Preset palette ───────────────────────────────────────────────────────────
const _kPresetColors = [
  '#00F4FE', // primaryFixed (cyan)
  '#BF81FF', // secondary (violet)
  '#64B3FF', // tertiary (blue)
  '#22C55E', // success (green)
  '#F59E0B', // warning (amber)
  '#FF716C', // error (red/coral)
  '#E4C6FF', // secondaryFixed (lavender)
  '#A1FAFF', // primary (light cyan)
  '#6BB6FF', // tertiaryFixed
  '#A7AAC3', // onSurfaceVariant (slate)
];

// ── Preset icons ─────────────────────────────────────────────────────────────
// ── Preset icons with l10n key names ─────────────────────────────────────────

const _kPresetIconKeys = [
  (icon: Icons.account_balance_outlined, key: 'icon_bank'),
  (icon: Icons.savings_outlined, key: 'icon_savings'),
  (icon: Icons.payments_outlined, key: 'icon_cash'),
  (icon: Icons.trending_up_outlined, key: 'icon_investment'),
  (icon: Icons.wallet_outlined, key: 'icon_wallet'),
  (icon: Icons.credit_card_outlined, key: 'icon_card'),
  (icon: Icons.attach_money_rounded, key: 'icon_money'),
  (icon: Icons.currency_exchange_rounded, key: 'icon_exchange'),
  (icon: Icons.business_center_outlined, key: 'icon_business'),
  (icon: Icons.real_estate_agent_outlined, key: 'icon_property'),
  (icon: Icons.phone_iphone_outlined, key: 'icon_digital'),
  (icon: Icons.home_outlined, key: 'icon_home'),
];

// ── Supported currencies ─────────────────────────────────────────────────────
const _kCurrencies = ['USD', 'EUR', 'COP', 'GBP', 'BRL'];

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
  String? _selectedColor;
  IconData? _selectedIcon;
  String? _selectedIconKey;
  String _selectedCurrency = 'USD';
  bool _isDefault = false;
  bool _isLoading = false;
  Account? _editingAccount;

  bool get _isEditing => widget.accountId != null;

  String _iconName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'icon_bank':
        return l10n.icon_bank;
      case 'icon_savings':
        return l10n.icon_savings;
      case 'icon_cash':
        return l10n.icon_cash;
      case 'icon_investment':
        return l10n.icon_investment;
      case 'icon_wallet':
        return l10n.icon_wallet;
      case 'icon_card':
        return l10n.icon_card;
      case 'icon_money':
        return l10n.icon_money;
      case 'icon_exchange':
        return l10n.icon_exchange;
      case 'icon_business':
        return l10n.icon_business;
      case 'icon_property':
        return l10n.icon_property;
      case 'icon_digital':
        return l10n.icon_digital;
      case 'icon_home':
        return l10n.icon_home;
      default:
        return key;
    }
  }

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
    if (account == null) return;
    setState(() {
      _editingAccount = account;
      _nameController.text = account.name;
      _balanceController.text = CurrencyInputFormatter.formatAmount(account.initialBalance.amount);
      _selectedType = account.type;
      _selectedColor = account.color;
      _selectedCurrency = account.currency;
      _isDefault = account.isDefault;
      if (account.icon != null) {
        final code = int.tryParse(account.icon!);
        if (code != null) {
          _selectedIcon = IconData(code, fontFamily: 'MaterialIcons');
          // Restore key by matching codePoint
          _selectedIconKey = _kPresetIconKeys
              .where((e) => e.icon.codePoint == code)
              .map((e) => e.key)
              .firstOrNull;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = context.l10n;
    final balance = CurrencyInputFormatter.parse(_balanceController.text) ?? 0;

    if (_isEditing && (_editingAccount?.initialBalance.amount ?? 0) != balance) {
      if (mounted) {
        context.showWarningSnack(l10n.initial_balance);
      }
    }

    setState(() => _isLoading = true);

    final account = Account(
      id: _editingAccount?.id ?? '',
      userId: _editingAccount?.userId ?? ref.read(currentUserIdProvider),
      name: _nameController.text.trim(),
      type: _selectedType,
      initialBalance: Money(amount: balance),
      currency: _selectedCurrency,
      isDefault: _isDefault,
      color: _selectedColor,
      icon: _selectedIcon?.codePoint.toString(),
      createdAt: _editingAccount?.createdAt ?? DateTime.now(),
    );

    try {
      if (_isEditing) {
        await ref.read(accountNotifierProvider.notifier).edit(account);
      } else {
        await ref.read(accountNotifierProvider.notifier).add(account);
      }

      if (mounted) {
        context.showSuccessSnack(
          _isEditing ? l10n.account_updated_success : l10n.account_created_success,
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/more/accounts');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showErrorSnack(l10n.account_error_save);
      }
      return;
    }
  }

  Future<void> _showIconPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.account_icon_label, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.85,
                ),
                itemCount: _kPresetIconKeys.length,
                itemBuilder: (_, i) {
                  final entry = _kPresetIconKeys[i];
                  final isSelected = _selectedIcon?.codePoint == entry.icon.codePoint;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = entry.icon;
                        _selectedIconKey = entry.key;
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryFixed.withValues(alpha: 0.15)
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryFixed : AppColors.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          JeweledIcon(
                            icon: entry.icon,
                            iconColor: isSelected
                                ? AppColors.primaryFixed
                                : AppColors.onSurfaceVariant,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _iconName(context.l10n, entry.key),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppColors.primaryFixed
                                  : AppColors.onSurfaceVariant,
                              fontSize: 9,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _FormAppBar(title: _isEditing ? l10n.edit_account : l10n.add_account),
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
              // ── Basic Info Card ──────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.account_name_label,
                        prefixIcon: const Icon(Icons.label_outline_rounded),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.account_name_required : null,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField<AccountType>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.account_type_label,
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      dropdownColor: AppColors.surfaceContainerLow,
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
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [CurrencyInputFormatter()],
                      decoration: InputDecoration(
                        labelText: l10n.initial_balance,
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        final val = CurrencyInputFormatter.parse(v);
                        if (val == null) return l10n.transfer_amount_invalid;
                        if (val < 0) return l10n.transfer_amount_invalid;
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedCurrency,
                      decoration: InputDecoration(
                        labelText: l10n.account_currency_label,
                        prefixIcon: const Icon(Icons.currency_exchange_rounded),
                      ),
                      dropdownColor: AppColors.surfaceContainerLow,
                      items: _kCurrencies
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedCurrency = v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Color Picker Card ────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.account_color_label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _kPresetColors.map((hex) {
                          final isSelected = _selectedColor == hex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = hex),
                            child: Container(
                              margin: const EdgeInsets.only(right: AppSpacing.sm),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _hexToColor(hex),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 2.5,
                                ),
                                boxShadow: isSelected ? AppColors.aiGlow(_hexToColor(hex)) : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Icon Picker Card ─────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: GestureDetector(
                  onTap: _showIconPicker,
                  child: Row(
                    children: [
                      if (_selectedIcon != null)
                        JeweledIcon(icon: _selectedIcon!, iconColor: AppColors.primaryFixed)
                      else
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.onSurfaceVariant,
                        ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          _selectedIcon != null && _selectedIconKey != null
                              ? _iconName(l10n, _selectedIconKey!)
                              : l10n.account_icon_label,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _selectedIcon != null
                                ? AppColors.primaryFixed
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Default Toggle Card ──────────────────────────────────────
              GlassCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  value: _isDefault,
                  onChanged: (v) => setState(() => _isDefault = v),
                  title: Text(l10n.account_is_default_label, style: AppTextStyles.bodyMedium),
                  activeThumbColor: AppColors.primaryFixed,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Submit ───────────────────────────────────────────────────
              GradientButton(
                label: l10n.save_account_button,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FormAppBar({required this.title});

  final String title;

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
                    onTap: () => Navigator.of(context).maybePop(),
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
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
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
