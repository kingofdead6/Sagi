import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/pages/admin_analytics_page.dart';
import 'package:saji/features/admin/presentation/pages/admin_catalog_pages.dart';
import 'package:saji/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:saji/features/admin/presentation/pages/admin_fleet_page.dart';
import 'package:saji/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:saji/features/admin/presentation/pages/admin_people_pages.dart';
import 'package:saji/features/admin/presentation/pages/admin_settings_page.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';

enum AdminSection {
  dashboard,
  orders,
  customers,
  agents,
  vendors,
  products,
  offers,
  vouchers,
  categories,
  fleet,
  analytics,
  settings,
}

/// The admin dashboard chrome: a fixed 239px sidebar on the leading (right, in
/// RTL) edge, a top bar, and the section content. Designed for desktop widths;
/// narrower viewports get the sidebar in a drawer instead.
class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({required this.section, super.key});

  final AdminSection section;

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  @override
  void initState() {
    super.initState();
    // A new order rings and toasts — the board never needs a refresh button.
    ref.listenManual(newOrderAlertProvider, (previous, next) {
      final order = next.valueOrNull;
      if (order == null || !mounted) return;
      _announce('${context.l10n.adminOrderNew} · ${order.code}', AppColors.primaryGreen);
    });

    ref.listenManual(lateOrderAlertProvider, (previous, next) {
      final payload = next.valueOrNull;
      if (payload == null || !mounted) return;
      _announce('${context.l10n.adminOrderLate} · ${payload['code']}', AppColors.danger);
    });
  }

  void _announce(String message, Color color) {
    // The audible cue is the platform alert sound; the toast carries the text.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 6),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= AppSizes.adminMinWidth;

    return Scaffold(
      backgroundColor: AppColors.adminSurface,
      drawer: isWide ? null : Drawer(child: _Sidebar(active: widget.section)),
      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: AppColors.adminSurface,
              title: Text(_titleFor(context, widget.section), style: AppText.adminHeading),
            ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                if (isWide) _TopBar(title: _titleFor(context, widget.section)),
                Expanded(child: _content(widget.section)),
              ],
            ),
          ),
          // RTL puts the sidebar last in the Row, i.e. on the right edge.
          if (isWide) _Sidebar(active: widget.section),
        ],
      ),
    );
  }

  Widget _content(AdminSection section) => switch (section) {
        AdminSection.dashboard => const AdminDashboardPage(),
        AdminSection.orders => const AdminOrdersPage(),
        AdminSection.customers => const AdminCustomersPage(),
        AdminSection.agents => const AdminAgentsPage(),
        AdminSection.vendors => const AdminVendorsPage(),
        AdminSection.products => const AdminProductsPage(),
        AdminSection.offers => const AdminOffersPage(),
        AdminSection.vouchers => const AdminVouchersPage(),
        AdminSection.categories => const AdminCategoriesPage(),
        AdminSection.fleet => const AdminFleetPage(),
        AdminSection.analytics => const AdminAnalyticsPage(),
        AdminSection.settings => const AdminSettingsPage(),
      };
}

String _titleFor(BuildContext context, AdminSection section) {
  final l10n = context.l10n;
  return switch (section) {
    AdminSection.dashboard => l10n.adminDashboard,
    AdminSection.orders => l10n.adminOrders,
    AdminSection.customers => l10n.adminCustomers,
    AdminSection.agents => l10n.adminAgents,
    AdminSection.vendors => l10n.adminVendors,
    AdminSection.products => l10n.adminProducts,
    AdminSection.offers => l10n.adminOffers,
    AdminSection.vouchers => l10n.adminVouchers,
    AdminSection.categories => l10n.adminCategories,
    AdminSection.fleet => l10n.adminFleet,
    AdminSection.analytics => l10n.adminAnalytics,
    AdminSection.settings => l10n.adminSettings,
  };
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.active});

  final AdminSection active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);

    const items = <(AdminSection, IconData, String)>[
      (AdminSection.dashboard, Icons.dashboard_rounded, Routes.adminDashboard),
      (AdminSection.orders, Icons.receipt_long_rounded, Routes.adminOrders),
      (AdminSection.customers, Icons.people_rounded, Routes.adminCustomers),
      (AdminSection.agents, Icons.delivery_dining_rounded, Routes.adminAgents),
      (AdminSection.vendors, Icons.storefront_rounded, Routes.adminVendors),
      (AdminSection.products, Icons.inventory_2_rounded, Routes.adminProducts),
      (AdminSection.categories, Icons.category_rounded, Routes.adminCategories),
      (AdminSection.offers, Icons.local_offer_rounded, Routes.adminOffers),
      (AdminSection.vouchers, Icons.confirmation_num_rounded, Routes.adminVouchers),
      (AdminSection.fleet, Icons.map_rounded, Routes.adminFleet),
      (AdminSection.analytics, Icons.insights_rounded, Routes.adminAnalytics),
    ];

    return Container(
      width: AppSizes.adminSidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.adminSurface,
        border: Border(left: BorderSide(color: AppColors.adminBorder)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.adminAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delivery_dining_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Gap.wMd,
                  Text(l10n.appName, style: AppText.adminSubheading),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                children: [
                  for (final (section, icon, route) in items)
                    _SidebarItem(
                      icon: icon,
                      label: _titleFor(context, section),
                      isActive: section == active,
                      onTap: () => context.go(route),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _SidebarItem(
                    icon: Icons.settings_rounded,
                    label: l10n.adminSettings,
                    isActive: active == AdminSection.settings,
                    onTap: () => context.go(Routes.adminSettings),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.logout_rounded, size: 20),
                    title: Text(user?.fullName ?? l10n.authLogout, style: AppText.adminNav),
                    onTap: () => ref.read(authControllerProvider.notifier).logout(),
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

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smallBorder,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.adminRowHover : null,
            borderRadius: AppRadius.smallBorder,
            // A 4px accent bar on the leading (right, in RTL) edge.
            border: isActive
                ? const BorderDirectional(
                    start: BorderSide(
                      color: AppColors.adminAccent,
                      width: AppSizes.adminActiveBar,
                    ),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.adminAccent : AppColors.adminText,
              ),
              Gap.wMd,
              Expanded(
                child: Text(
                  label,
                  style: isActive ? AppText.adminNavActive : AppText.adminNav,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminStatsProvider).valueOrNull;

    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.adminSurface,
        border: Border(bottom: BorderSide(color: AppColors.adminBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.adminHeading)),
          if (stats != null) ...[
            _Pill(
              label: context.l10n.adminStatPending,
              value: '${stats.pendingOrders}',
              color: AppColors.warning,
            ),
            Gap.wMd,
            _Pill(
              label: context.l10n.adminStatOnlineAgents,
              value: '${stats.onlineAgents}',
              color: AppColors.primaryGreen,
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.smallBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppText.adminNavActive.copyWith(color: color)),
          Gap.wXs,
          Text(label, style: AppText.adminNav),
        ],
      ),
    );
  }
}
