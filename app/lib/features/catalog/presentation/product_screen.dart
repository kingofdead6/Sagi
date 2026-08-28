import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/qty_stepper.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/vendors/presentation/vendors_controller.dart';

/// Figma nodes 2601:498 / 2601:542 — immersive hero, glass close button,
/// option groups that recompute the price live, then "إضافة إلى السلة".
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final Set<String> _selected = {};
  int _qty = 1;
  bool _initialised = false;
  bool _adding = false;

  /// Preselects the first value of every required single-choice group, so the
  /// CTA is usable immediately.
  void _seedDefaults(Product product) {
    if (_initialised) return;
    _initialised = true;
    for (final option in product.options) {
      if (option.isRequired && option.type.isSingle && option.values.isNotEmpty) {
        _selected.add(option.values.first.id);
      }
    }
  }

  void _toggle(ProductOption option, ProductOptionValue value) {
    setState(() {
      if (option.type.isSingle) {
        for (final v in option.values) {
          _selected.remove(v.id);
        }
        _selected.add(value.id);
      } else {
        _selected.contains(value.id) ? _selected.remove(value.id) : _selected.add(value.id);
      }
    });
  }

  bool _missingRequired(Product product) => product.options.any(
        (option) =>
            option.isRequired && !option.values.any((v) => _selected.contains(v.id)),
      );

  /// A local estimate for the button only — the server re-prices at checkout.
  Money _unitPrice(Product product) => product.options
      .expand((o) => o.values)
      .where((v) => _selected.contains(v.id))
      .fold(product.priceCentimes, (sum, v) => sum + v.priceDeltaCentimes);

  Future<void> _addToCart(Product product) async {
    final l10n = context.l10n;
    final vendorId = product.vendor;
    if (vendorId == null) return;

    final cart = ref.read(cartControllerProvider.notifier);
    final vendor = ref.read(vendorDetailProvider(vendorId)).valueOrNull;
    final vendorName = vendor?.name ?? '';

    // Single-vendor basket: adding from elsewhere asks before clearing.
    if (cart.conflictsWith(vendorId)) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          title: Text(l10n.cartClearTitle, style: AppText.cardTitle),
          content: Text(l10n.cartClearMessage, style: AppText.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: Text(l10n.cartClearConfirm),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      await cart.clear();
    }

    setState(() => _adding = true);
    await cart.add(
      product: product,
      vendorId: vendorId,
      vendorName: vendorName,
      qty: _qty,
      selectedValueIds: _selected.toList(),
    );

    if (!mounted) return;
    setState(() => _adding = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.productAdded),
          action: SnackBarAction(
            label: l10n.navCart,
            textColor: Colors.white,
            onPressed: () => context.push(Routes.cart),
          ),
        ),
      );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = ref.watch(productDetailProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: product.when(
        loading: () => ListView(
          children: const [
            AppSkeleton(height: 320),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton(height: 28, width: 200),
                  Gap.md,
                  AppSkeleton(height: 60),
                ],
              ),
            ),
          ],
        ),
        error: (error, _) => ErrorRetry(
          failure: error is Failure ? error : const Failure.unknown(),
          onRetry: () => ref.invalidate(productDetailProvider(widget.productId)),
        ),
        data: (data) {
          _seedDefaults(data);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: AppColors.surface,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppImage(
                        image: data.image,
                        fit: BoxFit.cover,
                        fallbackIcon: Icons.restaurant_rounded,
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              _GlassButton(
                                icon: Icons.close_rounded,
                                onTap: () => context.pop(),
                              ),
                              const Spacer(),
                              _GlassButton(
                                icon: Icons.shopping_bag_outlined,
                                onTap: () => context.push(Routes.cart),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(data.name, style: AppText.sectionTitle)),
                          Gap.wMd,
                          PriceText(
                            data.priceCentimes,
                            style: AppText.cardTitle,
                            color: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      if (data.description != null && data.description!.isNotEmpty) ...[
                        Gap.sm,
                        Text(data.description!, style: AppText.meta),
                      ],
                      Gap.xl,

                      for (final option in data.options) ...[
                        Row(
                          children: [
                            Text(option.name, style: AppText.cardTitle),
                            Gap.wSm,
                            if (option.isRequired)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.danger.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppRadius.stadium),
                                ),
                                child: Text(
                                  l10n.productRequiredOption,
                                  style: AppText.badge.copyWith(color: AppColors.danger),
                                ),
                              ),
                          ],
                        ),
                        Gap.xs,
                        Text(
                          option.type.isSingle ? l10n.productChooseOne : l10n.productChooseMany,
                          style: AppText.meta,
                        ),
                        Gap.sm,
                        for (final value in option.values)
                          _OptionRow(
                            option: option,
                            value: value,
                            isSelected: _selected.contains(value.id),
                            onTap: () => _toggle(option, value),
                          ),
                        Gap.xl,
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.productQuantity, style: AppText.cardTitle),
                          QtyStepper(
                            value: _qty,
                            onChanged: (value) => setState(() => _qty = value),
                          ),
                        ],
                      ),
                      Gap.xxl,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: product.maybeWhen(
        data: (data) {
          final blocked = !data.isAvailable || _missingRequired(data);
          return StickyBottomBar(
            child: PrimaryButton(
              label: data.isAvailable
                  ? '${l10n.productAddToCart} · ${(_unitPrice(data) * _qty).format()}'
                  : l10n.productUnavailable,
              isLoading: _adding,
              onPressed: blocked ? null : () => _addToCart(data),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final ProductOption option;
  final ProductOptionValue value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mediumBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              option.type.isSingle
                  ? (isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded)
                  : (isSelected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded),
              color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
            ),
            Gap.wMd,
            Expanded(child: Text(value.name, style: AppText.body)),
            if (value.priceDeltaCentimes.isPositive)
              PriceText(
                value.priceDeltaCentimes,
                style: AppText.metaStrong,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
