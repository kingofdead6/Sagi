import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/features/offers/domain/offer.dart';

/// The home hero: the gradient runs behind the status bar, carries the address
/// picker and the search row, and ends in a full-bleed banner carousel that the
/// white content sheet then rides up over.
class HomeHero extends StatefulWidget {
  const HomeHero({
    required this.addressLabel,
    required this.searchHint,
    required this.offers,
    super.key,
    this.onAddressTap,
    this.onSearchTap,
    this.onFavouritesTap,
    this.onOfferTap,
    this.isLoading = false,
  });

  final String addressLabel;
  final String searchHint;
  final List<Offer> offers;
  final VoidCallback? onAddressTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFavouritesTap;
  final void Function(Offer offer)? onOfferTap;
  final bool isLoading;

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    // The offer artwork fills the whole hero, so the chrome that floats over it
    // has to reserve its own height: status bar, address row, then the search.
    final chromeHeight = topInset + AppSpacing.sm + 44 + AppSpacing.md + 56;

    return SizedBox(
      height: chromeHeight + AppSizes.heroBanner,
      child: Stack(
        children: [
          // The gradient is the backdrop the artwork sits on, and it still
          // shows through wherever an offer has no image of its own.
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: widget.offers.isEmpty
                  ? _HeroBannerPlaceholder(isLoading: widget.isLoading)
                  : PageView.builder(
                      controller: _controller,
                      itemCount: widget.offers.length,
                      onPageChanged: (index) => setState(() => _index = index),
                      itemBuilder: (context, index) => _HeroBanner(
                        offer: widget.offers[index],
                        // The title clears the search row floating above it.
                        topInset: chromeHeight,
                        onTap: () => widget.onOfferTap?.call(widget.offers[index]),
                      ),
                    ),
            ),
          ),

          // A scrim under the chrome so the address and search stay legible
          // whatever the artwork behind them happens to be.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: chromeHeight + AppSpacing.xl,
            child: const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x73000000), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: topInset + AppSpacing.sm,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                  child: _AddressPicker(
                    label: widget.addressLabel,
                    onTap: widget.onAddressTap,
                  ),
                ),
                Gap.md,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HeroSearchField(
                          hint: widget.searchHint,
                          onTap: widget.onSearchTap,
                        ),
                      ),
                      Gap.wMd,
                      _HeroCircleButton(
                        icon: Icons.favorite_rounded,
                        onTap: widget.onFavouritesTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (widget.offers.length > 1)
            Positioned(
              // Clear of the sheet that rides up over the hero's bottom edge.
              bottom: AppSizes.heroSheetOverlap + AppSpacing.md,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.offers.length; i++)
                    AnimatedContainer(
                      duration: AppDurations.fast,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _index ? 20 : 7,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: i == _index ? 0.95 : 0.4),
                        borderRadius: BorderRadius.circular(AppRadius.stadium),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The commune name plus its chevron, in white, on the gradient.
class _AddressPicker extends StatelessWidget {
  const _AddressPicker({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.stadium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: AppText.sectionTitle.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

/// The white stadium search field that floats on the gradient.
class _HeroSearchField extends StatelessWidget {
  const _HeroSearchField({required this.hint, this.onTap});

  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.stadium),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.stadium),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  hint,
                  style: AppText.placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.card,
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 24),
      ),
    );
  }
}

/// One full-bleed banner filling the entire hero. An offer image covers the
/// frame; without one we fall back to the promo gradient so the hero never
/// shows a hole.
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.offer, required this.topInset, this.onTap});

  final Offer offer;

  /// How much of the top belongs to the floating address and search chrome.
  final double topInset;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (offer.image != null)
            AppImage(
              image: offer.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              transformWidth: 1080,
            )
          else
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.promoGradient),
            ),
          // A scrim on the text side keeps the title readable over any artwork.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerEnd,
                end: AlignmentDirectional.centerStart,
                colors: [Colors.transparent, Color(0x99000000)],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              topInset,
              AppSpacing.xl,
              AppSpacing.xl + AppSizes.heroSheetOverlap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // The headline sits low on the artwork, as in the reference.
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    offer.title,
                    style: AppText.sectionTitle.copyWith(color: Colors.white, fontSize: 28),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (offer.subtitle != null && offer.subtitle!.isNotEmpty) ...[
                  Gap.sm,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.highlight,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      offer.subtitle!,
                      style: AppText.badge.copyWith(color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// While offers load - and when there are none - the hero keeps its shape.
class _HeroBannerPlaceholder extends StatelessWidget {
  const _HeroBannerPlaceholder({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Icon(
                Icons.local_offer_rounded,
                color: Colors.white.withValues(alpha: 0.55),
                size: 40,
              ),
      ),
    );
  }
}
