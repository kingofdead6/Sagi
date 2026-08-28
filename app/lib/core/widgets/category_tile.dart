import 'package:flutter/material.dart';

import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/widgets/category_circle.dart';

/// The rounded-square category tile used on the home sheet:
/// a soft tinted swatch behind the icon, with the label underneath.
///
/// Supports both Material icons and custom asset images.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
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
      borderRadius: BorderRadius.circular(AppRadius.medium + 6),
      child: SizedBox(
        width: AppSizes.categoryTile,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              width: AppSizes.categoryTile,
              height: AppSizes.categoryTile,
              decoration: BoxDecoration(
                color: isActive ? null : AppColors.primaryGreenTint,
                gradient: isActive ? AppColors.promoGradient : null,
                borderRadius: BorderRadius.circular(
                  AppRadius.medium + 6,
                ),
                boxShadow: isActive ? AppShadows.promo : null,
              ),
              child: category.icon != null
                  ? Center(
                      child: Icon(
                        category.icon,
                        size: 34,
                        color: isActive
                            ? Colors.white
                            : AppColors.primaryGreenDeep,
                      ),
                    )
                  // The artwork is illustrated, so it overflows the swatch a
                  // little and sits toward the trailing edge.
                  : OverflowBox(
                      maxWidth: AppSizes.categoryTile * 1.3,
                      maxHeight: AppSizes.categoryTile * 1.3,
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
                fontWeight: FontWeight.w700,
                color: isActive
                    ? AppColors.primaryGreenDeep
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
