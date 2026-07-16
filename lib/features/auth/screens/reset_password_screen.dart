import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? phone;
  const ResetPasswordScreen({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final form = context.watch<AuthFormProvider>();

    return AuthScaffold(
      headerTitle: 'Reset Password',
      showBack: true,
      showLogo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 28.h),
          AuthPasswordField(
            hint: 'New Password',
            controller: form.passwordController,
            obscure: form.obscurePassword,
            onToggle: () => context.read<AuthFormProvider>().togglePasswordVisibility(),
          ),
          SizedBox(height: 20.h),
          AuthPasswordField(
            hint: 'Confirm New Password',
            controller: form.confirmPasswordController,
            obscure: form.obscureConfirmPassword,
            onToggle: () => context.read<AuthFormProvider>().toggleConfirmPasswordVisibility(),
          ),
          SizedBox(height: 20.h),
          AuthPrimaryButton(
            label: 'Back to Login',
            onPressed: () => _handleReset(context),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReset(BuildContext context) async {
    final form = context.read<AuthFormProvider>();
    final error = form.validateResetPassword();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully!')),
      );
      context.go('/login');
    }
  }
}
