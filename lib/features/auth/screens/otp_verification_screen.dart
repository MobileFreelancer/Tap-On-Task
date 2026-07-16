import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_scaffold.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String flow;
  const OtpVerificationScreen({super.key, required this.phoneNumber, this.flow = 'verify'});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
          SizedBox(height: 20.h),
          Text(
            'Verification code is received via email or phone.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textGray500,
              fontSize: 14.sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          OtpInputRow(
            digits: form.otpDigits,
            onChanged: (i, v) => context.read<AuthFormProvider>().setOtpDigit(i, v),
          ),
          SizedBox(height: 24.h),
          Center(
            child: form.canResend
                ? GestureDetector(
                    onTap: () => context.read<AuthFormProvider>().startResendTimer(),
                    child: Text.rich(
                      TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.authNavy,
                          fontSize: 13.sp,
                        ),
                        children: [
                          const TextSpan(text: "Didn't get the Code? "),
                          TextSpan(
                            text: 'Resend',
                            style: textTheme.labelLarge?.copyWith(
                              color: AppColors.authPurple,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    'Resend code in ${form.resendSeconds} seconds',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textGray500,
                      fontSize: 13.sp,
                    ),
                  ),
          ),
          SizedBox(height: 28.h),
          AuthPrimaryButton(
            label: 'Verify',
            isLoading: auth.isLoading,
            onPressed: form.isOtpComplete ? () => _handleVerify(context) : null,
          ),
          if (auth.error != null) ...[
            SizedBox(height: 12.h),
            Text(
              auth.error!,
              style: textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
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
