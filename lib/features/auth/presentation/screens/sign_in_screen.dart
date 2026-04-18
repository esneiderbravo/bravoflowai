import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../application/auth_providers.dart';
import '../widgets/auth_form.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signIn(email: _emailController.text.trim(), password: _passwordController.text);
  }

  void _onForgotPassword() {
    context.showInfoSnack(context.l10n.coming_soon);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.hasError && next.error is AppException) {
        final msg = (next.error! as AppException).failure.userMessage;
        context.showErrorSnack(msg);
      }
    });

    return Form(
      key: _formKey,
      child: AuthForm(
        title: l10n.sign_in_title,
        subtitle: l10n.sign_in_subtitle,
        isLoading: isLoading,
        submitLabel: l10n.sign_in_button,
        onSubmit: _submit,
        footerLabel: l10n.sign_up_link,
        onFooterTap: () => context.go('/auth/sign-up'),
        fields: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email_label,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? l10n.email_invalid : null,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.password_label,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) => (v == null || v.length < 6) ? l10n.password_min_length : null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryFixed,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.forgot_password,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryFixed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
