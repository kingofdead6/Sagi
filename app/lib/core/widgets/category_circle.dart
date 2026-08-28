import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// An 80×80 category circle. The icon set is keyed off `Category.iconKey` so
/// the server controls which categories exist without shipping images.
IconData categoryIcon(String key) => switch (key) {
      'fastfood' => Icons.lunch_dining_rounded,
      'fruits' => Icons.apple_rounded,
      'meat' => Icons.kebab_dining_rounded,
      'grocery' => Icons.local_grocery_store_rounded,
      'bakery' => Icons.bakery_dining_rounded,
      'sweets' => Icons.cake_rounded,
      'drinks' => Icons.local_cafe_rounded,
      'pharmacy' => Icons.medical_services_rounded,
      _ => Icons.category_rounded,
    };

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
                color: isActive ? AppColors.primaryGreen : AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: Icon(
                categoryIcon(iconKey),
                size: 32,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.meta.copyWith(
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primaryGreen : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
