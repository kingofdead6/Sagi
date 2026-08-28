import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

class BottomNavItem {
  const BottomNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// The blurred bottom bar with a 32px top radius; the active item sits in a
/// green pill carrying its own shadow.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
    this.badges = const {},
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Map<int, int> badges;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppSizes.barBlur, sigmaY: AppSizes.barBlur),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.barTint,
            boxShadow: AppShadows.bottomBar,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < items.length; i++)
                    _NavEntry(
                      item: items[i],
                      isActive: i == currentIndex,
                      badge: badges[i],
                      onTap: () => onTap(i),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavEntry extends StatelessWidget {
  const _NavEntry({
    required this.item,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  final BottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.stadium),
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.stadium),
            boxShadow: isActive ? AppShadows.activePill : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 22,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                  if (badge != null && badge! > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(AppRadius.stadium),
                        ),
                        child: Text(
                          '${badge! > 99 ? 99 : badge}',
                          style: AppText.badge.copyWith(
                            fontSize: 10,
                            color: isActive ? AppColors.primaryGreen : Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppText.navLabel.copyWith(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
