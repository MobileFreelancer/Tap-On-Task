import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../generated/assets.dart';
import '../providers/auth_form_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashBody();
  }
}

class _SplashBody extends StatefulWidget {
  const _SplashBody();

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _rolesController;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _customerSlide;
  late final Animation<Offset> _traderSlide;
  late final Animation<double> _rolesFade;

  bool _showRoles = false;
  bool _navigated = false;

  static const _splashDelay = Duration(seconds: 3);
  static const _logoUpDuration = Duration(milliseconds: 700);
  static const _rolesAnimDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _rolesController = AnimationController(vsync: this, duration: _rolesAnimDuration);

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _rolesFade = CurvedAnimation(parent: _rolesController, curve: Curves.easeOut);
    _customerSlide = Tween<Offset>(begin: const Offset(-0.5, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _rolesController, curve: Curves.easeOutCubic));
    _traderSlide = Tween<Offset>(begin: const Offset(0.5, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _rolesController, curve: Curves.easeOutCubic));

    _logoController.forward();
    _startFlow();
  }

  Future<void> _startFlow() async {
    await Future.delayed(_splashDelay);
    if (!mounted || _navigated) return;

    final auth = context.read<AuthService>();
    if (auth.isLoggedIn) {
      _navigateToDashboard(auth);
      return;
    }

    setState(() => _showRoles = true);
    _rolesController.forward();
  }

  void _navigateToDashboard(AuthService auth) {
    if (_navigated || !mounted) return;
    _navigated = true;
    final route = auth.isCustomer ? '/customer/dashboard' : '/trader/dashboard';
    context.go(route);
  }

  void _onRoleTap(UserRole role) {
    context.read<AuthFormProvider>().setRole(role);
    context.goNamed('login', queryParameters: {'role': role.name});
  }

  @override
  void dispose() {
    _logoController.dispose();
    _rolesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthFullScaffold(
      child: SizedBox.expand(
        child: AnimatedAlign(
          duration: _showRoles ? _logoUpDuration : Duration.zero,
          curve: Curves.easeOutCubic,
          alignment: _showRoles ? const Alignment(0, -0.12) : Alignment.center,
          child: FadeTransition(
            opacity: _logoFade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthLogo(size: 180),

                if (_showRoles) ...[
                  SizedBox(height: 48.h),
                  FadeTransition(
                    opacity: _rolesFade,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SlideTransition(
                          position: _customerSlide,
                          child: _RoleButton(
                            label: 'Customer',
                            iconAsset: AppAssets.customerIcon,
                            onTap: () => _onRoleTap(UserRole.customer),
                          ),
                        ),
                        SizedBox(width: 48.w),
                        SlideTransition(
                          position: _traderSlide,
                          child: _RoleButton(
                            label: 'Trader',
                            iconAsset: AppAssets.traderIcon,
                            onTap: () => _onRoleTap(UserRole.trader),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: const BoxDecoration(
              color: AppColors.textWhite,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(20.w),
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
