import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/result.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/admin/presentation/pages/admin_catalog_pages.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// The vendor editor drawer: details, fees, opening state, and a map picker
/// for the pickup point the assign flow measures distances from.
class AdminVendorForm extends ConsumerStatefulWidget {
  const AdminVendorForm({super.key, this.vendorId});

  final String? vendorId;

  @override
  ConsumerState<AdminVendorForm> createState() => _AdminVendorFormState();
}

class _AdminVendorFormState extends ConsumerState<AdminVendorForm> {
  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _description = TextEditingController();
  final _phone = TextEditingController();
  final _addressText = TextEditingController();
  final _deliveryFee = TextEditingController(text: '150');
  final _minOrder = TextEditingController(text: '0');
  final _prepMin = TextEditingController(text: '15');
  final _prepMax = TextEditingController(text: '30');

  String? _categoryId;
  LatLng _location = LocationService.fallbackCenter;
  bool _isOpen = true;
  bool _isFeatured = false;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _slug,
      _description,
      _phone,
      _addressText,
      _deliveryFee,
      _minOrder,
      _prepMin,
      _prepMax,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _hydrate(Vendor vendor) {
    if (_loaded) return;
    _loaded = true;
    _name.text = vendor.name;
    _slug.text = vendor.slug;
    _description.text = vendor.description ?? '';
    _phone.text = vendor.phone;
    _addressText.text = vendor.addressText;
    _deliveryFee.text = vendor.deliveryFeeCentimes.dinars.toStringAsFixed(0);
    _minOrder.text = vendor.minOrderCentimes.dinars.toStringAsFixed(0);
    _prepMin.text = '${vendor.prepTimeMin}';
    _prepMax.text = '${vendor.prepTimeMax}';
    _categoryId = vendor.category;
    _location = vendor.location ?? LocationService.fallbackCenter;
    _isOpen = vendor.isOpen;
    _isFeatured = vendor.isFeatured;
  }

  void _close() => ref.read(editingVendorIdProvider.notifier).state = null;

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_name.text.trim().isEmpty || _slug.text.trim().isEmpty || _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorValidation)),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(adminRepositoryProvider).saveVendor(
      {
        'name': _name.text.trim(),
        'slug': _slug.text.trim().toLowerCase(),
        if (_description.text.trim().isNotEmpty) 'description': _description.text.trim(),
        'category': _categoryId,
        'phone': _phone.text.trim(),
        'addressText': _addressText.text.trim(),
        'lat': _location.latitude,
        'lng': _location.longitude,
        // Fees are entered in dinars and stored in centimes.
        'deliveryFeeCentimes':
            Money.fromDinars(num.tryParse(_deliveryFee.text.trim()) ?? 0).centimes,
        'minOrderCentimes': Money.fromDinars(num.tryParse(_minOrder.text.trim()) ?? 0).centimes,
        'prepTimeMin': int.tryParse(_prepMin.text.trim()) ?? 15,
        'prepTimeMax': int.tryParse(_prepMax.text.trim()) ?? 30,
        'isOpen': _isOpen,
        'isFeatured': _isFeatured,
      },
      id: widget.vendorId,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        ref.invalidate(adminVendorsProvider);
        _close();
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(adminCategoriesProvider).valueOrNull ?? const <Category>[];
    final vendors = ref.watch(adminVendorsProvider).valueOrNull;

    if (widget.vendorId != null && vendors != null) {
      final existing = vendors.items.where((v) => v.id == widget.vendorId).firstOrNull;
      if (existing != null) _hydrate(existing);
    }

    return AdminDrawer(
      title: widget.vendorId == null ? l10n.adminVendorNew : l10n.adminVendorEdit,
      onClose: _close,
      width: 520,
      actions: Row(
        children: [
          Expanded(
            child: OutlinedButton(onPressed: _close, child: Text(l10n.commonCancel)),
          ),
          Gap.wMd,
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.commonSave),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminField(label: l10n.adminVendorName, controller: _name),
            AdminField(
              label: l10n.adminVendorSlug,
              controller: _slug,
              hint: 'el-assala',
            ),
            AdminField(
              label: l10n.adminVendorDescription,
              controller: _description,
              maxLines: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: DropdownButtonFormField<String?>(
                initialValue: _categoryId,
                style: AppText.adminTable,
                decoration: InputDecoration(labelText: l10n.filterCategory),
                items: [
                  for (final category in categories)
                    DropdownMenuItem(value: category.id, child: Text(category.nameAr)),
                ],
                onChanged: (value) => setState(() => _categoryId = value),
              ),
            ),
            AdminField(
              label: l10n.adminVendorPhone,
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),
            AdminField(label: l10n.adminVendorAddress, controller: _addressText),

            Text(l10n.adminVendorLocation, style: AppText.adminTableHead),
            Gap.sm,
            ClipRRect(
              borderRadius: AppRadius.smallBorder,
              child: SizedBox(
                height: 200,
                child: SajiMap(
                  center: _location,
                  zoom: 14,
                  onTap: (point) => setState(() => _location = point),
                  pins: [
                    MapPin(
                      point: _location,
                      icon: Icons.storefront_rounded,
                      color: AppColors.adminAccent,
                    ),
                  ],
                ),
              ),
            ),
            Gap.lg,

            Text(l10n.adminVendorFees, style: AppText.adminTableHead),
            Gap.sm,
            Row(
              children: [
                Expanded(
                  child: AdminField(
                    label: l10n.checkoutDeliveryFee,
                    controller: _deliveryFee,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Gap.wMd,
                Expanded(
                  child: AdminField(
                    label: l10n.adminVoucherMinOrder,
                    controller: _minOrder,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AdminField(
                    label: l10n.adminVendorPrepTime,
                    controller: _prepMin,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Gap.wMd,
                Expanded(
                  child: AdminField(
                    label: l10n.adminVendorPrepTime,
                    controller: _prepMax,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            AdminSwitchField(
              label: l10n.adminVendorIsOpen,
              value: _isOpen,
              onChanged: (value) => setState(() => _isOpen = value),
            ),
            AdminSwitchField(
              label: l10n.adminVendorFeatured,
              value: _isFeatured,
              onChanged: (value) => setState(() => _isFeatured = value),
            ),
          ],
        ),
      ),
    );
  }
}
