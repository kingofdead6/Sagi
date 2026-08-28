import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/features/offers/domain/offer.dart';

/// The offers strip below the categories: wide artwork cards that scroll
/// sideways, peeking at the next one so the row reads as scrollable.
class PromoBannerCarousel extends StatelessWidget {
  const PromoBannerCarousel({required this.offers, super.key, this.onTap});

  final List<Offer> offers;
  final void Function(Offer offer)? onTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width * 0.74;

    return SizedBox(
      height: AppSizes.offerStrip,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        itemCount: offers.length,
        separatorBuilder: (_, __) => Gap.wMd,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return SizedBox(
            width: cardWidth,
            child: PromoBanner(offer: offer, onTap: () => onTap?.call(offer)),
          );
        },
      ),
    );
  }
}

/// One offer card. Artwork when the offer has an image, otherwise the brand
/// gradient with the offer type's icon.
class PromoBanner extends StatelessWidget {
  const PromoBanner({required this.offer, super.key, this.onTap});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mediumBorder,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.mediumBorder,
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: offer.image != null ? _artwork() : _gradient(),
      ),
    );
  }

  Widget _artwork() {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppImage(image: offer.image, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xB3000000), Colors.transparent],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                offer.title,
                style: AppText.cardTitle.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (offer.vendorName != null) ...[
                Gap.xs,
                Text(
                  offer.vendorName!,
                  style: AppText.meta.copyWith(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _gradient() {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.promoGradient),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    offer.title,
                    style: AppText.cardTitle.copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (offer.subtitle != null && offer.subtitle!.isNotEmpty) ...[
                    Gap.xs,
                    Text(
                      offer.subtitle!,
                      style: AppText.meta.copyWith(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (offer.vendorName != null) ...[
                    Gap.sm,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(AppRadius.stadium),
                      ),
                      child: Text(
                        offer.vendorName!,
                        style: AppText.badge.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Gap.wMd,
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                switch (offer.type) {
                  OfferType.freeDelivery => Icons.delivery_dining_rounded,
                  OfferType.percentage => Icons.percent_rounded,
                  OfferType.fixed => Icons.local_offer_rounded,
                  OfferType.bundle => Icons.inventory_2_rounded,
                },
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
