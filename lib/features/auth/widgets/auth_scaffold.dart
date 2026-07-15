import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';
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
    final headerHeight = context.h(showLogo ? 200 : 140);

    return Scaffold(
      backgroundColor: AppColors.authPurple,
      body: Stack(
        children: [
          AuthGradientBackground(
            child: SafeArea(
              child: SizedBox(
                height: headerHeight,
                child: Column(
                  children: [
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: context.w(16), top: context.h(8)),
                          child: _BackButton(onTap: () => context.pop()),
                        ),
                      )
                    else
                      SizedBox(height: context.h(16)),
                    if (headerTitle != null)
                      Text(headerTitle!, style: AppTextStyles.authHeaderTitle(context)),
                    if (showLogo) ...[
                      SizedBox(height: context.h(16)),
                      const AuthLogo(),
                      SizedBox(height: context.h(12)),
                      Text('Tap on Task', style: AppTextStyles.splashTitle(context)),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: headerHeight - context.h(24),
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(32))),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.w(24),
                    context.h(28),
                    context.w(24),
                    context.h(24),
                  ),
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
        width: context.w(40),
        height: context.w(40),
        decoration: const BoxDecoration(
          color: AppColors.textWhite,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.chevron_left_rounded, color: AppColors.authNavy, size: context.w(24)),
      ),
    );
  }
}

/// Full-screen gradient scaffold for splash & role selection.
class AuthFullScaffold extends StatelessWidget {
  final Widget child;
  const AuthFullScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthGradientBackground(
        child: SafeArea(child: child),
      ),
    );
  }
}
