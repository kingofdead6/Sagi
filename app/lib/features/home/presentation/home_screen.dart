import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/category_tile.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/section_header.dart';
import 'package:saji/core/widgets/vendor_card.dart';
import 'package:saji/features/home/presentation/home_controller.dart';
import 'package:saji/features/home/presentation/home_hero.dart';
import 'package:saji/features/home/presentation/promo_banner.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

/// The home screen: a gradient hero carrying the address, search and the banner
/// carousel, then a white sheet that rides up over it holding the categories,
/// the offers strip and the nearby vendors.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final address = ref.watch(defaultAddressProvider);
    final categories = ref.watch(categoriesProvider);
    final offers = ref.watch(homeOffersProvider);
    final vendors = ref.watch(homeVendorsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final offerVendorIds = ref.watch(offerVendorIdsProvider);

    final offerItems = offers.valueOrNull ?? const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref
            ..invalidate(categoriesProvider)
            ..invalidate(homeOffersProvider)
            ..invalidate(homeVendorsProvider);
          await ref.read(homeVendorsProvider.future).catchError((_) => throw const Failure.network());
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            HomeHero(
              addressLabel: address?.commune ?? l10n.locationTitle,
              searchHint: l10n.homeSearchHint,
              offers: offerItems,
              isLoading: offers.isLoading,
              onAddressTap: () => context.push(Routes.addresses),
              onSearchTap: () => context.push(Routes.vendors),
              onFavouritesTap: () => context.push(Routes.vendors),
              onOfferTap: (offer) => offer.vendor != null
                  ? context.push(Routes.vendorPath(offer.vendor!))
                  : context.push(Routes.vendors),
            ),

            // The sheet overlaps the hero, so it is pulled up by the same
            // amount the hero left free at its bottom.
            Transform.translate(
              offset: const Offset(0, -AppSizes.heroSheetOverlap),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
                  boxShadow: AppShadows.sheet,
                ),
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: Column(
                  children: [
                    SizedBox(
                      // Extra headroom: the artwork spills past its swatch.
                      height: AppSizes.categoryTile + 56,
                      child: categories.when(
                        loading: () => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                          itemCount: 5,
                          separatorBuilder: (_, __) => Gap.wXl,
                          itemBuilder: (_, __) => const AppSkeleton(
                            width: AppSizes.categoryTile,
                            height: AppSizes.categoryTile,
                            radius: AppRadius.medium + 6,
                          ),
                        ),
                        error: (error, _) => ErrorRetry(
                          failure: error is Failure ? error : const Failure.unknown(),
                          compact: true,
                          onRetry: () => ref.invalidate(categoriesProvider),
                        ),
                        data: (items) => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => Gap.wXl,
                          itemBuilder: (_, index) {
                            final category = items[index];
                            final isActive = selectedCategory == category.id;
                            return CategoryTile(
                              label: category.nameAr,
                              iconKey: category.iconKey,
                              isActive: isActive,
                              // Tapping the active category clears the filter.
                              onTap: () => ref.read(selectedCategoryProvider.notifier).state =
                                  isActive ? null : category.id,
                            );
                          },
                        ),
                      ),
                    ),
                    Gap.xl,

                    if (offerItems.isNotEmpty) ...[
                      SectionHeader(l10n.homeOffers),
                      Gap.md,
                      PromoBannerCarousel(
                        offers: offerItems,
                        onTap: (offer) => offer.vendor != null
                            ? context.push(Routes.vendorPath(offer.vendor!))
                            : context.push(Routes.vendors),
                      ),
                      Gap.xl,
                    ],

                    SectionHeader(
                      l10n.homePopularNearby,
                      onSeeAll: () => context.push(
                        selectedCategory == null
                            ? Routes.vendors
                            : '${Routes.vendors}?category=$selectedCategory',
                      ),
                    ),
                    Gap.md,

                    vendors.when(
                      loading: () => const AppSkeletonList(itemHeight: 320),
                      error: (error, _) => SizedBox(
                        height: 280,
                        child: ErrorRetry(
                          failure: error is Failure ? error : const Failure.unknown(),
                          onRetry: () => ref.invalidate(homeVendorsProvider),
                        ),
                      ),
                      data: (page) {
                        if (page.isEmpty) {
                          return SizedBox(
                            height: 280,
                            child: EmptyState(
                              title: l10n.homeNoVendors,
                              icon: Icons.storefront_outlined,
                              actionLabel: l10n.commonRefresh,
                              onAction: () => ref.invalidate(homeVendorsProvider),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            for (final vendor in page.items)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.screenH,
                                  0,
                                  AppSpacing.screenH,
                                  AppSpacing.lg,
                                ),
                                child: VendorCard(
                                  vendor: vendor,
                                  hasOffer: offerVendorIds.contains(vendor.id),
                                  onTap: () => context.push(Routes.vendorPath(vendor.id)),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
