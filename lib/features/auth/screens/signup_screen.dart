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

class SignupScreen extends StatelessWidget {
  final String initialRole;
  const SignupScreen({super.key, this.initialRole = 'customer'});

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
          Center(child: Text('Register', style: AppTextStyles.authCardTitle(context))),
          SizedBox(height: context.h(24)),
          AuthInputField(
            hint: 'Name',
            icon: Icons.person_outline_rounded,
            controller: form.nameController,
          ),
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
          AuthInputField(
            hint: 'Phone Number',
            icon: Icons.phone_outlined,
            controller: form.phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: context.h(4)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.w(24),
                height: context.w(24),
                child: Checkbox(
                  value: form.termsAccepted,
                  onChanged: (v) => context.read<AuthFormProvider>().setTermsAccepted(v ?? false),
                  activeColor: AppColors.authPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              SizedBox(width: context.w(8)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.authBody(context),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to the '),
                      TextSpan(
                        text: 'Terms & conditions',
                        style: AppTextStyles.authLink(context).copyWith(fontSize: context.sp(13)),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.authLink(context).copyWith(fontSize: context.sp(13)),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          AuthPrimaryButton(
            label: 'Register',
            isLoading: auth.isLoading,
            onPressed: () => _handleSignup(context),
          ),
          if (auth.error != null) ...[
            SizedBox(height: context.h(12)),
            Text(auth.error!, style: TextStyle(color: AppColors.error, fontSize: context.sp(13)), textAlign: TextAlign.center),
          ],
          const AuthDivider(),
          const SocialLoginButtons(),
          SizedBox(height: context.h(20)),
          Center(
            child: Text.rich(
              TextSpan(
                style: AppTextStyles.authBody(context),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign in',
                    style: AppTextStyles.authLink(context),
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

    final success = await auth.signup(
      phone: form.phoneController.text.trim(),
      password: form.passwordController.text,
      role: form.selectedRole,
      name: form.nameController.text.trim(),
      email: form.emailController.text.trim(),
    );

    if (success && context.mounted) {
      form.initOtpFlow(contact: form.phoneController.text.trim(), flow: 'verify');
      context.pushNamed('verifyOtp', queryParameters: {
        'phone': form.phoneController.text.trim(),
        'flow': 'verify',
      });
    }
  }
}
