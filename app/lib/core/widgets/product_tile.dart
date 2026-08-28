import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/features/catalog/domain/product.dart';

/// A single menu row: text on the leading side, square image trailing.
class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, super.key, this.onTap, this.trailing});

  final Product product;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final unavailable = !product.isAvailable;

    return Opacity(
      opacity: unavailable ? 0.55 : 1,
      child: InkWell(
        onTap: unavailable ? null : onTap,
        borderRadius: AppRadius.mediumBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppText.bodyStrong,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.description != null && product.description!.isNotEmpty) ...[
                      Gap.xs,
                      Text(
                        product.description!,
                        style: AppText.meta,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    Gap.sm,
                    Row(
                      children: [
                        PriceText(product.priceCentimes, color: AppColors.primaryGreen),
                        if (unavailable) ...[
                          Gap.wSm,
                          Text(
                            context.l10n.productUnavailable,
                            style: AppText.badge.copyWith(color: AppColors.danger),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Gap.wLg,
              AppImage(
                image: product.image,
                width: 88,
                height: 88,
                radius: AppRadius.medium,
                fallbackIcon: Icons.restaurant_rounded,
                transformWidth: 200,
              ),
              if (trailing != null) ...[Gap.wSm, trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
