import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/search_pill.dart';
import 'package:saji/core/widgets/vendor_card.dart';
import 'package:saji/features/home/presentation/home_controller.dart';
import 'package:saji/features/vendors/data/catalog_repository.dart';
import 'package:saji/features/vendors/presentation/vendors_controller.dart';

/// The browse/search screen: search pill, filter chips, sort sheet, results.
class VendorsScreen extends ConsumerStatefulWidget {
  const VendorsScreen({super.key, this.categoryId, this.initialSearch});

  final String? categoryId;
  final String? initialSearch;

  @override
  ConsumerState<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends ConsumerState<VendorsScreen> {
  late final TextEditingController _search =
      TextEditingController(text: widget.initialSearch ?? '');

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null || widget.initialSearch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(vendorFiltersProvider.notifier).state = VendorFilters(
          categoryId: widget.categoryId,
          search: widget.initialSearch,
        );
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = ref.watch(vendorFiltersProvider);
    final vendors = ref.watch(vendorListProvider);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final offerVendorIds = ref.watch(offerVendorIdsProvider);

    void update(VendorFilters next) =>
        ref.read(vendorFiltersProvider.notifier).state = next;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.vendorsTitle, style: AppText.header),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: SearchPill(
              hint: l10n.homeSearchHint,
              controller: _search,
              onSubmitted: (value) =>
                  update(filters.copyWith(search: value, clearSearch: value.isEmpty)),
              trailing: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _search.clear();
                        update(filters.copyWith(clearSearch: true));
                      },
                    ),
            ),
          ),
          Gap.md,
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              children: [
                _FilterChip(
                  label: l10n.filterAll,
                  isActive: filters.categoryId == null,
                  onTap: () => update(filters.copyWith(clearCategory: true)),
                ),
                for (final category in categories) ...[
                  Gap.wSm,
                  _FilterChip(
                    label: category.nameAr,
                    isActive: filters.categoryId == category.id,
                    onTap: () => update(
                      filters.categoryId == category.id
                          ? filters.copyWith(clearCategory: true)
                          : filters.copyWith(categoryId: category.id),
                    ),
                  ),
                ],
                Gap.wSm,
                _FilterChip(
                  label: l10n.filterOpenNow,
                  isActive: filters.openNow,
                  icon: Icons.schedule_rounded,
                  onTap: () => update(filters.copyWith(openNow: !filters.openNow)),
                ),
                Gap.wSm,
                _FilterChip(
                  label: l10n.filterHasOffer,
                  isActive: filters.hasOffer,
                  icon: Icons.local_offer_rounded,
                  onTap: () => update(filters.copyWith(hasOffer: !filters.hasOffer)),
                ),
                Gap.wSm,
                _FilterChip(
                  label: switch (filters.sort) {
                    'nearest' => l10n.filterSortNearest,
                    'fastest' => l10n.filterSortFastest,
                    'rating' => l10n.filterSortRating,
                    _ => l10n.filterSortFeatured,
                  },
                  isActive: true,
                  icon: Icons.swap_vert_rounded,
                  onTap: () => _showSortSheet(context, filters, update),
                ),
              ],
            ),
          ),
          Gap.md,
          Expanded(
            child: vendors.when(
              loading: () => const AppSkeletonList(itemHeight: 320, count: 4),
              error: (error, _) => ErrorRetry(
                failure: error is Failure ? error : const Failure.unknown(),
                onRetry: () => ref.invalidate(vendorListProvider),
              ),
              data: (page) {
                if (page.isEmpty) {
                  return EmptyState(
                    title: l10n.emptySearch,
                    icon: Icons.search_off_rounded,
                    actionLabel: l10n.commonReset,
                    onAction: () {
                      _search.clear();
                      update(const VendorFilters());
                    },
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () async => ref.invalidate(vendorListProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenH,
                      0,
                      AppSpacing.screenH,
                      AppSpacing.xxl,
                    ),
                    itemCount: page.items.length,
                    separatorBuilder: (_, __) => Gap.lg,
                    itemBuilder: (context, index) {
                      final vendor = page.items[index];
                      return VendorCard(
                        vendor: vendor,
                        hasOffer: offerVendorIds.contains(vendor.id),
                        onTap: () => context.push(Routes.vendorPath(vendor.id)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSortSheet(
    BuildContext context,
    VendorFilters filters,
    void Function(VendorFilters) update,
  ) async {
    final l10n = context.l10n;
    final options = {
      'featured': l10n.filterSortFeatured,
      'nearest': l10n.filterSortNearest,
      'fastest': l10n.filterSortFastest,
      'rating': l10n.filterSortRating,
    };

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap.lg,
            Text(l10n.filterSort, style: AppText.cardTitle),
            Gap.md,
            for (final entry in options.entries)
              ListTile(
                title: Text(entry.value, style: AppText.body),
                trailing: filters.sort == entry.key
                    ? const Icon(Icons.check_rounded, color: AppColors.primaryGreen)
                    : null,
                onTap: () {
                  update(filters.copyWith(sort: entry.key));
                  Navigator.of(context).pop();
                },
              ),
            Gap.lg,
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.stadium),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          boxShadow: isActive ? AppShadows.activePill : AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isActive ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppText.metaStrong.copyWith(
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
