import 'package:flutter/material.dart';

/// Design tokens extracted from the Saji Figma file
/// (`cnVxqadfDEVLtRRXCeye7I`). Feature code must never hard-code a hex value —
/// every colour, radius and shadow in the app comes from here.
abstract final class AppColors {
  // ── customer (mobile) ──────────────────────────────────────────────────
  static const primaryGreen = Color(0xFF16A34A);
  static const primaryGreenDeep = Color(0xFF017A33);
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const searchFill = Color(0xFFE7E8E9);

  static const textPrimary = Color(0xFF191C1D);
  static const textSecondary = Color(0xFF3E4A3D);
  static const textPlaceholder = Color(0x993E4A3D); // rgba(62,74,61,.6)
  static const textMuted = Color(0xFF94A3B8);
  static const headerText = Color(0xFF0F172A);
  static const dotDivider = Color(0xFFBDCABA);

  static const barTint = Color(0xB3F8FAFC); // rgba(248,250,252,.7)

  // ── admin (web) — a deliberately different, blue language ──────────────
  static const adminAccent = Color(0xFF004AC6);
  static const adminSurface = Color(0xFFFFFFFF);
  static const adminRowHover = Color(0xFFF2F4F6);
  static const adminText = Color(0xFF434655);
  static const adminBorder = Color(0xFFC3C6D7);

  // ── status ────────────────────────────────────────────────────────────
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFDC2626);
  static const info = Color(0xFF0EA5E9);
  static const success = primaryGreen;
}

abstract final class AppRadius {
  /// Vendor / product cards.
  static const card = 32.0;
  static const sheet = 32.0;
  static const medium = 16.0;
  static const small = 8.0;

  /// Pills, chips, avatars and the search field.
  static const stadium = 9999.0;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const mediumBorder = BorderRadius.all(Radius.circular(medium));
  static const smallBorder = BorderRadius.all(Radius.circular(small));
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Horizontal padding for every customer screen.
  static const screenH = 24.0;
}

abstract final class AppSizes {
  static const categoryCircle = 80.0;
  static const cardImageHeight = 224.0;
  static const barBlur = 12.0;
  static const adminSidebarWidth = 239.0;
  static const adminActiveBar = 4.0;

  /// The admin dashboard is designed for desktop.
  static const adminMinWidth = 1024.0;
}

abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0D191C1D), blurRadius: 40, offset: Offset(0, 8)),
  ];

  static const promo = <BoxShadow>[
    BoxShadow(color: Color(0x0F191C1D), blurRadius: 32, offset: Offset(0, 8)),
  ];

  /// The active green pill in the bottom navigation bar.
  static const activePill = <BoxShadow>[
    BoxShadow(color: Color(0x3316A34A), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
  ];

  static const bottomBar = <BoxShadow>[
    BoxShadow(color: Color(0x0F191C1D), blurRadius: 40, offset: Offset(0, -8)),
  ];
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}
