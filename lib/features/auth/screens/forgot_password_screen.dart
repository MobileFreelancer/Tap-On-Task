import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormProvider>();
    final auth = context.watch<AuthService>();

    return AuthScaffold(
      headerTitle: 'Forgot Password?',
      showBack: true,
      showLogo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Recover Password', style: AppTextStyles.authCardTitle(context)),
          SizedBox(height: context.h(12)),
          Text(
            "Enter the email address associated with your account, and we'll send you a secure link to reset your password.",
            style: AppTextStyles.authSubtitle(context),
          ),
          SizedBox(height: context.h(28)),
          AuthInputField(
            hint: 'Email address',
            icon: Icons.email_outlined,
            controller: form.forgotEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: context.h(12)),
          AuthPrimaryButton(
            label: 'Submit',
            isLoading: auth.isLoading,
            onPressed: () => _handleSubmit(context),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final form = context.read<AuthFormProvider>();
    final auth = context.read<AuthService>();
    final email = form.forgotEmailController.text.trim();

    final error = form.validateForgotPassword();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (auth.firebaseReady && email.contains('@')) {
      final success = await auth.sendPasswordResetEmail(email);
      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset link sent to your email.')),
        );
        context.pop();
      }
      return;
    }

    form.initOtpFlow(contact: email, flow: 'reset');
    if (context.mounted) {
      context.pushNamed('verifyOtp', queryParameters: {
        'phone': email,
        'flow': 'reset',
      });
    }
  }
}
