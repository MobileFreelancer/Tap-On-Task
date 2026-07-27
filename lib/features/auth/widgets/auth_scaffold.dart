import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../generated/assets.dart';
import 'auth_background.dart';

class AuthScaffold extends StatelessWidget {
  final String? headerTitle;
  final bool showBack;
  final Widget child;
  final bool showLogo;

  const AuthScaffold({
    super.key,
    this.headerTitle,
    this.showBack = false,
    required this.child,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final topPad = MediaQuery.paddingOf(context).top;
    final headerHeight = showLogo ? 220.h : 140.h + topPad;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.bgCommon, fit: BoxFit.cover),
                SafeArea(
                  bottom: false,
                  child: showLogo
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AuthLogo(size: 56),
                            SizedBox(height: 10.h),
                            Text(
                              'Tap on Task',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              if (showBack)
                                _BackButton(onTap: () => context.pop())
                              else
                                SizedBox(width: 40.w),
                              Expanded(
                                child: Text(
                                  headerTitle ?? '',
                                  textAlign: TextAlign.center,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 40.w),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -28.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20.r,
                      offset: Offset(0, -4.h),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: AppColors.textWhite,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.chevron_left_rounded, color: AppColors.authNavy, size: 24.sp),
      ),
    );
  }
}

/// Full-screen scaffold for splash screen only.
class AuthFullScaffold extends StatelessWidget {
  final Widget child;
  const AuthFullScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(child: SafeArea(child: child)),
    );
  }
}
