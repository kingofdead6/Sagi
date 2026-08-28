import 'package:flutter/material.dart';

/// Design tokens extracted from the Saji Figma file
/// (`cnVxqadfDEVLtRRXCeye7I`). Feature code must never hard-code a hex value —
/// every colour, radius and shadow in the app comes from here.
abstract final class AppColors {
  // ── customer (mobile) ──────────────────────────────────────────────────
  // The green identity, dialled up: a vivid emerald that keeps its punch on
  // white, with a lime-leaning tint and a deep shade for gradients.
  static const primaryGreen = Color(0xFF00C853);
  static const primaryGreenDeep = Color(0xFF00873D);
  static const primaryGreenBright = Color(0xFF3DDC6B);
  static const primaryGreenTint = Color(0xFFE3FBEC);

  /// A warm citrus accent for offers, prices and "hot" badges.
  static const accent = Color(0xFFFF6B2C);
  static const accentSoft = Color(0xFFFFE9DE);

  /// Sunny highlight used on ratings and discount flashes.
  static const highlight = Color(0xFFFFC531);

  static const background = Color(0xFFF4FBF6);
  static const surface = Color(0xFFFFFFFF);
  static const searchFill = Color(0xFFEDF3EF);

  static const textPrimary = Color(0xFF0E1A12);
  static const textSecondary = Color(0xFF41564A);
  static const textPlaceholder = Color(0x9941564A); // rgba(65,86,74,.6)
  static const textMuted = Color(0xFF8CA398);
  static const headerText = Color(0xFF08130C);
  static const dotDivider = Color(0xFFB6D3C2);

  static const barTint = Color(0xCCF4FBF6); // rgba(244,251,246,.8)

  /// The home hero: a lively emerald sweep behind the header and search.
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E066), Color(0xFF00C853), Color(0xFF00A344)],
  );

  /// Promo banners and any surface that wants the brand at full volume.
  static const promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF00873D)],
  );

  /// The citrus counterpart, for offer strips that sit next to the green.
  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A3D), Color(0xFFFF5722)],
  );

  // ── admin (web) — a deliberately different, blue language ──────────────
  static const adminAccent = Color(0xFF1657FF);
  static const adminSurface = Color(0xFFFFFFFF);
  static const adminRowHover = Color(0xFFF1F5FB);
  static const adminText = Color(0xFF3B4256);
  static const adminBorder = Color(0xFFC9D2E6);

  // ── status ────────────────────────────────────────────────────────────
  static const warning = Color(0xFFFFB020);
  static const danger = Color(0xFFFF3B47);
  static const info = Color(0xFF12B7F5);
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

  /// The home hero: how much artwork shows below the floating address and
  /// search chrome, and how far the white sheet rides up over its bottom edge.
  static const heroBanner = 268.0;
  static const heroSheetOverlap = 28.0;
  static const categoryTile = 76.0;
  static const offerStrip = 168.0;
  static const adminSidebarWidth = 239.0;
  static const adminActiveBar = 4.0;

  /// The admin dashboard is designed for desktop.
  static const adminMinWidth = 1024.0;
}

abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x140E1A12), blurRadius: 28, offset: Offset(0, 10)),
  ];

  static const promo = <BoxShadow>[
    BoxShadow(color: Color(0x3300C853), blurRadius: 30, offset: Offset(0, 14), spreadRadius: -6),
  ];

  /// The citrus twin of [promo], for accent-coloured surfaces.
  static const accent = <BoxShadow>[
    BoxShadow(color: Color(0x33FF6B2C), blurRadius: 30, offset: Offset(0, 14), spreadRadius: -6),
  ];

  /// The white sheet that rides up over the home hero.
  static const sheet = <BoxShadow>[
    BoxShadow(color: Color(0x1A0E1A12), blurRadius: 32, offset: Offset(0, -10)),
  ];

  /// The active green pill in the bottom navigation bar.
  static const activePill = <BoxShadow>[
    BoxShadow(color: Color(0x5900C853), blurRadius: 18, offset: Offset(0, 10), spreadRadius: -4),
  ];

  static const bottomBar = <BoxShadow>[
    BoxShadow(color: Color(0x1F0E1A12), blurRadius: 40, offset: Offset(0, -8)),
  ];
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}
