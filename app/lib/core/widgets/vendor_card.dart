import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// The home-screen vendor card: 224px image, rating chip, offer badge, name,
/// then the ETA / distance / delivery-fee meta row.
class VendorCard extends StatelessWidget {
  const VendorCard({
    required this.vendor,
    super.key,
    this.onTap,
    this.hasOffer = false,
    this.offerLabel,
  });

  final Vendor vendor;
  final VoidCallback? onTap;
  final bool hasOffer;
  final String? offerLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final closed = !vendor.openNow;

    return Semantics(
      button: true,
      label: vendor.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardBorder,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardBorder,
            boxShadow: AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AppImage(
                    image: vendor.cover ?? vendor.logo,
                    height: AppSizes.cardImageHeight,
                    width: double.infinity,
                  ),
                  if (closed)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.45),
                        child: Center(
                          child: Text(
                            l10n.vendorClosed,
                            style: AppText.cardTitle.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  if (vendor.hasRating)
                    PositionedDirectional(
                      top: AppSpacing.md,
                      start: AppSpacing.md,
                      child: _Chip(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.highlight,
                        label: vendor.rating.toStringAsFixed(1),
                      ),
                    ),
                  if (hasOffer)
                    PositionedDirectional(
                      top: AppSpacing.md,
                      end: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(AppRadius.stadium),
                          boxShadow: AppShadows.accent,
                        ),
                        child: Text(
                          offerLabel ?? l10n.vendorSpecialOffers,
                          style: AppText.badge.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      style: AppText.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap.xs,
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(l10n.vendorMinutes(vendor.eta), style: AppText.meta),
                        const _Dot(),
                        if (vendor.distanceKm != null) ...[
                          Text(
                            l10n.vendorKm(vendor.distanceKm!.toStringAsFixed(1)),
                            style: AppText.meta,
                          ),
                          const _Dot(),
                        ],
                        Text(
                          l10n.vendorDeliveryFee(vendor.deliveryFeeCentimes.format()),
                          style: AppText.meta,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(color: AppColors.dotDivider, shape: BoxShape.circle),
      );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.iconColor});

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.stadium),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(label, style: AppText.badge),
        ],
      ),
    );
  }
}
