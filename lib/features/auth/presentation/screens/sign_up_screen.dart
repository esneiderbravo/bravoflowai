import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/theme/app_colors.dart';
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
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (prev, next) {
      // Sign-up succeeded but Supabase requires email confirmation (no session).
      // Transition: AsyncLoading → AsyncData(null)
      if (prev?.isLoading == true && !next.isLoading && !next.hasError && next.value == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Account created! Check your email to confirm.'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 6),
            ),
          );
        context.go('/auth/sign-in');
        return;
      }
      if (next.hasError && next.error is AppException) {
        final msg = (next.error! as AppException).failure.userMessage;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error));
      }
    });

    return Form(
      key: _formKey,
      child: AuthForm(
        title: 'Create account',
        subtitle: 'Start your AI-powered financial journey.',
        isLoading: isLoading,
        submitLabel: 'Sign Up',
        onSubmit: _submit,
        fields: [
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
          ),
        ],
        footerLabel: 'Already have an account? Sign In',
        onFooterTap: () => context.go('/auth/sign-in'),
      ),
    );
  }
}
