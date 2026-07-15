import 'package:flutter/material.dart';

/// Responsive scaling utilities based on a 390px design width.
class ResponsiveUtils {
  ResponsiveUtils._();

  static const double _designWidth = 390;
  static const double _designHeight = 844;

  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static double width(BuildContext context) => screenSize(context).width;

  static double height(BuildContext context) => screenSize(context).height;

  static double scale(BuildContext context) => width(context) / _designWidth;

  static double w(BuildContext context, double value) => value * scale(context);

  static double h(BuildContext context, double value) =>
      value * (height(context) / _designHeight);

  static double sp(BuildContext context, double value) {
    final scaleFactor = scale(context).clamp(0.85, 1.15);
    return value * scaleFactor;
  }

  static double radius(BuildContext context, double value) => w(context, value);

  static EdgeInsets padding(BuildContext context, {
    double horizontal = 24,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        horizontal: w(context, horizontal),
        vertical: h(context, vertical),
      );

  static bool isSmallScreen(BuildContext context) => width(context) < 360;

  static bool isTablet(BuildContext context) => width(context) >= 600;
}

extension ResponsiveContext on BuildContext {
  double get rw => ResponsiveUtils.scale(this);
  double w(double value) => ResponsiveUtils.w(this, value);
  double h(double value) => ResponsiveUtils.h(this, value);
  double sp(double value) => ResponsiveUtils.sp(this, value);
  double r(double value) => ResponsiveUtils.radius(this, value);
}
