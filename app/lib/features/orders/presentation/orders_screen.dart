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
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/cart/domain/cart.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/presentation/orders_controller.dart';

/// Active orders and history in two tabs, kept live over sockets.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final orders = ref.watch(myOrdersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(l10n.ordersTitle, style: AppText.header),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryGreen,
            labelStyle: AppText.bodyStrong,
            tabs: [Tab(text: l10n.ordersActive), Tab(text: l10n.ordersHistory)],
          ),
        ),
        body: orders.when(
          loading: () => const AppSkeletonList(itemHeight: 150, count: 4),
          error: (error, _) => ErrorRetry(
            failure: error is Failure ? error : const Failure.unknown(),
            onRetry: () => ref.invalidate(myOrdersProvider),
          ),
          data: (page) {
            final active = page.items.where((o) => o.status.isActive).toList();
            final history = page.items.where((o) => o.status.isTerminal).toList();

            return TabBarView(
              children: [
                _OrderList(
                  orders: active,
                  emptyTitle: l10n.ordersEmpty,
                  emptyAction: l10n.ordersEmptyAction,
                  onEmptyAction: () => context.go(Routes.home),
                  onRefresh: () async => ref.invalidate(myOrdersProvider),
                ),
                _OrderList(
                  orders: history,
                  emptyTitle: l10n.ordersEmpty,
                  emptyAction: l10n.ordersEmptyAction,
                  onEmptyAction: () => context.go(Routes.home),
                  onRefresh: () async => ref.invalidate(myOrdersProvider),
                  showReorder: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderList extends ConsumerWidget {
  const _OrderList({
    required this.orders,
    required this.emptyTitle,
    required this.emptyAction,
    required this.onEmptyAction,
    required this.onRefresh,
    this.showReorder = false,
  });

  final List<AppOrder> orders;
  final String emptyTitle;
  final String emptyAction;
  final VoidCallback onEmptyAction;
  final Future<void> Function() onRefresh;
  final bool showReorder;

  /// Rebuilds a basket from a past order so the user can reorder in one tap.
  Future<void> _reorder(BuildContext context, WidgetRef ref, AppOrder order) async {
    final vendorId = order.vendor?.id;
    if (vendorId == null) return;
    await ref.read(cartControllerProvider.notifier).replaceWith(
          Cart(vendorId: vendorId, vendorName: order.vendor?.name),
        );
    if (context.mounted) await context.push(Routes.vendorPath(vendorId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return EmptyState(
        title: emptyTitle,
        icon: Icons.receipt_long_outlined,
        actionLabel: emptyAction,
        onAction: onEmptyAction,
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          120,
        ),
        itemCount: orders.length,
        separatorBuilder: (_, __) => Gap.md,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(
            order: order,
            onTap: () => context.push(Routes.orderDetailPath(order.id)),
            onReorder: showReorder ? () => _reorder(context, ref, order) : null,
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap, this.onReorder});

  final AppOrder order;
  final VoidCallback onTap;
  final VoidCallback? onReorder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardBorder,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.vendor?.name ?? order.code,
                    style: AppText.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusChip(order.status, isLate: order.isLate, dense: true),
              ],
            ),
            Gap.xs,
            Text('${order.code} · ${l10n.cartItemCount(order.itemCount)}', style: AppText.meta),
            Gap.md,
            Row(
              children: [
                PriceText(order.totalCentimes, color: AppColors.primaryGreen),
                const Spacer(),
                if (onReorder != null)
                  TextButton.icon(
                    onPressed: onReorder,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: Text(l10n.ordersReorder),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      textStyle: AppText.metaStrong,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
