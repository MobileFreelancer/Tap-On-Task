import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive scaling via flutter_screenutil (design: 390×844).
class ResponsiveUtils {
  ResponsiveUtils._();

  static const Size designSize = Size(390, 844);

  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static double width(BuildContext context) => screenSize(context).width;

  static double height(BuildContext context) => screenSize(context).height;

  static double w(BuildContext context, double value) => value.w;

  static double h(BuildContext context, double value) => value.h;

  static double sp(BuildContext context, double value) => value.sp;

  static double radius(BuildContext context, double value) => value.r;

  static EdgeInsets padding(
    BuildContext context, {
    double horizontal = 24,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);

  static bool isSmallScreen(BuildContext context) => width(context) < 360;

  static bool isTablet(BuildContext context) => width(context) >= 600;
}

extension ResponsiveContext on BuildContext {
  double w(double value) => ResponsiveUtils.w(this, value);
  double h(double value) => ResponsiveUtils.h(this, value);
  double sp(double value) => ResponsiveUtils.sp(this, value);
  double r(double value) => ResponsiveUtils.radius(this, value);
}
