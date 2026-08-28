import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/category_circle.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/glass_app_bar.dart';
import 'package:saji/core/widgets/search_pill.dart';
import 'package:saji/core/widgets/section_header.dart';
import 'package:saji/core/widgets/vendor_card.dart';
import 'package:saji/features/home/presentation/home_controller.dart';
import 'package:saji/features/home/presentation/promo_banner.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

/// Figma node 2601:157 — glass header, search pill, categories, promo banner,
/// then the nearby vendors list.
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

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: DeliverToBar(
        label: l10n.homeDeliverTo,
        addressLine: address?.commune ?? l10n.locationTitle,
        onTap: () => context.push(Routes.addresses),
      ),
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
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + kToolbarHeight + AppSpacing.lg,
            bottom: 120,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: SearchPill(
                hint: l10n.homeSearchHint,
                readOnly: true,
                onTap: () => context.push(Routes.vendors),
              ),
            ),
            Gap.xl,

            SectionHeader(l10n.homeCategories),
            Gap.md,
            SizedBox(
              height: AppSizes.categoryCircle + 44,
              child: categories.when(
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                  itemCount: 5,
                  separatorBuilder: (_, __) => Gap.wMd,
                  itemBuilder: (_, __) => const AppSkeleton.circle(),
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
                  separatorBuilder: (_, __) => Gap.wMd,
                  itemBuilder: (_, index) {
                    final category = items[index];
                    final isActive = selectedCategory == category.id;
                    return CategoryCircle(
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

            offers.maybeWhen(
              data: (items) => items.isEmpty
                  ? const SizedBox.shrink()
                  : PromoBannerCarousel(
                      offers: items,
                      onTap: (offer) => offer.vendor != null
                          ? context.push(Routes.vendorPath(offer.vendor!))
                          : context.push(Routes.vendors),
                    ),
              orElse: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                child: AppSkeleton(height: 140, radius: AppRadius.card),
              ),
            ),
            Gap.xl,

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
    );
  }
}
