import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final form = context.watch<AuthFormProvider>();
    final auth = context.watch<AuthService>();

    return AuthScaffold(
      headerTitle: 'Forgot Password?',
      showBack: true,
      showLogo: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recover Password',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.authNavy,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "Enter the email address associated with your account, and we'll send you a secure link to reset your password.",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textGray500,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 28.h),
          AuthInputField(
            hint: 'Email or phone number',
            icon: Icons.email_outlined,
            controller: form.forgotEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 12.h),
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
