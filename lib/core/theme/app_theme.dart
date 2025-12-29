import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primary = Color(0xFF006D77); // Deep Teal
  static const Color secondary = Color(0xFF83C5BE); // Soft Mint
  static const Color background = Color(0xFFEDF6F9); // Very pale blue-white
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF2B2D42);
  static const Color error = Color(0xFFEF233C); // Alert Red

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: surface,
      ),

      // Typography
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
        bodyLarge: GoogleFonts.lato(
            fontSize: 16, color: textDark),
        bodyMedium: GoogleFonts.lato(
            fontSize: 14, color: textDark.withAlpha((255 * 0.8).round())),
      ),

      // Card Styling (Rounded & Soft)
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
