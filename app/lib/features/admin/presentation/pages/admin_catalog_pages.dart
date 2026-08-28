import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/network/image_upload_service.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_image_field.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/admin/presentation/pages/admin_vendor_form.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/offers/domain/offer.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

// ─────────────────────────────── vendors ──────────────────────────────────

final adminVendorsProvider = FutureProvider.autoDispose<Paged<Vendor>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).vendors();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

/// The vendor open in the editor drawer; `''` means "new vendor".
final editingVendorIdProvider = StateProvider<String?>((ref) => null);

class AdminVendorsPage extends ConsumerWidget {
  const AdminVendorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vendors = ref.watch(adminVendorsProvider);
    final editingId = ref.watch(editingVendorIdProvider);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _Toolbar(
                actionLabel: l10n.adminVendorNew,
                onAction: () => ref.read(editingVendorIdProvider.notifier).state = '',
              ),
              Expanded(
                child: vendors.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => ErrorRetry(
                    failure: error is Failure ? error : const Failure.unknown(),
                    onRetry: () => ref.invalidate(adminVendorsProvider),
                  ),
                  data: (page) => AdminDataTable<Vendor>(
                    rows: page.items,
                    onRowTap: (vendor) =>
                        ref.read(editingVendorIdProvider.notifier).state = vendor.id,
                    emptyState: EmptyState(
                      title: l10n.emptyTitle,
                      icon: Icons.storefront_outlined,
                      actionLabel: l10n.adminVendorNew,
                      onAction: () => ref.read(editingVendorIdProvider.notifier).state = '',
                    ),
                    columns: [
                      AdminColumn(
                        label: l10n.adminVendorName,
                        flex: 2,
                        minWidth: 180,
                        build: (v) => Text(v.name, style: AppText.adminTable),
                      ),
                      AdminColumn(
                        label: l10n.adminVendorPhone,
                        build: (v) => Text(
                          v.phone,
                          style: AppText.adminNav,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      AdminColumn(
                        label: l10n.checkoutDeliveryFee,
                        width: 110,
                        build: (v) =>
                            PriceText(v.deliveryFeeCentimes, style: AppText.adminTable),
                      ),
                      AdminColumn(
                        label: l10n.filterSortRating,
                        width: 90,
                        build: (v) => Text(
                          v.rating.toStringAsFixed(1),
                          style: AppText.adminTable,
                        ),
                      ),
                      AdminColumn(
                        label: l10n.adminVendorIsOpen,
                        width: 110,
                        build: (v) => _Badge(
                          label: v.isOpen ? l10n.vendorOpen : l10n.vendorClosed,
                          color: v.isOpen ? AppColors.primaryGreen : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (editingId != null) AdminVendorForm(vendorId: editingId.isEmpty ? null : editingId),
      ],
    );
  }
}

// ─────────────────────────────── products ─────────────────────────────────

final adminProductVendorProvider = StateProvider<String?>((ref) => null);

final adminSectionsProvider =
    FutureProvider.autoDispose.family<List<MenuSection>, String>((ref, vendorId) async {
  final result = await ref.watch(adminRepositoryProvider).sections(vendorId);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final adminProductsProvider = FutureProvider.autoDispose<Paged<Product>>((ref) async {
  final vendorId = ref.watch(adminProductVendorProvider);
  final result = await ref.watch(adminRepositoryProvider).products(vendorId: vendorId);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminProductsPage extends ConsumerWidget {
  const AdminProductsPage({super.key});

  /// Below this the sections panel cannot sit beside the list without starving
  /// both, so it moves into an end drawer reached from the toolbar.
  static const _sidePanelBreakpoint = 900.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final products = ref.watch(adminProductsProvider);
    final vendors = ref.watch(adminVendorsProvider).valueOrNull;
    final vendorId = ref.watch(adminProductVendorProvider);
    final isWide = MediaQuery.sizeOf(context).width >= _sidePanelBreakpoint;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Only offer the drawer when there is a vendor whose sections to show.
      endDrawer: (!isWide && vendorId != null)
          ? Drawer(child: SafeArea(child: _SectionsPanel(vendorId: vendorId, inDrawer: true)))
          : null,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _ProductsToolbar(
                    isWide: isWide,
                    vendorId: vendorId,
                    vendors: vendors?.items ?? const <Vendor>[],
                    onVendorChanged: (value) =>
                        ref.read(adminProductVendorProvider.notifier).state = value,
                    onNewProduct: () => _editProduct(context, ref, null, vendorId),
                  ),
                ),
                Expanded(
                  child: products.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => ErrorRetry(
                      failure: error is Failure ? error : const Failure.unknown(),
                      onRetry: () => ref.invalidate(adminProductsProvider),
                    ),
                    data: (page) {
                      if (page.isEmpty) {
                        return EmptyState(
                          title: l10n.emptyTitle,
                          icon: Icons.inventory_2_outlined,
                          actionLabel: l10n.adminProductNew,
                          onAction: () => _editProduct(context, ref, null, vendorId),
                        );
                      }
                      // Reordering only makes sense within one vendor's menu.
                      return _ProductList(
                        products: page.items,
                        canReorder: vendorId != null,
                        onEdit: (product) => _editProduct(context, ref, product, vendorId),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isWide && vendorId != null) _SectionsPanel(vendorId: vendorId),
        ],
      ),
    );
  }

  Future<void> _editProduct(
    BuildContext context,
    WidgetRef ref,
    Product? product,
    String? vendorId,
  ) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _ProductDialog(product: product, vendorId: vendorId),
    );
    if (saved ?? false) ref.invalidate(adminProductsProvider);
  }
}

/// The product list. Filtered to one vendor it becomes drag-reorderable, and
/// the new order is persisted through POST /admin/products/reorder.
class _ProductList extends ConsumerStatefulWidget {
  const _ProductList({
    required this.products,
    required this.canReorder,
    required this.onEdit,
  });

  final List<Product> products;
  final bool canReorder;
  final void Function(Product product) onEdit;

  @override
  ConsumerState<_ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<_ProductList> {
  late List<Product> _ordered = List.of(widget.products);
  bool _saving = false;

  @override
  void didUpdateWidget(_ProductList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.products != widget.products) {
      _ordered = List.of(widget.products);
    }
  }

  Future<void> _persistOrder() async {
    setState(() => _saving = true);
    final result = await ref.read(adminRepositoryProvider).reorderProducts(
          [
            for (var i = 0; i < _ordered.length; i++) (id: _ordered[i].id, sortOrder: i),
          ],
        );
    if (!mounted) return;
    setState(() => _saving = false);

    if (result case Err(:final failure)) {
      // Put the list back the way the server still has it.
      setState(() => _ordered = List.of(widget.products));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        if (_saving) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: _ordered.length,
            // onReorderItem already accounts for the removed item's index.
            onReorderItem: (oldIndex, newIndex) {
              if (!widget.canReorder) return;
              setState(() => _ordered.insert(newIndex, _ordered.removeAt(oldIndex)));
              _persistOrder();
            },
            itemBuilder: (context, index) {
              final product = _ordered[index];
              return Container(
                key: ValueKey(product.id),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.adminBorder, width: 0.5),
                  ),
                ),
                child: ListTile(
                  onTap: () => widget.onEdit(product),
                  leading: widget.canReorder
                      ? ReorderableDragStartListener(
                          index: index,
                          child: const Icon(
                            Icons.drag_indicator_rounded,
                            color: AppColors.textMuted,
                          ),
                        )
                      : const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted),
                  title: Text(product.name, style: AppText.adminTable),
                  subtitle: Text(
                    product.options.isEmpty
                        ? ''
                        : '${product.options.length} ${l10n.adminProductOptions}',
                    style: AppText.adminNav.copyWith(color: AppColors.textMuted),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PriceText(product.priceCentimes, style: AppText.adminTable),
                      Gap.wLg,
                      _AvailabilityToggle(product: product),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Menu sections for the selected vendor: create, delete, and see how the menu
/// is grouped on the customer side.
/// The products toolbar. On a wide window the vendor filter and the new-product
/// button sit on one line; on a phone they stack, and a menu button opens the
/// sections drawer.
class _ProductsToolbar extends StatelessWidget {
  const _ProductsToolbar({
    required this.isWide,
    required this.vendorId,
    required this.vendors,
    required this.onVendorChanged,
    required this.onNewProduct,
  });

  final bool isWide;
  final String? vendorId;
  final List<Vendor> vendors;
  final ValueChanged<String?> onVendorChanged;
  final VoidCallback onNewProduct;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final filter = DropdownButtonFormField<String?>(
      initialValue: vendorId,
      isExpanded: true,
      style: AppText.adminTable,
      decoration: InputDecoration(labelText: l10n.adminVendors),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.filterAll)),
        for (final vendor in vendors)
          DropdownMenuItem(value: vendor.id, child: Text(vendor.name)),
      ],
      onChanged: onVendorChanged,
    );

    final addButton = FilledButton.icon(
      onPressed: onNewProduct,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: Text(l10n.adminProductNew),
    );

    if (isWide) {
      return Row(
        children: [
          SizedBox(width: 260, child: filter),
          const Spacer(),
          addButton,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: filter),
            if (vendorId != null) ...[
              Gap.wSm,
              IconButton(
                tooltip: l10n.portalSections,
                icon: const Icon(Icons.menu_rounded),
                // Opens the sections panel that the wide layout shows inline.
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ],
          ],
        ),
        Gap.sm,
        addButton,
      ],
    );
  }
}

class _SectionsPanel extends ConsumerWidget {
  const _SectionsPanel({required this.vendorId, this.inDrawer = false});

