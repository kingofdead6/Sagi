import 'package:flutter/widgets.dart';
import 'package:saji/app/theme/tokens.dart';

/// Vertical and horizontal gaps, so feature code never writes a raw SizedBox.
abstract final class Gap {
  static const xs = SizedBox(height: AppSpacing.xs);
  static const sm = SizedBox(height: AppSpacing.sm);
  static const md = SizedBox(height: AppSpacing.md);
  static const lg = SizedBox(height: AppSpacing.lg);
  static const xl = SizedBox(height: AppSpacing.xl);
  static const xxl = SizedBox(height: AppSpacing.xxl);

  static const wXs = SizedBox(width: AppSpacing.xs);
  static const wSm = SizedBox(width: AppSpacing.sm);
  static const wMd = SizedBox(width: AppSpacing.md);
  static const wLg = SizedBox(width: AppSpacing.lg);
  static const wXl = SizedBox(width: AppSpacing.xl);

  static SizedBox h(double value) => SizedBox(height: value);
  static SizedBox w(double value) => SizedBox(width: value);
}

/// Standard horizontal padding for a customer screen.
const kScreenPadding = EdgeInsets.symmetric(horizontal: AppSpacing.screenH);
