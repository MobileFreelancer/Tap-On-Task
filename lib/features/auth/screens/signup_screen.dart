import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/social_login_buttons.dart';

class SignupScreen extends StatelessWidget {
  final String initialRole;
  const SignupScreen({super.key, this.initialRole = 'customer'});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final form = context.watch<AuthFormProvider>();
    final auth = context.watch<AuthService>();

    if (form.selectedRole.name != initialRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthFormProvider>().setRole(
          initialRole == 'trader' ? UserRole.trader : UserRole.customer,
        );
      });
    }

    return AuthScaffold(
      showLogo: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Register',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.authNavy,
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 28.h),
          AuthInputField(
            hint: 'Name',
            icon: Icons.person_outline_rounded,
            controller: form.nameController,
          ),
          SizedBox(height: 14.h),
          AuthInputField(
            hint: 'Email',
            icon: Icons.email_outlined,
            controller: form.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 14.h),
          AuthPasswordField(
            hint: 'Password',
            controller: form.passwordController,
            obscure: form.obscurePassword,
            onToggle: () => context.read<AuthFormProvider>().togglePasswordVisibility(),
          ),
          SizedBox(height: 14.h),
          AuthInputField(
            hint: 'Phone Number',
            maxLength: 10,
            icon: Icons.phone_outlined,
            controller: form.phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: Checkbox(
                  value: form.termsAccepted,
                  onChanged: (v) => context.read<AuthFormProvider>().setTermsAccepted(v ?? false),
                  activeColor: AppColors.authPurple,
                  side: const BorderSide(color: AppColors.borderMedium),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textGray500,
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to the '),
                      TextSpan(
                        text: 'Terms & conditions',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.authPurple,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.authPurple,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          AuthPrimaryButton(
            label: 'Register',
            isLoading: auth.isLoading,
            onPressed: () => _handleSignup(context),
          ),
          if (auth.error != null) ...[
            SizedBox(height: 12.h),
            Text(
              auth.error!,
              style: textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ],
          const AuthDivider(),
          const SocialLoginButtons(),
          SizedBox(height: 24.h),
          Center(
            child: Text.rich(
              TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textGray500,
                  fontSize: 13.sp,
                ),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign in',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.authPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.pushNamed('login', queryParameters: {'role': form.selectedRole.name}),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignup(BuildContext context) async {
    final form = context.read<AuthFormProvider>();
    final auth = context.read<AuthService>();
    auth.clearError();

    final error = form.validateSignup();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final otp = await auth.signup(
      name: form.nameController.text.trim(),
      email: form.emailController.text.trim(),
      phone: form.phoneController.text.trim(),
      password: form.passwordController.text,
    );

    if (otp != null && context.mounted) {
      final email = form.emailController.text.trim();
      form.initOtpFlow(contact: email, flow: 'verify');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent successfully: $otp'),
          duration: const Duration(seconds: 8),
          backgroundColor: AppColors.authPurple,
        ),
      );
      context.pushNamed('verifyOtp', queryParameters: {
        'phone': email,
        'flow': 'verify',
      });
    }
  }
}
