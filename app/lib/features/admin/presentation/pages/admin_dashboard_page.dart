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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 1200
                        ? 5
                        : constraints.maxWidth > 800
                            ? 3
                            : 2;
                    final data = stats.valueOrNull;

                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.9,
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
              const Expanded(child: AdminOrdersBoard()),
            ],
          ),
        ),
        if (selectedId != null) const AdminOrderDrawer(),
      ],
    );
  }
}
