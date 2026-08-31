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

class LoginScreen extends StatelessWidget {
  final String initialRole;
  const LoginScreen({super.key, this.initialRole = 'customer'});

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
            'Sign In',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.authNavy,
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 28.h),
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
          SizedBox(height: 16.h),
          AuthPrimaryButton(
            label: 'Login',
            isLoading: auth.isLoading,
            onPressed: () => _handleLogin(context),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pushNamed('forgotPassword'),
              child: Text(
                'Forgot Password?',
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.authPurple,
                  fontSize: 14.sp,
                ),
              ),
            ),
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
            child: GestureDetector(
              onTap: () => context.pushNamed('signup', queryParameters: {'role': form.selectedRole.name}),
              child: Text(
                'Create an account',
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.authPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text.rich(
            TextSpan(
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textGray400,
                fontSize: 11.sp,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'By proceeding you also agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.authPurple,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.authPurple,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final form = context.read<AuthFormProvider>();
    final auth = context.read<AuthService>();
    auth.clearError();

    final error = form.validateLogin();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final success = await auth.login(
      email: form.emailController.text.trim(),
      password: form.passwordController.text,
    );

    if (success && context.mounted) {
      final route = auth.isTrader ? '/trader/dashboard' : '/customer/dashboard';
      context.go(route);
    }
  }
}
