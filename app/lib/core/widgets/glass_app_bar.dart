import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// The frosted top bar from the Figma home screen:
/// rgba(248,250,252,.7) over a 12px backdrop blur.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppSizes.barBlur, sigmaY: AppSizes.barBlur),
        child: ColoredBox(
          color: AppColors.barTint,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: AppSpacing.md)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (subtitle != null)
                          Text(subtitle!, style: AppText.meta, maxLines: 1),
                        if (title != null)
                          Text(
                            title!,
                            style: AppText.header,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  ...actions,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The home screen's "التوصيل إلى بئر العاتر" header with its pin.
class DeliverToBar extends StatelessWidget implements PreferredSizeWidget {
  const DeliverToBar({
    required this.label,
    required this.addressLine,
    super.key,
    this.onTap,
    this.trailing,
  });

  final String label;
  final String addressLine;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return GlassAppBar(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.location_on_rounded, color: AppColors.primaryGreen, size: 20),
      ),
      subtitle: label,
      title: addressLine,
      actions: [
        if (trailing != null) trailing!,
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.headerText),
          tooltip: label,
        ),
      ],
    );
  }
}
