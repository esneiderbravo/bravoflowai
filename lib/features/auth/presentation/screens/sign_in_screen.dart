import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
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
    await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    // Router auto-redirects on auth state change — no manual navigation needed.
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.hasError && next.error is AppException) {
        final msg = (next.error! as AppException).failure.userMessage;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(msg),
            backgroundColor: AppColors.error,
          ));
      }
    });

    return Form(
      key: _formKey,
      child: AuthForm(
        title: 'Welcome back',
        subtitle: 'Sign in to your BravoFlow AI account.',
        isLoading: isLoading,
        submitLabel: 'Sign In',
        onSubmit: _submit,
        fields: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) =>
                (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
          ),
        ],
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ",
                style: AppTextStyles.bodySmall),
            GestureDetector(
              onTap: () => context.go('/auth/sign-up'),
              child: Text('Sign Up',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primaryBlue)),
            ),
          ],
        ),
      ),
    );
  }
}
