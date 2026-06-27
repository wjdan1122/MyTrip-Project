import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1B3B4B);
  static const Color primary = Color(0xFF2C5E77);
  static const Color primaryMedium = Color(0xFF2C5364);
  static const Color background = Color(0xFFF7F9FC);
  static const Color white = Colors.white;
  static const Color textPrimary = Color(0xFF1B3B4B);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color cardBorder = Color(0xFFE5E5EA);
  static const Color luxuryGold = Color(0xFFD4A017);
  static const Color luxuryGoldBg = Color(0xFFFFF8E7);
  static const Color moderateBlue = Color(0xFF2C5E77);
  static const Color moderateBlueBg = Color(0xFFEBF5FF);
  static const Color economyGreen = Color(0xFF34A853);
  static const Color economyGreenBg = Color(0xFFE8F5E9);
  static const Color success = Color(0xFF34A853);
  static const Color error = Color(0xFFEA4335);
  static const Color progressInactive = Color(0xFFE5E5EA);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
