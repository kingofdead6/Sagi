import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/product_tile.dart';
import 'package:saji/core/widgets/search_pill.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/vendors/domain/vendor.dart';
import 'package:saji/features/vendors/presentation/vendors_controller.dart';

/// Figma nodes 2601:318 / 2601:413 — hero with gradient, in-menu search,
/// section chips that scroll-spy the list, and a closed-vendor state that
/// disables ordering.
class VendorScreen extends ConsumerStatefulWidget {
  const VendorScreen({required this.vendorId, super.key});

  final String vendorId;

  @override
  ConsumerState<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends ConsumerState<VendorScreen> {
  final _scrollController = ScrollController();
  final _sectionKeys = <String, GlobalKey>{};
  final _search = TextEditingController();

  String _query = '';
  String? _activeSection;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _search.dispose();
    super.dispose();
  }

  /// Scroll-spy: whichever section header is nearest the top wins the chip.
  void _onScroll() {
    String? nearest;
    var smallest = double.infinity;

    for (final entry in _sectionKeys.entries) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final offset = box.localToGlobal(Offset.zero).dy;
      if (offset < 220 && offset.abs() < smallest) {
        smallest = offset.abs();
        nearest = entry.key;
      }
    }

    if (nearest != null && nearest != _activeSection) {
      setState(() => _activeSection = nearest);
    }
  }

  void _jumpToSection(String sectionId) {
    final context = _sectionKeys[sectionId]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  List<MenuGroup> _filtered(List<MenuGroup> groups) {
    if (_query.trim().isEmpty) return groups;
    final needle = _query.trim().toLowerCase();
    return groups
        .map(
          (group) => MenuGroup(
            sectionId: group.sectionId,
            sectionName: group.sectionName,
            products: group.products
                .where((p) => p.name.toLowerCase().contains(needle))
                .toList(),
          ),
        )
        .where((group) => group.products.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vendor = ref.watch(vendorDetailProvider(widget.vendorId));
    final menu = ref.watch(vendorMenuProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: vendor.when(
        loading: () => const _VendorSkeleton(),
        error: (error, _) => Center(
          child: ErrorRetry(
            failure: error is Failure ? error : const Failure.unknown(),
            onRetry: () => ref.invalidate(vendorDetailProvider(widget.vendorId)),
          ),
        ),
        data: (data) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            _VendorHero(vendor: data),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!data.openNow)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.1),
                          borderRadius: AppRadius.mediumBorder,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_rounded, color: AppColors.danger),
                            Gap.wMd,
                            Expanded(
                              child: Text(
                                l10n.vendorClosedCta,
                                style: AppText.bodyStrong.copyWith(color: AppColors.danger),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SearchPill(
                      hint: l10n.vendorSearchHint,
                      controller: _search,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ],
                ),
              ),
            ),
            ...menu.when(
              loading: () => [
                const SliverToBoxAdapter(child: AppSkeletonList(itemHeight: 96, count: 5)),
              ],
              error: (error, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorRetry(
                    failure: error is Failure ? error : const Failure.unknown(),
                    onRetry: () => ref.invalidate(vendorMenuProvider(widget.vendorId)),
                  ),
                ),
              ],
              data: (groups) {
                final visible = _filtered(groups);
                if (visible.isEmpty) {
                  return [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        title: _query.isEmpty ? l10n.vendorEmptyMenu : l10n.emptySearch,
                        icon: Icons.restaurant_menu_rounded,
                      ),
                    ),
                  ];
                }

                for (final group in visible) {
                  _sectionKeys.putIfAbsent(group.sectionId, GlobalKey.new);
                }

                return [
                  if (visible.length > 1)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                          itemCount: visible.length,
                          separatorBuilder: (_, __) => Gap.wSm,
                          itemBuilder: (context, index) {
                            final group = visible[index];
                            final isActive = _activeSection == group.sectionId ||
                                (_activeSection == null && index == 0);
                            return _SectionChip(
                              label: group.sectionName,
                              isActive: isActive,
                              onTap: () => _jumpToSection(group.sectionId),
                            );
                          },
                        ),
                      ),
                    ),
                  for (final group in visible)
                    SliverToBoxAdapter(
                      child: Padding(
                        key: _sectionKeys[group.sectionId],
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenH,
                          AppSpacing.lg,
                          AppSpacing.screenH,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(group.sectionName, style: AppText.sectionTitle),
                            for (final product in group.products)
                              ProductTile(
                                product: product,
                                onTap: data.openNow
                                    ? () => context.push(Routes.productPath(product.id))
                                    : null,
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorHero extends StatelessWidget {
  const _VendorHero({required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: _GlassIconButton(
          icon: Icons.arrow_forward_rounded,
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(image: vendor.cover ?? vendor.logo, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            PositionedDirectional(
              start: AppSpacing.screenH,
              end: AppSpacing.screenH,
              bottom: AppSpacing.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vendor.name,
                    style: AppText.sectionTitle.copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap.xs,
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (vendor.hasRating)
                        _HeroMeta(
                          icon: Icons.star_rounded,
                          label: '${vendor.rating.toStringAsFixed(1)} '
                              '${l10n.vendorRatings(vendor.ratingCount)}',
                        ),
                      _HeroMeta(
                        icon: Icons.schedule_rounded,
                        label: l10n.vendorMinutes(vendor.eta),
                      ),
                      _HeroMeta(
                        icon: Icons.delivery_dining_rounded,
                        label: vendor.deliveryFeeCentimes.format(),
                      ),
                      if (vendor.minOrderCentimes.isPositive)
                        _HeroMeta(
                          icon: Icons.shopping_basket_rounded,
                          label: l10n.vendorMinOrder(vendor.minOrderCentimes.format()),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(label, style: AppText.meta.copyWith(color: Colors.white)),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.stadium),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          boxShadow: isActive ? AppShadows.activePill : AppShadows.card,
        ),
        child: Text(
          label,
          style: AppText.metaStrong.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _VendorSkeleton extends StatelessWidget {
  const _VendorSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        AppSkeleton(height: 260),
        Padding(
          padding: EdgeInsets.all(AppSpacing.screenH),
          child: AppSkeleton(height: 56, radius: AppRadius.stadium),
        ),
        AppSkeletonList(itemHeight: 96, count: 5),
      ],
    );
  }
}
