import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // Tokens
  static const Color primaryBlue = Color(0xFF00236F);
  static const Color primaryContainer = Color(0xFF1E3A8A);
  static const Color primaryRed = Color(0xFFBA1A1A);
  static const Color primaryOrange = Color(0xFF4B1C00);
  
  static const Color bgLight = Color(0xFFF7F9FB);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF191C1E);
  static const Color textMuted = Color(0xFF444651);
  
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Glassmorphism
  static const double glassOpacity = 0.8;
  static const double glassBlur = 24.0;

  static ThemeData get baseTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        onPrimary: Colors.white,
        secondary: const Color(0xFF515F74),
        surface: bgLight,
        onSurface: textDark,
        surfaceVariant: const Color(0xFFE0E3E5),
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.manrope(
          color: textDark,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.manrope(
          color: textMuted,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 10,
          color: textMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700, 
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
      ),

    );
  }

  static ThemeData get policeTheme => baseTheme.copyWith(
    primaryColor: primaryBlue,
    colorScheme: baseTheme.colorScheme.copyWith(primary: primaryBlue),
  );

  static ThemeData get ambulanceTheme => baseTheme.copyWith(
    primaryColor: primaryRed,
    colorScheme: baseTheme.colorScheme.copyWith(primary: primaryRed),
  );

  static ThemeData get fireTheme => baseTheme.copyWith(
    primaryColor: primaryOrange,
    colorScheme: baseTheme.colorScheme.copyWith(primary: primaryOrange),
  );

  static ThemeData get defaultTheme => baseTheme;
}
