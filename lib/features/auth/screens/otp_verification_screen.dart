import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String flow;
  const OtpVerificationScreen({super.key, required this.phoneNumber, this.flow = 'verify'});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormProvider>();
    final auth = context.watch<AuthService>();

    if (form.otpContact != phoneNumber || form.otpFlow != flow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthFormProvider>().initOtpFlow(contact: phoneNumber, flow: flow);
      });
    }

    return AuthScaffold(
      headerTitle: 'Code',
      showBack: true,
      showLogo: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Verification code is received via email or phone.',
            style: AppTextStyles.authSubtitle(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.h(32)),
          OtpInputRow(
            digits: form.otpDigits,
            onChanged: (i, v) => context.read<AuthFormProvider>().setOtpDigit(i, v),
          ),
          SizedBox(height: context.h(24)),
          Center(
            child: form.canResend
                ? GestureDetector(
                    onTap: () => context.read<AuthFormProvider>().startResendTimer(),
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.authBody(context),
                        children: [
                          const TextSpan(text: "Didn't get the Code "),
                          TextSpan(text: 'Resend', style: AppTextStyles.authLink(context)),
                        ],
                      ),
                    ),
                  )
                : Text(
                    'Resend code in ${form.resendSeconds} seconds',
                    style: AppTextStyles.authBody(context),
                  ),
          ),
          SizedBox(height: context.h(28)),
          AuthPrimaryButton(
            label: 'Verify',
            isLoading: auth.isLoading,
            onPressed: form.isOtpComplete ? () => _handleVerify(context) : null,
          ),
          if (auth.error != null) ...[
            SizedBox(height: context.h(12)),
            Text(auth.error!, style: TextStyle(color: AppColors.error, fontSize: context.sp(13)), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }

  Future<void> _handleVerify(BuildContext context) async {
    final form = context.read<AuthFormProvider>();
    final auth = context.read<AuthService>();

    final success = await auth.verifyOtp(phone: phoneNumber, otp: form.otpCode);
    if (!context.mounted) return;

    if (success) {
      if (flow == 'reset') {
        context.goNamed('resetPassword', queryParameters: {'phone': phoneNumber});
      } else {
        final route = auth.isCustomer ? '/customer/dashboard' : '/trader/dashboard';
        context.go(route);
      }
    }
  }
}
