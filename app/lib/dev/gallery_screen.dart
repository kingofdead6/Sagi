import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/widgets/app_bottom_nav.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/category_circle.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/product_tile.dart';
import 'package:saji/core/widgets/qty_stepper.dart';
import 'package:saji/core/widgets/search_pill.dart';
import 'package:saji/core/widgets/section_header.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/core/widgets/vendor_card.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// `/dev/gallery` — every shared widget rendered with sample data, so the
/// design system can be checked at 390px and 1440px without a backend.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _qty = 2;
  int _navIndex = 0;
  bool _loading = false;

  static const _vendor = Vendor(
    id: 'demo',
    name: 'مطعم الأصالة',
    rating: 4.6,
    ratingCount: 214,
    prepTimeMin: 15,
    deliveryFeeCentimes: Money(15000),
    minOrderCentimes: Money(50000),
    distanceKm: 1.8,
    etaMinutes: 22,
    isOpenNow: true,
    location: LatLng(34.7442, 8.0603),
  );

  static const _product = Product(
    id: 'demo-product',
    name: 'برجر كلاسيك',
    description: 'قطعة لحم بقري، خس، طماطم وصلصة البيت',
    priceCentimes: Money(45000),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Saji · Gallery', style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        children: [
          const _Group('Typography'),
          _Pad(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('عنوان قسم 24/ExtraBold', style: AppText.sectionTitle),
                Text('عنوان بطاقة 20/Bold', style: AppText.cardTitle),
                Text('نص أساسي 16/Medium', style: AppText.body),
                Text('نص ثانوي 14/Regular', style: AppText.meta),
                Text('شارة 12/Bold', style: AppText.badge),
              ],
            ),
          ),

          const _Group('Buttons'),
          _Pad(
            child: Column(
              children: [
                PrimaryButton(
                  label: l10n.checkoutSubmit,
                  isLoading: _loading,
                  onPressed: () => setState(() => _loading = !_loading),
                ),
                Gap.md,
                SecondaryButton(label: l10n.commonCancel, icon: Icons.close_rounded),
                Gap.md,
                const PrimaryButton(label: 'معطّل', onPressed: null),
              ],
            ),
          ),

          const _Group('SearchPill'),
          _Pad(child: SearchPill(hint: l10n.homeSearchHint)),

          const _Group('SectionHeader'),
          SectionHeader(l10n.homePopularNearby, onSeeAll: () {}),

          const _Group('CategoryCircle'),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              children: const [
                CategoryCircle(label: 'وجبات سريعة', iconKey: 'fastfood', isActive: true),
                Gap.wMd,
                CategoryCircle(label: 'فواكه', iconKey: 'fruits'),
                Gap.wMd,
                CategoryCircle(label: 'لحوم', iconKey: 'meat'),
                Gap.wMd,
                CategoryCircle(label: 'بقالة', iconKey: 'grocery'),
                Gap.wMd,
                CategoryCircle(label: 'المخبز', iconKey: 'bakery'),
              ],
            ),
          ),

          const _Group('VendorCard'),
          const _Pad(child: VendorCard(vendor: _vendor, hasOffer: true)),

          const _Group('ProductTile'),
          const _Pad(child: ProductTile(product: _product)),

          const _Group('PriceText & QtyStepper'),
          _Pad(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PriceText(Money(135000), color: AppColors.primaryGreen),
                QtyStepper(value: _qty, onChanged: (v) => setState(() => _qty = v)),
              ],
            ),
          ),

          const _Group('StatusChip'),
          _Pad(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final status in OrderStatus.values) StatusChip(status, dense: true),
                const StatusChip(OrderStatus.preparing, isLate: true, dense: true),
              ],
            ),
          ),

          const _Group('Skeletons'),
          const _Pad(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 200),
                Gap.sm,
                AppSkeleton(height: 80, radius: AppRadius.medium),
              ],
            ),
          ),

          const _Group('EmptyState'),
          SizedBox(
            height: 300,
            child: EmptyState(
              title: l10n.cartEmpty,
              icon: Icons.shopping_bag_outlined,
              actionLabel: l10n.cartEmptyAction,
              onAction: () {},
            ),
          ),

          const _Group('ErrorRetry'),
          SizedBox(
            height: 280,
            child: ErrorRetry(failure: const Failure.network(), onRetry: () {}),
          ),

          const _Group('Map'),
          const _Pad(
            child: ClipRRect(
              borderRadius: AppRadius.cardBorder,
              child: SizedBox(
                height: 220,
                child: SajiMap(
                  center: LocationService.fallbackCenter,
                  pins: [
                    MapPin(
                      point: LocationService.fallbackCenter,
                      icon: Icons.storefront_rounded,
                      color: AppColors.primaryGreen,
                      label: 'مطعم الأصالة',
                    ),
                  ],
                ),
              ),
            ),
          ),

          const _Group('Admin — StatCard'),
          _Pad(
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: l10n.adminStatTodayOrders,
                    value: '128',
                    icon: Icons.receipt_long_rounded,
                  ),
                ),
                Gap.wMd,
                Expanded(
                  child: StatCard(
                    label: l10n.adminStatRevenue,
                    value: const Money(1250000).format(),
                    icon: Icons.payments_rounded,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),

          const _Group('Admin — AdminDataTable'),
          _Pad(
            child: SizedBox(
              height: 200,
              child: AdminDataTable<({String code, String customer, Money total})>(
                rows: const [
                  (code: 'DR123326', customer: 'أمين حملاوي', total: Money(80000)),
                  (code: 'DR990211', customer: 'سارة بن عمر', total: Money(125000)),
                ],
                columns: [
                  AdminColumn(
                    label: 'الرمز',
                    build: (r) => Text(r.code, style: AppText.adminTableHead),
                  ),
                  AdminColumn(
                    label: l10n.adminCustomers,
                    flex: 2,
                    build: (r) => Text(r.customer, style: AppText.adminTable),
                  ),
                  AdminColumn(
                    label: l10n.cartTotal,
                    build: (r) => PriceText(r.total, style: AppText.adminTable),
                  ),
                ],
              ),
            ),
          ),

          const _Group('StickyBottomBar & AppBottomNav'),
          StickyBottomBar(
            child: PrimaryButton(label: l10n.cartGoToCart, onPressed: () {}),
          ),
          Gap.md,
          AppBottomNav(
            currentIndex: _navIndex,
            badges: const {1: 3},
            onTap: (index) => setState(() => _navIndex = index),
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
          ),
          Gap.xxl,
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.xl,
        AppSpacing.screenH,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppText.metaStrong.copyWith(color: AppColors.textMuted),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class _Pad extends StatelessWidget {
  const _Pad({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(padding: kScreenPadding, child: child);
}
