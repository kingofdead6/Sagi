/// Every named route in the app, so navigation never uses a string literal.
abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';
  static const locationSetup = '/location-setup';

  // customer
  static const home = '/home';
  static const vendors = '/vendors';
  static const vendor = '/vendor/:id';
  static String vendorPath(String id) => '/vendor/$id';
  static const product = '/product/:id';
  static String productPath(String id) => '/product/$id';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success/:id';
  static String orderSuccessPath(String id) => '/order-success/$id';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static String orderDetailPath(String id) => '/orders/$id';
  static const profile = '/profile';
  static const addresses = '/addresses';
  static const addressEdit = '/addresses/edit';
  static const vouchers = '/vouchers';
  static const notifications = '/notifications';
  static const language = '/language';

  // agent
  static const agentHome = '/agent';
  static const agentDelivery = '/agent/delivery';
  static const agentHistory = '/agent/history';
  static const agentOffer = '/agent/offer/:id';
  static String agentOfferPath(String id) => '/agent/offer/$id';

  // vendor portal (shop owner)
  static const vendorPortal = '/portal';
  static const vendorPortalMenu = '/portal/menu';

  // admin
  static const adminDashboard = '/admin';
  static const adminOrders = '/admin/orders';
  static const adminCustomers = '/admin/customers';
  static const adminAgents = '/admin/agents';
  static const adminVendors = '/admin/vendors';
  static const adminVendorEdit = '/admin/vendors/edit';
  static const adminProducts = '/admin/products';
  static const adminOffers = '/admin/offers';
  static const adminVouchers = '/admin/vouchers';
  static const adminCategories = '/admin/categories';
  static const adminFleet = '/admin/fleet';
  static const adminAnalytics = '/admin/analytics';
  static const adminSettings = '/admin/settings';

  static const devGallery = '/dev/gallery';
}