  final String vendorId;

  /// In a drawer the panel fills the sheet instead of taking a fixed column,
  /// and drops the divider that separated it from the list.
  final bool inDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sections = ref.watch(adminSectionsProvider(vendorId));

    return SizedBox(
      width: inDrawer ? null : 300,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.adminSurface,
          border: inDrawer
              ? null
              : const Border(right: BorderSide(color: AppColors.adminBorder)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.adminSectionNew, style: AppText.adminSubheading),
                  ),
                  IconButton(
                    tooltip: l10n.adminSectionNew,
                    onPressed: () => _create(context, ref),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: sections.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorRetry(
                  failure: error is Failure ? error : const Failure.unknown(),
                  compact: true,
                  onRetry: () => ref.invalidate(adminSectionsProvider(vendorId)),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      title: l10n.emptyTitle,
                      icon: Icons.list_alt_rounded,
                      actionLabel: l10n.adminSectionNew,
                      onAction: () => _create(context, ref),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    children: [
                      for (final section in items)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.folder_outlined, size: 20),
                          title: Text(section.name, style: AppText.adminTable),
                          trailing: IconButton(
                            tooltip: l10n.commonDelete,
                            onPressed: () => _delete(context, ref, section),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminSectionNew, style: AppText.adminSubheading),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.adminSectionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();

    if (name == null || name.isEmpty || !context.mounted) return;

    final existing = ref.read(adminSectionsProvider(vendorId)).valueOrNull ?? const [];
    final result = await ref
        .read(adminRepositoryProvider)
        .createSection(vendorId, name, existing.length);
    if (!context.mounted) return;

    switch (result) {
      case Ok():
        ref.invalidate(adminSectionsProvider(vendorId));
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, MenuSection section) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonDelete, style: AppText.adminSubheading),
        content: Text(section.name, style: AppText.adminTable),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (!(confirmed ?? false) || !context.mounted) return;

    // The server detaches the section's products rather than deleting them.
    final result = await ref.read(adminRepositoryProvider).deleteSection(section.id);
    if (!context.mounted) return;

    switch (result) {
      case Ok():
        ref
          ..invalidate(adminSectionsProvider(vendorId))
          ..invalidate(adminProductsProvider);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }
}

class _AvailabilityToggle extends ConsumerStatefulWidget {
  const _AvailabilityToggle({required this.product});

