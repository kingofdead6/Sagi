import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/admin/presentation/pages/admin_order_drawer.dart';
import 'package:saji/features/admin/presentation/pages/admin_orders_board.dart';

/// Figma node 2601:1178 — the stat grid over the live orders table, with the
/// order drawer sliding in from the leading edge.
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stats = ref.watch(adminStatsProvider);
    final selectedId = ref.watch(selectedOrderIdProvider);

    return Row(
      children: [
        Expanded(
          // The page scrolls as a whole: the stat grid scrolls away with the
          // orders table rather than staying pinned above its own scroller.
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Size the grid from a card's minimum readable width rather
                    // than fixed breakpoints: on a phone that yields a single
                    // column instead of two squashed ones.
                    const minCardWidth = 190.0;
                    final columns = (constraints.maxWidth / minCardWidth)
                        .floor()
                        .clamp(1, 5);

                    // A lone card in a narrow column would be absurdly tall at
                    // the desktop ratio, so flatten it as the count drops.
                    final aspectRatio = switch (columns) {
                      1 => 3.4,
                      2 => 2.2,
                      _ => 1.9,
                    };
                    final data = stats.valueOrNull;

                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: aspectRatio,
                      children: [
                        StatCard(
                          label: l10n.adminStatTodayOrders,
                          value: '${data?.todayOrders ?? 0}',
                          icon: Icons.receipt_long_rounded,
                        ),
                        StatCard(
                          label: l10n.adminStatRevenue,
                          value: data?.revenueCentimes.format() ?? '—',
                          icon: Icons.payments_rounded,
                          color: AppColors.primaryGreen,
                        ),
                        StatCard(
                          label: l10n.adminStatActiveDeliveries,
                          value: '${data?.activeDeliveries ?? 0}',
                          icon: Icons.delivery_dining_rounded,
                          color: AppColors.info,
                        ),
                        StatCard(
                          label: l10n.adminStatAvgTime,
                          value: l10n.vendorMinutes(data?.avgDeliveryMinutes ?? 0),
                          icon: Icons.timer_rounded,
                        ),
                        StatCard(
                          label: l10n.adminStatLate,
                          value: '${data?.lateOrders ?? 0}',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.danger,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Text(l10n.adminOrders, style: AppText.adminSubheading),
                    const Spacer(),
                    if (stats.isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
                Gap.md,
                const AdminOrdersBoard(shrinkWrap: true),
              ],
            ),
          ),
        ),
        if (selectedId != null) const AdminOrderDrawer(),
      ],
    );
  }
}
