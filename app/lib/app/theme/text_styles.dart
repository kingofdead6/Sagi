import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saji/app/theme/tokens.dart';

/// Noto Sans Arabic for the customer app, Tajawal for the admin dashboard —
/// both at the exact sizes, weights and tracking from the Figma file.
abstract final class AppText {
  static TextStyle _noto({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = 0,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.notoSansArabic(
      fontSize: size,
      fontWeight: weight,
      height: height / size,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle _tajawal({
    required double size,
    required FontWeight weight,
    double height = 1.5,
    Color color = AppColors.adminText,
  }) {
    return GoogleFonts.tajawal(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
    );
  }

  // ── customer ──────────────────────────────────────────────────────────
  static TextStyle get sectionTitle =>
      _noto(size: 24, weight: FontWeight.w800, height: 32, letterSpacing: -0.6);

  static TextStyle get cardTitle => _noto(size: 20, weight: FontWeight.w700, height: 28);

  static TextStyle get body => _noto(size: 16, weight: FontWeight.w500, height: 24);

  static TextStyle get bodyStrong => _noto(size: 16, weight: FontWeight.w600, height: 24);

  static TextStyle get meta =>
      _noto(size: 14, weight: FontWeight.w400, height: 20, color: AppColors.textSecondary);

  static TextStyle get metaStrong => _noto(size: 14, weight: FontWeight.w700, height: 20);

  static TextStyle get badge =>
      _noto(size: 12, weight: FontWeight.w700, height: 16, letterSpacing: 0.6);

  static TextStyle get navLabel =>
      _noto(size: 11, weight: FontWeight.w600, height: 16.5, letterSpacing: 1.1);

  static TextStyle get header =>
      _noto(size: 16, weight: FontWeight.w600, height: 24, color: AppColors.headerText);

  static TextStyle get placeholder =>
      _noto(size: 16, weight: FontWeight.w500, height: 24, color: AppColors.textPlaceholder);

  // ── admin ─────────────────────────────────────────────────────────────
  static TextStyle get adminHeading =>
      _tajawal(size: 24, weight: FontWeight.w700, color: AppColors.headerText);

  static TextStyle get adminSubheading => _tajawal(size: 18, weight: FontWeight.w700);

  static TextStyle get adminNav => _tajawal(size: 14, weight: FontWeight.w500);

  static TextStyle get adminNavActive =>
      _tajawal(size: 14, weight: FontWeight.w700, color: AppColors.adminAccent);

  static TextStyle get adminTable => _tajawal(size: 14, weight: FontWeight.w500);

  static TextStyle get adminTableHead =>
      _tajawal(size: 13, weight: FontWeight.w700, color: AppColors.adminText);

  static TextStyle get adminStat =>
      _tajawal(size: 28, weight: FontWeight.w700, color: AppColors.headerText);
}
