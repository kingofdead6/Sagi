import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

/// Edits one saved address, including moving its pin on the map.
class AddressEditScreen extends ConsumerStatefulWidget {
  const AddressEditScreen({super.key, this.addressId});

  final String? addressId;

  @override
  ConsumerState<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends ConsumerState<AddressEditScreen> {
  final _mapController = MapController();
  final _label = TextEditingController();
  final _wilaya = TextEditingController();
  final _commune = TextEditingController();
  final _street = TextEditingController();
  final _notes = TextEditingController();

  LatLng? _point;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _label.dispose();
    _wilaya.dispose();
    _commune.dispose();
    _street.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (widget.addressId == null || _point == null) return;
    setState(() => _saving = true);

    final result = await ref.read(addressesControllerProvider.notifier).update(
          widget.addressId!,
          label: _label.text.trim(),
          wilaya: _wilaya.text.trim(),
          commune: _commune.text.trim(),
          street: _street.text.trim(),
          notes: _notes.text.trim(),
          location: _point,
        );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        context.pop();
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final addresses = ref.watch(addressesControllerProvider).valueOrNull ?? const [];
    final address = widget.addressId == null
        ? null
        : addresses.where((a) => a.id == widget.addressId).firstOrNull;

    if (address == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(l10n.addressEdit, style: AppText.header),
        ),
        body: EmptyState(title: l10n.errorNotFound, icon: Icons.location_off_outlined),
      );
    }

    if (!_loaded) {
      _loaded = true;
      _label.text = address.label;
      _wilaya.text = address.wilaya;
      _commune.text = address.commune;
      _street.text = address.street;
      _notes.text = address.notes ?? '';
      _point = address.location ?? LocationService.fallbackCenter;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.addressEdit, style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          ClipRRect(
            borderRadius: AppRadius.cardBorder,
            child: SizedBox(
              height: 200,
              child: SajiMap(
                controller: _mapController,
                center: _point!,
                zoom: 15,
                onTap: (point) => setState(() => _point = point),
                pins: [
                  MapPin(
                    point: _point!,
                    icon: Icons.location_on_rounded,
                    color: AppColors.primaryGreen,
                  ),
                ],
              ),
            ),
          ),
          Gap.lg,
          _Field(controller: _label, label: l10n.addressLabel),
          Gap.md,
          Row(
            children: [
              Expanded(child: _Field(controller: _wilaya, label: l10n.addressWilaya)),
              Gap.wMd,
              Expanded(child: _Field(controller: _commune, label: l10n.addressCommune)),
            ],
          ),
          Gap.md,
          _Field(controller: _street, label: l10n.addressStreet),
          Gap.md,
          _Field(controller: _notes, label: l10n.addressNotes, maxLines: 2),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: l10n.commonSave,
          isLoading: _saving,
          onPressed: _save,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label, this.maxLines = 1});

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppText.body,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
