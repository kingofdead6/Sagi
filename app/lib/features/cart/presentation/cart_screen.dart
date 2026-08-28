import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/qty_stepper.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/features/cart/domain/cart.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';

/// Figma node 2601:579 — item cards with a qty stepper and delete, then a
/// sticky total that leads into checkout.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cart = ref.watch(cartControllerProvider);
    final controller = ref.read(cartControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.cartTitle, style: AppText.header),
        // The cart FAB is reachable from every tab, so guarantee a way back
        // even when this was opened without anything beneath it.
        leading: context.canPop()
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(Routes.home),
              ),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              tooltip: l10n.cartClearConfirm,
              onPressed: () => _confirmClear(context, controller),
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyState(
              title: l10n.cartEmpty,
              icon: Icons.shopping_bag_outlined,
              actionLabel: l10n.cartEmptyAction,
              onAction: () => context.go(Routes.home),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.lg,
                AppSpacing.screenH,
                AppSpacing.xxl,
              ),
              children: [
                if (cart.vendorName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_rounded,
                            size: 18, color: AppColors.primaryGreen),
                        Gap.wSm,
                        Text(cart.vendorName!, style: AppText.bodyStrong),
                      ],
                    ),
                  ),
                for (final line in cart.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _CartLineCard(
                      line: line,
                      onQtyChanged: (qty) => controller.setQty(line.key, qty),
                      onRemove: () => controller.remove(line.key),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : StickyBottomBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.cartTotal, style: AppText.bodyStrong),
                      PriceText(
                        cart.estimatedSubtotal,
                        style: AppText.cardTitle,
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                  Gap.md,
                  PrimaryButton(
                    label: l10n.cartGoToCart,
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => context.push(Routes.checkout),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, CartController controller) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.cartClearConfirm, style: AppText.cardTitle),
        content: Text(l10n.cartClearMessage, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await controller.clear();
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({
    required this.line,
    required this.onQtyChanged,
    required this.onRemove,
  });

  final CartLine line;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            image: line.product.image,
            width: 72,
            height: 72,
            radius: AppRadius.medium,
            fallbackIcon: Icons.restaurant_rounded,
            transformWidth: 200,
          ),
          Gap.wLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        line.product.name,
                        style: AppText.bodyStrong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                      tooltip: context.l10n.cartRemoveItem,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
                if (line.optionsLabel.isNotEmpty)
                  Text(
                    line.optionsLabel,
                    style: AppText.meta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                Gap.sm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceText(line.lineTotal, color: AppColors.primaryGreen),
                    QtyStepper(value: line.qty, onChanged: onQtyChanged, compact: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
