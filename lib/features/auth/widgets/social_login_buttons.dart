import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.only(bottom: context.h(12)),
            child: Text(
              'Social login requires Firebase. Check your configuration.',
              style: TextStyle(color: AppColors.error, fontSize: context.sp(12)),
              textAlign: TextAlign.center,
            ),
          ),
        Row(
          children: [
            if (showApple) ...[
              Expanded(
                child: _SocialButton(
                  icon: Icons.apple_rounded,
                  label: 'Apple',
                  onTap: !auth.firebaseReady || auth.isLoading
                      ? showFirebaseError
                      : () async {
                          final success = await auth.signInWithApple(role: form.selectedRole);
                          await onSocialSuccess(success);
                        },
                ),
              ),
              SizedBox(width: context.w(12)),
            ],
            Expanded(
              child: _SocialButton(
                icon: Icons.g_mobiledata_rounded,
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
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.h(48),
        decoration: BoxDecoration(
          color: AppColors.authInputBg,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.w(22), color: AppColors.textPrimary),
            SizedBox(width: context.w(8)),
            Text(label, style: AppTextStyles.socialButton(context)),
          ],
        ),
      ),
    );
  }
}
