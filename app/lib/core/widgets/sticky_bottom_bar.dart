import 'package:flutter/material.dart';
import 'package:saji/app/theme/tokens.dart';

/// The floating action bar pinned to the bottom of the cart, product sheet and
/// checkout — same shadow and radius as the bottom navigation.
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding ??
              const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.lg,
                AppSpacing.screenH,
                AppSpacing.lg,
              ),
          child: child,
        ),
      ),
    );
  }
}
