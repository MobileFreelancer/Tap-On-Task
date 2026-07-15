import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_scaffold.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormProvider>();

    return AuthFullScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(24)),
        child: Column(
          children: [
            SizedBox(height: context.h(60)),
            const AuthLogo(size: 80),
            SizedBox(height: context.h(16)),
            Text('Tap on Task', style: AppTextStyles.splashTitle(context)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoleCircle(
                  label: 'Customer',
                  icon: Icons.person_outline_rounded,
                  isSelected: form.selectedRole == UserRole.customer,
                  onTap: () => context.read<AuthFormProvider>().setRole(UserRole.customer),
                ),
                SizedBox(width: context.w(48)),
                _RoleCircle(
                  label: 'Trader',
                  icon: Icons.verified_user_outlined,
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
            SizedBox(height: context.h(14)),
            _AuthChoiceButton(
              label: 'Register',
              isOutlined: false,
              onTap: () => context.pushNamed('signup', queryParameters: {'role': form.selectedRole.name}),
            ),
            SizedBox(height: context.h(40)),
          ],
        ),
      ),
    );
  }
}

class _RoleCircle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCircle({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: context.w(90),
            height: context.w(90),
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.textWhite, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12)]
                  : null,
            ),
            child: Icon(icon, size: context.w(36), color: AppColors.authPurple),
          ),
          SizedBox(height: context.h(12)),
          Text(label, style: AppTextStyles.roleLabel(context)),
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
    return SizedBox(
      width: double.infinity,
      height: context.h(52),
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textWhite,
                side: const BorderSide(color: AppColors.textWhite, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(14))),
              ),
              child: Text(label, style: AppTextStyles.authButton(context)),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textWhite,
                foregroundColor: AppColors.authPurple,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(14))),
              ),
              child: Text(label, style: AppTextStyles.authButton(context).copyWith(color: AppColors.authPurple)),
            ),
    );
  }
}
