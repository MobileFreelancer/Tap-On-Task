import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle splashTitle(BuildContext context) => GoogleFonts.manrope(
        fontSize: context.sp(28),
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
        letterSpacing: 0.3,
      );

  static TextStyle authHeaderTitle(BuildContext context) => GoogleFonts.manrope(
        fontSize: context.sp(22),
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle authCardTitle(BuildContext context) => GoogleFonts.manrope(
        fontSize: context.sp(24),
        fontWeight: FontWeight.w700,
        color: AppColors.authNavy,
      );

  static TextStyle authSubtitle(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(14),
        fontWeight: FontWeight.w400,
        color: AppColors.textGray500,
        height: 1.5,
      );

  static TextStyle authInputHint(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(14),
        fontWeight: FontWeight.w400,
        color: AppColors.textGray400,
      );

  static TextStyle authInputText(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(14),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle authButton(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(16),
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      );

  static TextStyle authLink(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(14),
        fontWeight: FontWeight.w600,
        color: AppColors.authPurple,
      );

  static TextStyle authBody(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(13),
        fontWeight: FontWeight.w400,
        color: AppColors.textGray500,
      );

  static TextStyle authDivider(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(12),
        fontWeight: FontWeight.w400,
        color: AppColors.textGray400,
      );

  static TextStyle roleLabel(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(15),
        fontWeight: FontWeight.w500,
        color: AppColors.textWhite,
      );

  static TextStyle otpDigit(BuildContext context) => GoogleFonts.manrope(
        fontSize: context.sp(22),
        fontWeight: FontWeight.w700,
        color: AppColors.authNavy,
      );

  static TextStyle legalText(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(11),
        fontWeight: FontWeight.w400,
        color: AppColors.textGray400,
        height: 1.4,
      );

  static TextStyle socialButton(BuildContext context) => GoogleFonts.inter(
        fontSize: context.sp(14),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
}
