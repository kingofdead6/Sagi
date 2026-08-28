import 'package:flutter/material.dart';

import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// Represents either a Material icon or a custom asset image.
class CategoryIcon {
  final IconData? icon;
  final String? image;

  const CategoryIcon.icon(this.icon) : image = null;

  const CategoryIcon.image(this.image) : icon = null;
}

/// Maps the server's category icon key to either a Material icon
/// or a custom asset image.
///
/// The server controls which category exists through [iconKey].
CategoryIcon categoryIcon(String key) => switch (key) {
      'fastfood' => const CategoryIcon.image('assets/Home/restaurant.png'),
      'restaurant' => const CategoryIcon.image('assets/Home/restaurant.png'),
      'grocery' => const CategoryIcon.image('assets/Home/Market.png'),
      'market' => const CategoryIcon.image('assets/Home/Market.png'),
      'fruits' => const CategoryIcon.image('assets/Home/Vegies.png'),
      'vegetables' => const CategoryIcon.image('assets/Home/Vegies.png'),
      'meat' => const CategoryIcon.image('assets/Home/Butcher.png'),
      'butcher' => const CategoryIcon.image('assets/Home/Butcher.png'),
      'bakery' => const CategoryIcon.image('assets/Home/bakery.png'),
      'sweets' => const CategoryIcon.image('assets/Home/Cakery.png'),
      'cakery' => const CategoryIcon.image('assets/Home/Cakery.png'),
      'drinks' => const CategoryIcon.icon(Icons.local_cafe_rounded),
      'pharmacy' => const CategoryIcon.icon(Icons.medical_services_rounded),
      _ => const CategoryIcon.icon(Icons.category_rounded),
    };

/// An 80×80 category circle.
///
/// Supports both Material icons and custom asset images.
class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    required this.label,
    required this.iconKey,
    super.key,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final String iconKey;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final category = categoryIcon(iconKey);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: SizedBox(
        width: AppSizes.categoryCircle + 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              width: AppSizes.categoryCircle,
              height: AppSizes.categoryCircle,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryGreen
                    : AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: category.icon != null
                  ? Center(
                      child: Icon(
                        category.icon,
                        size: 32,
                        color: isActive
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    )
                  // The illustrated artwork runs larger than the circle and
                  // sits toward its trailing edge.
                  : OverflowBox(
                      maxWidth: AppSizes.categoryCircle * 1.3,
                      maxHeight: AppSizes.categoryCircle * 1.3,
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10),
                        child: Image.asset(
                          category.image!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.meta.copyWith(
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
