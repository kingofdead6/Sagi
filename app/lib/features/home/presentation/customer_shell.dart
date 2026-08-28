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

/// The customer tabs behind one floating bottom bar. The cart sits in the bar
/// as its own entry, badged with the item count, and pushes over the current
/// tab rather than replacing it.
class CustomerShell extends ConsumerWidget {
  const CustomerShell({required this.tab, super.key});

  /// The cart entry sits between orders and the profile.
  static const _cartTab = 2;

  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cartCount = ref.watch(cartItemCountProvider);

    final body = switch (tab) {
      1 => const OrdersScreen(),
      3 => const ProfileScreen(),
      _ => const HomeScreen(),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: body,
      bottomNavigationBar: AppBottomNav(
        currentIndex: tab,
        // The cart is always reachable - an empty one still opens, so customers
        // can see it is empty rather than wonder where it went.
        badges: {_cartTab: cartCount},
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
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag_rounded,
            label: l10n.navCart,
          ),
          BottomNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: l10n.navProfile,
          ),
        ],
        onTap: (index) {
          // The cart is a pushed route, so tapping it keeps the tab underneath.
          if (index == _cartTab) {
            context.push(Routes.cart);
            return;
          }
          context.go(
            switch (index) {
              1 => Routes.orders,
              3 => Routes.profile,
              _ => Routes.home,
            },
          );
        },
      ),
    );
  }
}
