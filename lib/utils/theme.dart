import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Warm Spiritual Minimalism" palette — calm, readable, premium-light.
///
/// Existing screens reference the historical names (`cream`, `warmBrown`,
/// `gold`, …). Those names are kept and re-pointed at the new RGB values,
/// so no caller needs to change.
class AppColors {
  AppColors._();

  // ---- Surfaces (warm, light) ----
  static const Color ivory = Color(0xFFFAF7F0);
  static const Color softCream = Color(0xFFF5EFE3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE9DFCF);

  // ---- Text (calm deep-navy / slate) ----
  static const Color deepNavy = Color(0xFF1D2636);
  static const Color slate = Color(0xFF647084);

  // ---- Accents ----
  static const Color warmGold = Color(0xFFC9A45C);
  static const Color goldTint = Color(0xFFEBD9B0);
  static const Color sageGreen = Color(0xFF6F8F72);
  static const Color sageMist = Color(0xFFEAF1EA);
  static const Color deepIndigo = Color(0xFF38406B);
  static const Color softRose = Color(0xFFB96B6B);

  // ---- Bright Catholic Devotional accents (Phase 07D) ----
  // Marian blue — used sparingly for Catholic devotional accents
  // (verse pills, plan badges, paywall halo). Lighter shade is for tints.
  static const Color marianBlue = Color(0xFF5A7BA8);
  static const Color marianBlueLight = Color(0xFFE1EAF4);

  // ---- Back-compat aliases used by existing screens ----
  static const Color cream = ivory;
  static const Color parchment = softCream;
  static const Color warmBrown = deepNavy;
  static const Color warmBrownMuted = slate;
  static const Color gold = warmGold;
  static const Color goldSoft = border;
  static const Color sage = sageGreen;
  static const Color sageLight = sageMist;
  static const Color premium = warmGold;
}

/// Standard radii for cards / buttons / inputs.
class AppRadii {
  AppRadii._();
  static const double card = 22;
  static const double button = 14;
  static const double input = 14;
  static const double chip = 14;
  static const double pill = 999;
}

/// Reusable soft shadow stacks.
class AppShadows {
  AppShadows._();

  /// Subtle elevation for cards / hero blocks.
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.deepNavy.withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  /// A barely-there lift for tiles and chips.
  static List<BoxShadow> hairline = [
    BoxShadow(
      color: AppColors.deepNavy.withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.warmGold,
      brightness: Brightness.light,
      primary: AppColors.warmGold,
      onPrimary: Colors.white,
      secondary: AppColors.sageGreen,
      onSecondary: Colors.white,
      tertiary: AppColors.deepIndigo,
      onTertiary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.deepNavy,
      error: AppColors.softRose,
    );

    final lora = GoogleFonts.loraTextTheme();
    final inter = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: base.copyWith(
        surfaceContainerLowest: AppColors.ivory,
        surfaceContainerLow: AppColors.softCream,
        outlineVariant: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.ivory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.deepNavy,
        iconTheme: const IconThemeData(color: AppColors.deepNavy),
        actionsIconTheme: const IconThemeData(color: AppColors.slate),
        titleTextStyle: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.deepNavy,
          letterSpacing: 0.1,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        height: 68,
        indicatorColor: AppColors.goldTint.withValues(alpha: 0.55),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.deepNavy : AppColors.slate,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.warmGold : AppColors.slate,
            size: 22,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.softCream,
        selectedColor: AppColors.goldTint,
        disabledColor: AppColors.softCream.withValues(alpha: 0.5),
        side: const BorderSide(color: AppColors.border),
        labelStyle: GoogleFonts.inter(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w500,
          fontSize: 12.5,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.chip),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.warmGold,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.goldTint,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepNavy,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.warmGold,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softCream.withValues(alpha: 0.55),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.warmGold, width: 1.6),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.slate),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.slate,
        textColor: AppColors.deepNavy,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        titleTextStyle: GoogleFonts.lora(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.deepNavy,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.slate,
          height: 1.5,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.deepNavy,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: TextTheme(
        displaySmall: lora.displaySmall?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headlineSmall: lora.headlineSmall?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: lora.titleLarge?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: inter.titleMedium?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: inter.titleSmall?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: inter.bodyLarge?.copyWith(
          color: AppColors.deepNavy,
          height: 1.55,
        ),
        bodyMedium: inter.bodyMedium?.copyWith(
          color: AppColors.slate,
          height: 1.5,
        ),
        bodySmall: inter.bodySmall?.copyWith(
          color: AppColors.slate,
          height: 1.45,
        ),
        labelLarge: inter.labelLarge?.copyWith(
          color: AppColors.deepNavy,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: inter.labelMedium?.copyWith(
          color: AppColors.slate,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.warmGold,
        linearTrackColor: AppColors.border,
      ),
    );
  }
}
