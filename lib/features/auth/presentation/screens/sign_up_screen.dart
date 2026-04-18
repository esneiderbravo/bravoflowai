import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../application/auth_providers.dart';
import '../widgets/auth_form.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (prev, next) {
      // Sign-up succeeded but Supabase requires email confirmation (no session).
      // Transition: AsyncLoading → AsyncData(null)
      if (prev?.isLoading == true && !next.isLoading && !next.hasError && next.value == null) {
        context.showSuccessSnack(context.l10n.account_created_confirm);
        context.go('/auth/sign-in');
        return;
      }
      if (next.hasError && next.error is AppException) {
        final msg = (next.error! as AppException).failure.userMessage;
        context.showErrorSnack(msg);
      }
    });

    return Form(
      key: _formKey,
      child: AuthForm(
        title: l10n.sign_up_title,
        subtitle: l10n.sign_up_subtitle,
        isLoading: isLoading,
        submitLabel: l10n.sign_up_button,
        onSubmit: _submit,
        fields: [
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.full_name_label,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enter_your_name : null,
          ),
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
        ],
        footerLabel: l10n.sign_in_link,
        onFooterTap: () => context.go('/auth/sign-in'),
      ),
    );
  }
}
