import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../generated/assets.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_scaffold.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final form = context.watch<AuthFormProvider>();

    return AuthFullScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            const AuthLogo(size: 80),
            SizedBox(height: 16.h),
            Text(
              'Tap on Task',
              style: textTheme.headlineMedium?.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w700,
                fontSize: 28.sp,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoleCircle(
                  label: 'Customer',
                  iconAsset: AppAssets.customerIcon,
                  isSelected: form.selectedRole == UserRole.customer,
                  onTap: () => context.read<AuthFormProvider>().setRole(UserRole.customer),
                ),
                SizedBox(width: 48.w),
                _RoleCircle(
                  label: 'Trader',
                  iconAsset: AppAssets.traderIcon,
                  isSelected: form.selectedRole == UserRole.trader,
                  onTap: () => context.read<AuthFormProvider>().setRole(UserRole.trader),
                ),
              ],
            ),
            const Spacer(),
            _AuthChoiceButton(
              label: 'Sign In',
              isOutlined: true,
              onTap: () => context.pushNamed('login', queryParameters: {'role': form.selectedRole.name}),
            ),
            SizedBox(height: 14.h),
            _AuthChoiceButton(
              label: 'Register',
              isOutlined: false,
              onTap: () => context.pushNamed('signup', queryParameters: {'role': form.selectedRole.name}),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

class _RoleCircle extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCircle({
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 90.w,
            height: 90.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: AppColors.textWhite, width: 3) : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12.r)]
                  : null,
            ),
            child: Image.asset(iconAsset, fit: BoxFit.contain),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthChoiceButton extends StatelessWidget {
  final String label;
  final bool isOutlined;
  final VoidCallback onTap;

  const _AuthChoiceButton({
    required this.label,
    required this.isOutlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textWhite,
                side: const BorderSide(color: AppColors.textWhite, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              child: Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textWhite,
                  fontSize: 16.sp,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textWhite,
                foregroundColor: AppColors.authPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              child: Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.authPurple,
                  fontSize: 16.sp,
                ),
              ),
            ),
    );
  }
}
