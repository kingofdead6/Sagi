import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/admin/presentation/pages/csv_download.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/domain/order_status.dart';

/// The live orders table. Rows carry their status colour and a `Late Delivery`
/// chip once the order passes the configured threshold.
class AdminOrdersBoard extends ConsumerWidget {
  const AdminOrdersBoard({super.key, this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final orders = ref.watch(adminOrdersProvider);

    return orders.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(adminOrdersProvider),
      ),
      data: (page) {
        final rows = limit == null ? page.items : page.items.take(limit!).toList();

        return AdminDataTable<AppOrder>(
          rows: rows,
          onRowTap: (order) =>
              ref.read(selectedOrderIdProvider.notifier).state = order.id,
          rowColor: (order) => order.isLate
              ? AppColors.danger.withValues(alpha: 0.05)
              : order.deliveryType.isVip
                  ? AppColors.warning.withValues(alpha: 0.05)
                  : null,
          emptyState: EmptyState(title: l10n.adminNoOrders, icon: Icons.receipt_long_outlined),
          columns: [
            AdminColumn(
              label: l10n.adminColOrderCode,
              width: 110,
              build: (order) => Text(order.code, style: AppText.adminTableHead),
            ),
            AdminColumn(
              label: l10n.adminCustomers,
              flex: 2,
              build: (order) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customer?.fullName ?? '—',
                    style: AppText.adminTable,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    Phone.pretty(order.customer?.phone),
                    style: AppText.adminNav.copyWith(color: AppColors.textMuted),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            AdminColumn(
              label: l10n.adminVendors,
              flex: 2,
              build: (order) => Text(
                order.vendor?.name ?? '—',
                style: AppText.adminTable,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AdminColumn(
              label: l10n.adminAgents,
              flex: 2,
              build: (order) => Text(
                order.agent?.fullName ?? '—',
                style: AppText.adminTable,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AdminColumn(
              label: l10n.cartTotal,
              width: 110,
              build: (order) => PriceText(order.totalCentimes, style: AppText.adminTable),
            ),
            AdminColumn(
              label: l10n.adminColStatus,
              width: 150,
              build: (order) => Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  StatusChip(order.status, dense: true),
                  if (order.isLate) StatusChip(order.status, isLate: true, dense: true),
                ],
              ),
            ),
            AdminColumn(
              label: l10n.adminColTime,
              width: 70,
              build: (order) => Text(
                '${order.createdAt.hour.toString().padLeft(2, '0')}:'
                '${order.createdAt.minute.toString().padLeft(2, '0')}',
                style: AppText.adminNav,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The filter bar above the orders table (§9's full filter set).
class AdminOrdersFilterBar extends ConsumerStatefulWidget {
  const AdminOrdersFilterBar({super.key});

  @override
  ConsumerState<AdminOrdersFilterBar> createState() => _AdminOrdersFilterBarState();
}

class _AdminOrdersFilterBarState extends ConsumerState<AdminOrdersFilterBar> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = ref.watch(adminOrderFiltersProvider);
    final notifier = ref.read(adminOrderFiltersProvider.notifier);

    const statuses = [
      'pending',
      'confirmed',
      'sent_to_vendor',
      'preparing',
      'ready',
      'assigned',
      'accepted',
      'picked_up',
      'on_the_way',
      'delivered',
      'cancelled',
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 260,
            child: TextField(
              controller: _search,
              style: AppText.adminTable,
              onSubmitted: (value) => notifier.state = filters.copyWith(query: value),
              decoration: InputDecoration(
                hintText: l10n.adminSearchOrders,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
              ),
            ),
          ),
          SizedBox(
            width: 190,
            child: DropdownButtonFormField<String?>(
              initialValue: filters.status,
              style: AppText.adminTable,
              decoration: InputDecoration(labelText: l10n.adminColStatus),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.filterAll)),
                for (final status in statuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(context.orderStatusLabel(OrderStatus.parse(status))),
                  ),
              ],
              onChanged: (value) => notifier.state =
                  value == null ? filters.copyWith(clear: true) : filters.copyWith(status: value),
            ),
          ),
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String?>(
              initialValue: filters.deliveryType,
              style: AppText.adminTable,
              decoration: InputDecoration(labelText: l10n.checkoutDeliveryType),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.filterAll)),
                DropdownMenuItem(value: 'normal', child: Text(l10n.checkoutDeliveryNormal)),
                DropdownMenuItem(value: 'vip', child: Text(l10n.checkoutDeliveryVip)),
              ],
              onChanged: (value) => notifier.state = filters.copyWith(deliveryType: value),
            ),
          ),
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String?>(
              initialValue: filters.payment,
              style: AppText.adminTable,
              decoration: InputDecoration(labelText: l10n.checkoutPayment),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.filterAll)),
                DropdownMenuItem(value: 'cash', child: Text(l10n.checkoutPaymentCash)),
                DropdownMenuItem(
                  value: 'electronic',
                  child: Text(l10n.checkoutPaymentElectronic),
                ),
              ],
              onChanged: (value) => notifier.state = filters.copyWith(payment: value),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _search.clear();
              notifier.state = filters.copyWith(clear: true);
            },
            icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
            label: Text(l10n.commonReset),
          ),
          const _ExportButton(),
        ],
      ),
    );
  }

}

class _ExportButton extends ConsumerWidget {
  const _ExportButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      onPressed: () async {
        // Fetches the CSV through the authenticated client, then hands it to
        // the platform: a real download on web, a share/copy elsewhere.
        final filters = ref.read(adminOrderFiltersProvider);
        final csv = await ref.read(adminRepositoryProvider).exportCsv(filters);
        if (!context.mounted) return;

        final message = switch (csv) {
          Ok(:final value) =>
            await downloadCsv(value, 'saji-orders.csv') ? l10n.adminExportCsv : l10n.errorGeneric,
          Err() => l10n.errorGeneric,
        };
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
      icon: const Icon(Icons.download_rounded, size: 18),
      label: Text(l10n.adminExportCsv),
    );
  }
}
