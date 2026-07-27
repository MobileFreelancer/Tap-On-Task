import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStylesInApp {
  // Sora Custom Preset
  static TextStyle soraHeader({
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.bold,
    Color color = Colors.white,
  }) {
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Roboto Custom Preset
  static TextStyle robotoBody({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}