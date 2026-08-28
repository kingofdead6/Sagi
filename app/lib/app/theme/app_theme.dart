import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

abstract final class AppTheme {
  static ThemeData get customer {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryGreenTint,
        onPrimaryContainer: AppColors.primaryGreenDeep,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.accentSoft,
        tertiary: AppColors.highlight,
        error: AppColors.danger,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.notoSansArabicTextTheme(),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.searchFill, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.searchFill,
        hintStyle: AppText.placeholder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          textStyle: AppText.bodyStrong,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppText.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
      ),
    );
  }

  /// The admin dashboard uses the blue language, Tajawal, and denser metrics.
  static ThemeData get admin {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.adminAccent,
        primary: AppColors.adminAccent,
        surface: AppColors.adminSurface,
      ),
      scaffoldBackgroundColor: AppColors.adminSurface,
      textTheme: GoogleFonts.tajawalTextTheme(),
    );

    return base.copyWith(
      dividerTheme: const DividerThemeData(color: AppColors.adminBorder, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.adminRowHover,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: const BorderSide(color: AppColors.adminBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: const BorderSide(color: AppColors.adminBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
          borderSide: const BorderSide(color: AppColors.adminAccent, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.adminAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          textStyle: AppText.adminNav.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
