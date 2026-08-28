import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/features/offers/domain/offer.dart';

/// The deep-green promo banner from the home screen, as a swipeable carousel
/// when more than one offer is flagged `showOnHome`.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({required this.offers, super.key, this.onTap});

  final List<Offer> offers;
  final void Function(Offer offer)? onTap;

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  late final PageController _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.offers.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: _PromoBanner(offer: offer, onTap: () => widget.onTap?.call(offer)),
              );
            },
          ),
        ),
        if (widget.offers.length > 1) ...[
          Gap.md,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.offers.length; i++)
                AnimatedContainer(
                  duration: AppDurations.fast,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _index ? AppColors.primaryGreen : AppColors.dotDivider,
                    borderRadius: BorderRadius.circular(AppRadius.stadium),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.offer, this.onTap});

  final Offer offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardBorder,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryGreenDeep,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.promo,
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
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
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadius.stadium),
                      ),
                      child: Text(
                        offer.vendorName!,
                        style: AppText.badge.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Gap.wLg,
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
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
                size: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
