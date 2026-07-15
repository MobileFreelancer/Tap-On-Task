import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String? phone;
  const ResetPasswordScreen({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormProvider>();
    final auth = context.watch<AuthService>();

    return AuthScaffold(
      headerTitle: 'Reset Password',
      showBack: true,
      showLogo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Create New Password', style: AppTextStyles.authCardTitle(context)),
          SizedBox(height: context.h(12)),
          Text(
            'Create a new password for your account',
            style: AppTextStyles.authSubtitle(context),
          ),
          SizedBox(height: context.h(28)),
          AuthPasswordField(
            hint: 'New Password',
            controller: form.passwordController,
            obscure: form.obscurePassword,
            onToggle: () => context.read<AuthFormProvider>().togglePasswordVisibility(),
          ),
          AuthPasswordField(
            hint: 'Confirm New Password',
            controller: form.confirmPasswordController,
            obscure: form.obscureConfirmPassword,
            onToggle: () => context.read<AuthFormProvider>().toggleConfirmPasswordVisibility(),
          ),
          SizedBox(height: context.h(20)),
          AuthPrimaryButton(
            label: 'Reset Password',
            isLoading: auth.isLoading,
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
