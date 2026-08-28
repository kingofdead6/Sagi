import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/dev/gallery_screen.dart';
import 'package:saji/features/admin/presentation/admin_shell.dart';
import 'package:saji/features/agent/presentation/agent_home_screen.dart';
import 'package:saji/features/auth/domain/user.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/auth/presentation/login_screen.dart';
import 'package:saji/features/auth/presentation/otp_screen.dart';
import 'package:saji/features/auth/presentation/register_screen.dart';
import 'package:saji/features/auth/presentation/splash_screen.dart';
import 'package:saji/features/cart/presentation/cart_screen.dart';
import 'package:saji/features/catalog/presentation/product_screen.dart';
import 'package:saji/features/checkout/presentation/checkout_screen.dart';
import 'package:saji/features/checkout/presentation/order_success_screen.dart';
import 'package:saji/features/home/presentation/customer_shell.dart';
import 'package:saji/features/orders/presentation/order_detail_screen.dart';
import 'package:saji/features/profile/presentation/address_edit_screen.dart';
import 'package:saji/features/profile/presentation/addresses_screen.dart';
import 'package:saji/features/profile/presentation/notifications_screen.dart';
import 'package:saji/features/portal/presentation/portal_screen.dart';
import 'package:saji/features/profile/presentation/vouchers_screen.dart';
import 'package:saji/features/profile/presentation/location_setup_screen.dart';
import 'package:saji/features/vendors/presentation/vendor_screen.dart';
import 'package:saji/features/vendors/presentation/vendors_screen.dart';

/// Rebuilds go_router's redirect whenever the auth state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _ref.listen<AuthState>(
      authControllerProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    debugLogDiagnostics: false,

    /// One guard for the whole app: unauthenticated users only reach the auth
    /// routes, and each role only reaches its own surface.
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.matchedLocation;

      const authRoutes = {Routes.login, Routes.register, Routes.otp};
      final isAuthRoute = authRoutes.contains(path);
      final isSplash = path == Routes.splash;
      final isDev = path.startsWith('/dev');

      if (isDev) return null;
      if (!auth.isResolved) return isSplash ? null : Routes.splash;

      if (!auth.isAuthenticated) return isAuthRoute ? null : Routes.login;

      // Signed in: send each role to its own home and keep it there.
      final home = switch (auth.role) {
        UserRole.admin => Routes.adminDashboard,
        UserRole.agent => Routes.agentHome,
        UserRole.vendor => Routes.vendorPortal,
        UserRole.customer => Routes.home,
      };

      if (isSplash || isAuthRoute) return home;

      final inAdmin = path.startsWith('/admin');
      final inAgent = path.startsWith('/agent');
      final inPortal = path.startsWith('/portal');

      return switch (auth.role) {
        UserRole.admin => inAdmin ? null : Routes.adminDashboard,
        UserRole.agent => inAgent ? null : Routes.agentHome,
        UserRole.vendor => inPortal ? null : Routes.vendorPortal,
        UserRole.customer => (inAdmin || inAgent || inPortal) ? Routes.home : null,
      };
    },

    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.otp, builder: (_, __) => const OtpScreen()),
      GoRoute(path: Routes.devGallery, builder: (_, __) => const GalleryScreen()),

      // ── vendor portal ───────────────────────────────────────────────────
      GoRoute(path: Routes.vendorPortal, builder: (_, __) => const PortalScreen()),

      // ── customer ────────────────────────────────────────────────────────
      GoRoute(path: Routes.home, builder: (_, __) => const CustomerShell(tab: 0)),
      GoRoute(path: Routes.orders, builder: (_, __) => const CustomerShell(tab: 1)),
      GoRoute(path: Routes.profile, builder: (_, __) => const CustomerShell(tab: 3)),
      GoRoute(path: Routes.vendors, builder: (_, state) {
        return VendorsScreen(
          categoryId: state.uri.queryParameters['category'],
          initialSearch: state.uri.queryParameters['q'],
        );
      }),
      GoRoute(
        path: Routes.vendor,
        builder: (_, state) => VendorScreen(vendorId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.product,
        builder: (_, state) => ProductScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.cart, builder: (_, __) => const CartScreen()),
      GoRoute(path: Routes.checkout, builder: (_, __) => const CheckoutScreen()),
      GoRoute(
        path: Routes.orderSuccess,
        builder: (_, state) => OrderSuccessScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.orderDetail,
        builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(path: Routes.addresses, builder: (_, __) => const AddressesScreen()),
      GoRoute(path: Routes.vouchers, builder: (_, __) => const VouchersScreen()),
      GoRoute(
        path: Routes.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.addressEdit,
        builder: (_, state) => AddressEditScreen(addressId: state.uri.queryParameters['id']),
      ),
      GoRoute(
        path: Routes.locationSetup,
        builder: (_, state) => LocationSetupScreen(
          isOnboarding: state.uri.queryParameters['onboarding'] == '1',
        ),
      ),

      // ── agent ───────────────────────────────────────────────────────────
      GoRoute(path: Routes.agentHome, builder: (_, __) => const AgentHomeScreen()),

      // ── admin ───────────────────────────────────────────────────────────
      GoRoute(
        path: Routes.adminDashboard,
        builder: (_, __) => const AdminShell(section: AdminSection.dashboard),
      ),
      GoRoute(
        path: Routes.adminOrders,
        builder: (_, __) => const AdminShell(section: AdminSection.orders),
      ),
      GoRoute(
        path: Routes.adminCustomers,
        builder: (_, __) => const AdminShell(section: AdminSection.customers),
      ),
      GoRoute(
        path: Routes.adminAgents,
        builder: (_, __) => const AdminShell(section: AdminSection.agents),
      ),
      GoRoute(
        path: Routes.adminVendors,
        builder: (_, __) => const AdminShell(section: AdminSection.vendors),
      ),
      GoRoute(
        path: Routes.adminProducts,
        builder: (_, __) => const AdminShell(section: AdminSection.products),
      ),
      GoRoute(
        path: Routes.adminOffers,
        builder: (_, __) => const AdminShell(section: AdminSection.offers),
      ),
      GoRoute(
        path: Routes.adminVouchers,
        builder: (_, __) => const AdminShell(section: AdminSection.vouchers),
      ),
      GoRoute(
        path: Routes.adminCategories,
        builder: (_, __) => const AdminShell(section: AdminSection.categories),
      ),
      GoRoute(
        path: Routes.adminFleet,
        builder: (_, __) => const AdminShell(section: AdminSection.fleet),
      ),
      GoRoute(
        path: Routes.adminAnalytics,
        builder: (_, __) => const AdminShell(section: AdminSection.analytics),
      ),
      GoRoute(
        path: Routes.adminSettings,
        builder: (_, __) => const AdminShell(section: AdminSection.settings),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('المسار غير موجود: ${state.uri}')),
    ),
  );
});
