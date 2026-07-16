import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';

class AuthLogo extends StatelessWidget {
  final double size;
  const AuthLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
    );
  }
}

/// Full-screen splash background.
class SplashBackground extends StatelessWidget {
  final Widget? child;
  const SplashBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.splashBg, fit: BoxFit.cover),
        if (child != null) child!,
      ],
    );
  }
}

/// Auth header background (login, register, forgot password, etc.).
class AuthCommonBackground extends StatelessWidget {
  final double height;
  const AuthCommonBackground({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(AppAssets.bgCommon, fit: BoxFit.cover),
    );
  }
}
