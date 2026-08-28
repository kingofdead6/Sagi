import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_bottom_nav.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';
import 'package:saji/features/home/presentation/home_screen.dart';
import 'package:saji/features/orders/presentation/orders_screen.dart';
import 'package:saji/features/profile/presentation/profile_screen.dart';

/// The three customer tabs behind one blurred bottom bar. The cart lives on
/// the home tab's FAB rather than in the nav, matching the Figma layout.
class CustomerShell extends ConsumerWidget {
  const CustomerShell({required this.tab, super.key});

  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cartCount = ref.watch(cartItemCountProvider);

    final body = switch (tab) {
      1 => const OrdersScreen(),
      2 => const ProfileScreen(),
      _ => const HomeScreen(),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: body,
      // The cart is always reachable — an empty one still opens, so customers
      // can see it is empty rather than wonder where it went.
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'cart',
        backgroundColor:
            cartCount == 0 ? AppColors.textSecondary : AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => context.push(Routes.cart),
        icon: const Icon(Icons.shopping_bag_rounded),
        label: Text(
          cartCount == 0 ? l10n.cartTitle : l10n.cartItemCount(cartCount),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: tab,
        items: [
          BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: l10n.navHome,
          ),
          BottomNavItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded,
            label: l10n.navOrders,
          ),
          BottomNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: l10n.navProfile,
          ),
        ],
        onTap: (index) => context.go(
          switch (index) {
            1 => Routes.orders,
            2 => Routes.profile,
            _ => Routes.home,
          },
        ),
      ),
    );
  }
}
