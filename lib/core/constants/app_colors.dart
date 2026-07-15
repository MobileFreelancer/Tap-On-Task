import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryPurple = Color(0xFF7D30FF);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primaryLight = Color(0xFFD9BFFF);
  static const Color primarySurface = Color(0xFFEDE9FE);

  // Auth-specific palette (from Figma)
  static const Color authPurple = Color(0xFF7D30FF);
  static const Color authPurpleLight = Color(0xFFD9BFFF);
  static const Color authNavy = Color(0xFF1B1B3A);
  static const Color authInputBg = Color(0xFFF5F5F5);
  static const Color textWhite = Color(0xFFFFFFFF);

  static const LinearGradient authGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7D30FF), Color(0xFFD9BFFF)],
  );

  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF3B82F6);

  static const Color backgroundOffWhite = Color(0xFFF7F4EF);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textGray400 = Color(0xFF9CA3AF);
  static const Color textGray500 = Color(0xFF6B7280);
  static const Color textGray600 = Color(0xFF4B5563);
  static const Color textGray700 = Color(0xFF374151);
  static const Color textGray900 = Color(0xFF111827);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);

  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);

  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceYellow = Color(0xFFFFFBEB);
  static const Color surfaceGreen = Color(0xFFECFDF5);
  static const Color surfaceRed = Color(0xFFFEF2F2);
  static const Color surfaceBlue = Color(0xFFEFF6FF);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color ratingStar = Color(0xFFF59E0B);
  static const Color unratedStar = Color(0xFFD1D5DB);

  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);
}
