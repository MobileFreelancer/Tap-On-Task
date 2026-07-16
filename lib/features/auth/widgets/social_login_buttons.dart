import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../generated/assets.dart';
import '../providers/auth_form_provider.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final auth = context.watch<AuthService>();
    final form = context.read<AuthFormProvider>();
    final showApple = !Platform.isAndroid;

    Future<void> onSocialSuccess(bool success) async {
      if (success && context.mounted) {
        final route = form.selectedRole == UserRole.customer
            ? '/customer/dashboard'
            : '/trader/dashboard';
        context.go(route);
      }
    }

    void showFirebaseError() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase is not ready. Please restart the app.')),
      );
    }

    return Column(
      children: [
        if (!auth.firebaseReady)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              'Social login requires Firebase. Check your configuration.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
          ),
        Row(
          children: [
            if (showApple) ...[
              Expanded(
                child: _SocialButton(
                  assetIcon: AppAssets.appleIcon,
                  label: 'Apple',
                  onTap: !auth.firebaseReady || auth.isLoading
                      ? showFirebaseError
                      : () async {
                          final success = await auth.signInWithApple(role: form.selectedRole);
                          await onSocialSuccess(success);
                        },
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: _SocialButton(
                assetIcon: AppAssets.googleIcon,
                label: 'Google',
                onTap: !auth.firebaseReady || auth.isLoading
                    ? showFirebaseError
                    : () async {
                        final success = await auth.signInWithGoogle(role: form.selectedRole);
                        await onSocialSuccess(success);
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String assetIcon;
  final String label;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.assetIcon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.authInputBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetIcon, width: 20.w, height: 20.w, fit: BoxFit.contain),
            SizedBox(width: 8.w),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
