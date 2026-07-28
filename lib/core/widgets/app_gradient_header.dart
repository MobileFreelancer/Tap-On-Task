import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/assets.dart';

/// Reusable purple gradient header used on dashboard, profile, and auth screens.
class AppGradientHeader extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget? child;
  final double height;
  final bool showBack;
  final VoidCallback? onBack;

  const AppGradientHeader({
    super.key,
    this.title,
    this.subTitle,
    this.child,
    this.height = 220,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgCommon, fit: BoxFit.cover),
          if (showBack)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8.h,
              left: 16.w,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chevron_left_rounded, color: Colors.black87, size: 24.sp),
                ),
              ),
            ),
          if (title != null)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                       title!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if(subTitle != null)
                    Text(
                      subTitle!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (child != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: child!,
            ),
        ],
      ),
    );
  }
}
