import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, light, spiritual palette tuned for a US faith-audience MVP.
class AppColors {
  AppColors._();

  static const Color cream = Color(0xFFFFF9F2);
  static const Color parchment = Color(0xFFF5EDE0);
  static const Color warmBrown = Color(0xFF3D3228);
  static const Color warmBrownMuted = Color(0xFF6B5E52);
  static const Color gold = Color(0xFFB8860B);
  static const Color goldSoft = Color(0xFFE8D4A8);
  static const Color sage = Color(0xFF5C7A62);
  static const Color sageLight = Color(0xFFE8F0E9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color premium = Color(0xFFD4A017);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.light,
      primary: AppColors.gold,
      onPrimary: Colors.white,
      secondary: AppColors.sage,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.warmBrown,
    );

    final lora = GoogleFonts.loraTextTheme();
    final inter = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        surfaceContainerLowest: AppColors.cream,
        surfaceContainerLow: AppColors.parchment,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.warmBrown,
        titleTextStyle: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.warmBrown,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.goldSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.gold : AppColors.warmBrownMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gold : AppColors.warmBrownMuted,
            size: 22,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.goldSoft.withValues(alpha: 0.6)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.goldSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.warmBrownMuted),
        contentPadding: const EdgeInsets.all(16),
      ),
      textTheme: TextTheme(
        displaySmall: lora.displaySmall?.copyWith(
          color: AppColors.warmBrown,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: lora.titleLarge?.copyWith(
          color: AppColors.warmBrown,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: inter.titleMedium?.copyWith(
          color: AppColors.warmBrown,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: inter.bodyLarge?.copyWith(
          color: AppColors.warmBrown,
          height: 1.5,
        ),
        bodyMedium: inter.bodyMedium?.copyWith(
          color: AppColors.warmBrownMuted,
          height: 1.45,
        ),
        bodySmall: inter.bodySmall?.copyWith(
          color: AppColors.warmBrownMuted,
        ),
        labelLarge: inter.labelLarge?.copyWith(
          color: AppColors.warmBrown,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.goldSoft),
    );
  }
}