  final Product product;

  @override
  ConsumerState<_AvailabilityToggle> createState() => _AvailabilityToggleState();
}

class _AvailabilityToggleState extends ConsumerState<_AvailabilityToggle> {
  late bool _value = widget.product.isAvailable;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      activeTrackColor: AppColors.primaryGreen,
      onChanged: _busy
          ? null
          : (next) async {
              setState(() {
                _value = next;
                _busy = true;
              });
              final result = await ref
                  .read(adminRepositoryProvider)
                  .setAvailability([widget.product.id], isAvailable: next);
              if (!mounted) return;
              setState(() => _busy = false);
              if (result.isErr) setState(() => _value = !next);
            },
    );
  }
}

class _ProductDialog extends ConsumerStatefulWidget {
  const _ProductDialog({required this.product, required this.vendorId});

  final Product? product;
  final String? vendorId;

  @override
  ConsumerState<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends ConsumerState<_ProductDialog> {
  late final _name = TextEditingController(text: widget.product?.name ?? '');
  late final _description = TextEditingController(text: widget.product?.description ?? '');
  late final _price = TextEditingController(
    text: widget.product == null ? '' : widget.product!.priceCentimes.dinars.toStringAsFixed(0),
  );
  late String? _vendorId = widget.product?.vendor ?? widget.vendorId;
  late bool _available = widget.product?.isAvailable ?? true;
  late ImageRef? _image = widget.product?.image;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final dinars = num.tryParse(_price.text.trim());
    if (_name.text.trim().isEmpty || dinars == null || _vendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorValidation)),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(adminRepositoryProvider).saveProduct(
      {
        if (widget.product == null) 'vendor': _vendorId,
        'name': _name.text.trim(),
        if (_description.text.trim().isNotEmpty) 'description': _description.text.trim(),
        // The form takes dinars; the wire always carries centimes.
        'priceCentimes': Money.fromDinars(dinars).centimes,
        'image': _image?.toJson(),
        'isAvailable': _available,
      },
      id: widget.product?.id,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vendors = ref.watch(adminVendorsProvider).valueOrNull;

    return AlertDialog(
      title: Text(
        widget.product == null ? l10n.adminProductNew : l10n.adminProductEdit,
        style: AppText.adminSubheading,
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.product == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: DropdownButtonFormField<String?>(
                    initialValue: _vendorId,
                    style: AppText.adminTable,
                    decoration: InputDecoration(labelText: l10n.adminVendors),
                    items: [
                      for (final vendor in vendors?.items ?? const <Vendor>[])
                        DropdownMenuItem(value: vendor.id, child: Text(vendor.name)),
                    ],
                    onChanged: (value) => setState(() => _vendorId = value),
                  ),
                ),
              AdminField(label: l10n.adminProductName, controller: _name),
              AdminField(
                label: l10n.adminVendorDescription,
                controller: _description,
                maxLines: 2,
              ),
              AdminField(
                label: l10n.adminProductPrice,
                controller: _price,
                keyboardType: TextInputType.number,
              ),
              AdminImageField(
                label: l10n.adminProductImage,
                value: _image,
                folder: UploadFolder.products,
                fallbackIcon: Icons.fastfood_rounded,
                onChanged: (image) => setState(() => _image = image),
              ),
              AdminSwitchField(
                label: l10n.adminProductAvailable,
                value: _available,
                onChanged: (value) => setState(() => _available = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.product != null)
          TextButton(
            onPressed: _saving
                ? null
                : () async {
                    final result = await ref
                        .read(adminRepositoryProvider)
                        .deleteProduct(widget.product!.id);
                    if (!context.mounted) return;
                    if (result.isOk) Navigator.of(context).pop(true);
                  },
            child: Text(
              l10n.commonDelete,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}

// ─────────────────────────────── offers ───────────────────────────────────

final adminOffersProvider = FutureProvider.autoDispose<List<Offer>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).offers();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminOffersPage extends ConsumerWidget {
  const AdminOffersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final offers = ref.watch(adminOffersProvider);

    return Column(
      children: [
        _Toolbar(
          actionLabel: l10n.adminOfferNew,
          onAction: () => _edit(context, ref, null),
        ),
        Expanded(
          child: offers.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorRetry(
              failure: error is Failure ? error : const Failure.unknown(),
              onRetry: () => ref.invalidate(adminOffersProvider),
            ),
            data: (items) => AdminDataTable<Offer>(
              rows: items,
              onRowTap: (offer) => _edit(context, ref, offer),
              emptyState: EmptyState(title: l10n.homeNoOffers, icon: Icons.local_offer_outlined),
              columns: [
                AdminColumn(
                  label: l10n.adminOfferTitle,
                  flex: 2,
                  minWidth: 180,
                  build: (o) => Text(o.title, style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.adminOfferType,
                  build: (o) => Text(_typeLabel(context, o.type), style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.adminOfferScope,
                  build: (o) => Text(
                    o.isPlatformWide ? l10n.adminOfferPlatform : (o.vendorName ?? '—'),
                    style: AppText.adminTable,
                  ),
                ),
                AdminColumn(
                  label: l10n.adminOfferShowOnHome,
                  width: 120,
                  build: (o) => _Badge(
                    label: o.showOnHome ? l10n.commonYes : l10n.commonNo,
                    color: o.showOnHome ? AppColors.primaryGreen : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _typeLabel(BuildContext context, OfferType type) {
    final l10n = context.l10n;
    return switch (type) {
      OfferType.percentage => l10n.adminOfferTypePercentage,
      OfferType.fixed => l10n.adminOfferTypeFixed,
      OfferType.freeDelivery => l10n.adminOfferTypeFreeDelivery,
      OfferType.bundle => l10n.adminOfferTypeBundle,
    };
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Offer? offer) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _OfferDialog(offer: offer),
    );
    if (saved ?? false) ref.invalidate(adminOffersProvider);
  }
}

class _OfferDialog extends ConsumerStatefulWidget {
  const _OfferDialog({required this.offer});

  final Offer? offer;

  @override
  ConsumerState<_OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends ConsumerState<_OfferDialog> {
  late final _title = TextEditingController(text: widget.offer?.title ?? '');
  late final _subtitle = TextEditingController(text: widget.offer?.subtitle ?? '');
  late final _value = TextEditingController(text: '${widget.offer?.value ?? 0}');
  late OfferType _type = widget.offer?.type ?? OfferType.percentage;
  late String? _vendorId = widget.offer?.vendor;
  late bool _showOnHome = widget.offer?.showOnHome ?? false;
  late bool _isActive = widget.offer?.isActive ?? true;
  late ImageRef? _image = widget.offer?.image;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final rawValue = num.tryParse(_value.text.trim()) ?? 0;
    final result = await ref.read(adminRepositoryProvider).saveOffer(
      {
        'title': _title.text.trim(),
        if (_subtitle.text.trim().isNotEmpty) 'subtitle': _subtitle.text.trim(),
        'type': _type.wire,
        // A fixed offer is entered in dinars but stored in centimes.
        'value': _type == OfferType.fixed ? Money.fromDinars(rawValue).centimes : rawValue,
        'vendor': _vendorId,
        'image': _image?.toJson(),
        'showOnHome': _showOnHome,
        'isActive': _isActive,
      },
      id: widget.offer?.id,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vendors = ref.watch(adminVendorsProvider).valueOrNull;

    return AlertDialog(
      title: Text(l10n.adminOfferNew, style: AppText.adminSubheading),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminField(label: l10n.adminOfferTitle, controller: _title),
              AdminField(label: l10n.adminOfferSubtitle, controller: _subtitle),
              AdminImageField(
                label: l10n.adminOfferImage,
                value: _image,
                folder: UploadFolder.offers,
                fallbackIcon: Icons.local_offer_rounded,
                onChanged: (image) => setState(() => _image = image),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: DropdownButtonFormField<OfferType>(
                  initialValue: _type,
                  style: AppText.adminTable,
                  decoration: InputDecoration(labelText: l10n.adminOfferType),
                  items: [
                    for (final type in OfferType.values)
                      DropdownMenuItem(
                        value: type,
                        child: Text(AdminOffersPage._typeLabel(context, type)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? OfferType.percentage),
                ),
              ),
              if (_type != OfferType.freeDelivery)
                AdminField(
                  label: l10n.adminOfferValue,
                  controller: _value,
                  keyboardType: TextInputType.number,
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: DropdownButtonFormField<String?>(
                  initialValue: _vendorId,
                  style: AppText.adminTable,
                  decoration: InputDecoration(labelText: l10n.adminOfferScope),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.adminOfferPlatform)),
                    for (final vendor in vendors?.items ?? const <Vendor>[])
                      DropdownMenuItem(value: vendor.id, child: Text(vendor.name)),
                  ],
                  onChanged: (value) => setState(() => _vendorId = value),
                ),
              ),
              AdminSwitchField(
                label: l10n.adminOfferShowOnHome,
                value: _showOnHome,
                onChanged: (value) => setState(() => _showOnHome = value),
              ),
              AdminSwitchField(
                label: l10n.vendorOpen,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),

              // Live preview of the customer-facing card.
              Gap.md,
              Text(l10n.adminOfferPreview, style: AppText.adminTableHead),
              Gap.sm,
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreenDeep,
                  borderRadius: AppRadius.cardBorder,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title.text.isEmpty ? l10n.adminOfferTitle : _title.text,
                      style: AppText.cardTitle.copyWith(color: Colors.white),
                    ),
                    if (_subtitle.text.isNotEmpty)
                      Text(
                        _subtitle.text,
                        style: AppText.meta.copyWith(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.offer != null)
          TextButton(
            onPressed: _saving
                ? null
                : () async {
                    final result =
                        await ref.read(adminRepositoryProvider).deleteOffer(widget.offer!.id);
                    if (!context.mounted) return;
                    if (result.isOk) Navigator.of(context).pop(true);
                  },
            child: Text(
              l10n.commonDelete,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

// ─────────────────────────────── vouchers ─────────────────────────────────

final adminVouchersProvider = FutureProvider.autoDispose<List<Voucher>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).vouchers();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminVouchersPage extends ConsumerWidget {
  const AdminVouchersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vouchers = ref.watch(adminVouchersProvider);

    return Column(
      children: [
        _Toolbar(
          actionLabel: l10n.adminVoucherNew,
          onAction: () => _edit(context, ref, null),
        ),
        Expanded(
          child: vouchers.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorRetry(
              failure: error is Failure ? error : const Failure.unknown(),
              onRetry: () => ref.invalidate(adminVouchersProvider),
            ),
            data: (items) => AdminDataTable<Voucher>(
              rows: items,
              onRowTap: (voucher) => _edit(context, ref, voucher),
              emptyState: EmptyState(
                title: l10n.emptyTitle,
                icon: Icons.confirmation_num_outlined,
              ),
              columns: [
                AdminColumn(
                  label: l10n.adminVoucherCode,
                  build: (v) => Text(v.code, style: AppText.adminTableHead),
                ),
                AdminColumn(
                  label: l10n.adminOfferType,
                  build: (v) => Text(_voucherTypeLabel(context, v.type), style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.adminOfferValue,
                  width: 100,
                  build: (v) => Text('${v.value}', style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.adminVoucherMinOrder,
                  width: 130,
                  build: (v) => PriceText(Money(v.minOrderCentimes), style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.adminColUses,
                  width: 120,
                  build: (v) => Text(
                    v.maxUses == 0 ? '${v.usedCount}' : '${v.usedCount}/${v.maxUses}',
                    style: AppText.adminTable,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _voucherTypeLabel(BuildContext context, String type) {
    final l10n = context.l10n;
    return switch (type) {
      'fixed' => l10n.adminOfferTypeFixed,
      'freeDelivery' => l10n.adminOfferTypeFreeDelivery,
      _ => l10n.adminOfferTypePercentage,
    };
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Voucher? voucher) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _VoucherDialog(voucher: voucher),
    );
    if (saved ?? false) ref.invalidate(adminVouchersProvider);
  }
}

class _VoucherDialog extends ConsumerStatefulWidget {
  const _VoucherDialog({required this.voucher});

  final Voucher? voucher;

  @override
  ConsumerState<_VoucherDialog> createState() => _VoucherDialogState();
}

class _VoucherDialogState extends ConsumerState<_VoucherDialog> {
  late final _code = TextEditingController(text: widget.voucher?.code ?? '');
  late final _value = TextEditingController(text: '${widget.voucher?.value ?? 10}');
  late final _minOrder = TextEditingController(
    text: Money(widget.voucher?.minOrderCentimes ?? 0).dinars.toStringAsFixed(0),
  );
  late final _maxUses = TextEditingController(text: '${widget.voucher?.maxUses ?? 0}');
  late final _perUser = TextEditingController(text: '${widget.voucher?.perUserLimit ?? 1}');
  late String _type = widget.voucher?.type ?? 'percentage';
  late bool _isActive = widget.voucher?.isActive ?? true;
  bool _saving = false;

  @override
  void dispose() {
    _code.dispose();
    _value.dispose();
    _minOrder.dispose();
    _maxUses.dispose();
    _perUser.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final rawValue = num.tryParse(_value.text.trim()) ?? 0;
    final result = await ref.read(adminRepositoryProvider).saveVoucher(
      {
        'code': _code.text.trim().toUpperCase(),
        'type': _type,
        'value': _type == 'fixed' ? Money.fromDinars(rawValue).centimes : rawValue,
        'minOrderCentimes':
            Money.fromDinars(num.tryParse(_minOrder.text.trim()) ?? 0).centimes,
        'maxUses': int.tryParse(_maxUses.text.trim()) ?? 0,
        'perUserLimit': int.tryParse(_perUser.text.trim()) ?? 1,
        'isActive': _isActive,
      },
      id: widget.voucher?.id,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.adminVoucherNew, style: AppText.adminSubheading),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminField(label: l10n.adminVoucherCode, controller: _code),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: DropdownButtonFormField<String>(
                  initialValue: _type,
                  style: AppText.adminTable,
                  decoration: InputDecoration(labelText: l10n.adminOfferType),
                  items: [
                    DropdownMenuItem(
                      value: 'percentage',
                      child: Text(l10n.adminOfferTypePercentage),
                    ),
                    DropdownMenuItem(value: 'fixed', child: Text(l10n.adminOfferTypeFixed)),
                    DropdownMenuItem(
                      value: 'freeDelivery',
                      child: Text(l10n.adminOfferTypeFreeDelivery),
                    ),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? 'percentage'),
                ),
              ),
              if (_type != 'freeDelivery')
                AdminField(
                  label: l10n.adminOfferValue,
                  controller: _value,
                  keyboardType: TextInputType.number,
                ),
              AdminField(
                label: l10n.adminVoucherMinOrder,
                controller: _minOrder,
                keyboardType: TextInputType.number,
              ),
              AdminField(
                label: l10n.adminVoucherMaxUses,
                controller: _maxUses,
                keyboardType: TextInputType.number,
              ),
              AdminField(
                label: l10n.adminVoucherPerUser,
                controller: _perUser,
                keyboardType: TextInputType.number,
              ),
              AdminSwitchField(
                label: l10n.vendorOpen,
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.voucher != null)
          TextButton(
            onPressed: _saving
                ? null
                : () async {
                    final result = await ref
                        .read(adminRepositoryProvider)
                        .deleteVoucher(widget.voucher!.id);
                    if (!context.mounted) return;
                    if (result.isOk) Navigator.of(context).pop(true);
                  },
            child: Text(
              l10n.commonDelete,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

// ────────────────────────────── categories ────────────────────────────────

final adminCategoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).categories();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminCategoriesPage extends ConsumerWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categories = ref.watch(adminCategoriesProvider);

    return categories.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(adminCategoriesProvider),
      ),
      data: (items) => AdminDataTable<Category>(
        rows: items,
        emptyState: EmptyState(title: l10n.emptyTitle, icon: Icons.category_outlined),
        columns: [
          AdminColumn(
            label: l10n.adminCategories,
            flex: 2,
            minWidth: 160,
            build: (c) => Text(c.nameAr, style: AppText.adminTable),
          ),
          AdminColumn(
            label: 'Français',
            build: (c) => Text(c.nameFr, style: AppText.adminTable),
          ),
          AdminColumn(
            label: l10n.filterSort,
            width: 100,
            build: (c) => Text('${c.sortOrder}', style: AppText.adminTable),
          ),
          AdminColumn(
            label: l10n.adminColStatus,
            width: 110,
            build: (c) => _Badge(
              label: c.isActive ? l10n.commonYes : l10n.commonNo,
              color: c.isActive ? AppColors.primaryGreen : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── helpers ──────────────────────────────────

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.actionLabel, required this.onAction});

  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Spacer(),
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smallBorder,
      ),
      child: Text(
        label,
        style: AppText.badge.copyWith(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
