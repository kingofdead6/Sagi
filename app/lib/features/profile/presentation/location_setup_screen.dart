import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

/// Pick a delivery point: GPS button, draggable pin, and Nominatim reverse
/// geocoding — which fails often in Algeria, so the address fields stay
/// editable and the flow never blocks on it.
class LocationSetupScreen extends ConsumerStatefulWidget {
  const LocationSetupScreen({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  ConsumerState<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends ConsumerState<LocationSetupScreen> {
  final _mapController = MapController();
  final _label = TextEditingController(text: 'المنزل');
  final _wilaya = TextEditingController(text: 'تبسة');
  final _commune = TextEditingController(text: 'بئر العاتر');
  final _street = TextEditingController();
  final _notes = TextEditingController();

  LatLng _picked = LocationService.fallbackCenter;
  bool _locating = false;
  bool _resolving = false;
  bool _saving = false;
  String? _permissionMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _useGps());
  }

  @override
  void dispose() {
    _label.dispose();
    _wilaya.dispose();
    _commune.dispose();
    _street.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _useGps() async {
    setState(() {
      _locating = true;
      _permissionMessage = null;
    });

    final result = await ref.read(locationServiceProvider).current();
    if (!mounted) return;

    if (result.isGranted) {
      setState(() {
        _picked = result.position!;
        _locating = false;
      });
      _mapController.move(_picked, 16);
      await _resolveLabel(_picked);
      return;
    }

    setState(() {
      _locating = false;
      _permissionMessage = switch (result.outcome) {
        LocationOutcome.serviceDisabled => context.l10n.locationServiceDisabled,
        LocationOutcome.deniedForever ||
        LocationOutcome.denied =>
          context.l10n.locationPermissionDenied,
        _ => context.l10n.locationUnknownAddress,
      };
    });
  }

  /// Fills the address fields from the map pin. A miss is normal — the user
  /// simply types the address instead.
  Future<void> _resolveLabel(LatLng point) async {
    setState(() => _resolving = true);
    final result = await ref.read(mapServiceProvider).reverseGeocode(point);
    if (!mounted) return;

    setState(() {
      _resolving = false;
      if (result case Ok(:final value) when value.isResolved) {
        if (value.wilaya != null && value.wilaya!.isNotEmpty) _wilaya.text = value.wilaya!;
        if (value.commune != null && value.commune!.isNotEmpty) _commune.text = value.commune!;
        if (value.street != null && value.street!.isNotEmpty && _street.text.isEmpty) {
          _street.text = value.street!;
        }
      }
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_street.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addressStreet)),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(addressesControllerProvider.notifier).create(
          label: _label.text.trim().isEmpty ? 'المنزل' : _label.text.trim(),
          wilaya: _wilaya.text.trim(),
          commune: _commune.text.trim(),
          street: _street.text.trim(),
          notes: _notes.text.trim(),
          location: _picked,
          isDefault: true,
        );
    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        await ref.read(authControllerProvider.notifier).refreshUser();
        if (!mounted) return;
        widget.isOnboarding ? context.go(Routes.home) : context.pop();
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.locationTitle, style: AppText.header),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            child: Stack(
              children: [
                SajiMap(
                  controller: _mapController,
                  center: _picked,
                  zoom: 15,
                  onTap: (point) {
                    setState(() => _picked = point);
                    _resolveLabel(point);
                  },
                  onPositionChanged: (point) => setState(() => _picked = point),
                  pins: [
                    MapPin(
                      point: _picked,
                      icon: Icons.location_on_rounded,
                      color: AppColors.primaryGreen,
                    ),
                  ],
                ),
                PositionedDirectional(
                  bottom: AppSpacing.lg,
                  end: AppSpacing.lg,
                  child: FloatingActionButton.small(
                    heroTag: 'gps',
                    backgroundColor: AppColors.surface,
                    onPressed: _locating ? null : _useGps,
                    child: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded, color: AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              children: [
                Text(l10n.locationSubtitle, style: AppText.meta),
                if (_permissionMessage != null) ...[
                  Gap.md,
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: AppRadius.mediumBorder,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: AppColors.warning, size: 20),
                        Gap.wSm,
                        Expanded(child: Text(_permissionMessage!, style: AppText.meta)),
                      ],
                    ),
                  ),
                ],
                if (_resolving) ...[
                  Gap.md,
                  Row(
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      Gap.wSm,
                      Text(l10n.locationSearching, style: AppText.meta),
                    ],
                  ),
                ],
                Gap.lg,
                _Field(controller: _label, label: l10n.addressLabel, hint: l10n.addressLabelHint),
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
                _Field(
                  controller: _notes,
                  label: l10n.addressNotes,
                  hint: l10n.addressNotesHint,
                  maxLines: 2,
                ),
                Gap.xxl,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: l10n.locationConfirm,
          isLoading: _saving,
          onPressed: _save,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppText.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
