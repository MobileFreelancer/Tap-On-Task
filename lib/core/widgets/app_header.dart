import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapontask/core/constants/app_colors.dart';

import '../../generated/assets.dart';

class AppHeader extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final double? headerHeight;

  const AppHeader({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.headerHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double computedHeaderHeight = headerHeight ?? 180.h;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            AppAssets.appHeader,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          top: computedHeaderHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: child,
          ),
        ),
        Positioned(
          top: 45.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!showBackButton) ...[
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.sp,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],


                  Text(
                    title ?? "",
                    textAlign: showBackButton ? TextAlign.left : TextAlign.center,
                    style: GoogleFonts.sora(
                      color: AppColors.backgroundWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(width: 60.w,),
                  // Balancing spacing if back button is visible
                  if (showBackButton) SizedBox(width: 36.w),
                ],
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                Center(
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: AppColors.backgroundWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}