import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  final String initialRole;
  const LoginScreen({super.key, this.initialRole = 'customer'});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text('Sign In', style: AppTextStyles.authCardTitle(context))),
          SizedBox(height: context.h(24)),
          AuthInputField(
            hint: 'Email',
            icon: Icons.email_outlined,
            controller: form.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          AuthPasswordField(
            hint: 'Password',
            controller: form.passwordController,
            obscure: form.obscurePassword,
            onToggle: () => context.read<AuthFormProvider>().togglePasswordVisibility(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed('forgotPassword'),
              child: Text('Forgot Password?', style: AppTextStyles.authLink(context)),
            ),
          ),
          SizedBox(height: context.h(8)),
          AuthPrimaryButton(
            label: 'Login',
            isLoading: auth.isLoading,
            onPressed: () => _handleLogin(context),
          ),
          if (auth.error != null) ...[
            SizedBox(height: context.h(12)),
            Text(auth.error!, style: TextStyle(color: AppColors.error, fontSize: context.sp(13)), textAlign: TextAlign.center),
          ],
          const AuthDivider(),
          const SocialLoginButtons(),
          SizedBox(height: context.h(20)),
          Center(
            child: GestureDetector(
              onTap: () => context.pushNamed('signup', queryParameters: {'role': form.selectedRole.name}),
              child: Text('Create an account', style: AppTextStyles.authLink(context)),
            ),
          ),
          SizedBox(height: context.h(20)),
          Text.rich(
            TextSpan(
              style: AppTextStyles.legalText(context),
              children: [
                const TextSpan(text: 'By proceeding you also agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: AppTextStyles.authLink(context).copyWith(fontSize: context.sp(11)),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTextStyles.authLink(context).copyWith(fontSize: context.sp(11)),
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
      phone: form.emailController.text.trim(),
      password: form.passwordController.text,
      role: form.selectedRole,
    );

    if (success && context.mounted) {
      final route = form.selectedRole == UserRole.customer ? '/customer/dashboard' : '/trader/dashboard';
      context.go(route);
    }
  }
}
