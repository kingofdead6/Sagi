import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';

/// Every `Setting` key the platform reads, editable in one form. Money fields
/// are shown in dinars and written back as centimes.
class AdminSettingsPage extends ConsumerStatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  ConsumerState<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends ConsumerState<AdminSettingsPage> {
  final _serviceFee = TextEditingController();
  final _vipSurcharge = TextEditingController();
  final _assignTimeout = TextEditingController();
  final _lateThreshold = TextEditingController();
  final _supportPhone = TextEditingController();
  final _deliveryRadius = TextEditingController();
  final _pointsPerHundred = TextEditingController();
  final _pointValue = TextEditingController();
  final _maxPointsPercent = TextEditingController();
  final _minVendorFee = TextEditingController();
  final _maxVendorFee = TextEditingController();

  bool _electronicPayment = false;
  bool _loaded = false;
  bool _boundsLoaded = false;
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [
      _serviceFee,
      _vipSurcharge,
      _assignTimeout,
      _lateThreshold,
      _supportPhone,
      _deliveryRadius,
      _pointsPerHundred,
      _pointValue,
      _maxPointsPercent,
      _minVendorFee,
      _maxVendorFee,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// The vendor fee bounds are not on [PlatformSettings]; they come from the
  /// raw settings map and land whenever that provider resolves.
  void _hydrateBounds(Map<String, dynamic> raw) {
    if (_boundsLoaded) return;
    _boundsLoaded = true;
    _minVendorFee.text =
        Money.fromJson(raw['minVendorDeliveryFeeCentimes']).dinars.toStringAsFixed(0);
    _maxVendorFee.text =
        Money.fromJson(raw['maxVendorDeliveryFeeCentimes']).dinars.toStringAsFixed(0);
  }

  void _hydrate(PlatformSettings settings) {
    if (_loaded) return;
    _loaded = true;
    _serviceFee.text = Money(settings.serviceFeeCentimes).dinars.toStringAsFixed(0);
    _vipSurcharge.text = Money(settings.vipSurchargeCentimes).dinars.toStringAsFixed(0);
    _assignTimeout.text = '${settings.assignTimeoutSec}';
    _lateThreshold.text = '${settings.lateThresholdMin}';
    _supportPhone.text = settings.supportPhone;
    _deliveryRadius.text = '${settings.deliveryRadiusKm}';
    _pointsPerHundred.text = '${settings.pointsPerHundredDinars}';
    _pointValue.text = '${settings.pointValueCentimes}';
    _maxPointsPercent.text = '${settings.maxPointsPercentOfSubtotal}';
    _electronicPayment = settings.electronicPaymentEnabled;
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final result = await ref.read(adminRepositoryProvider).updateSettings({
      'serviceFeeCentimes':
          Money.fromDinars(num.tryParse(_serviceFee.text.trim()) ?? 0).centimes,
      'vipSurchargeCentimes':
          Money.fromDinars(num.tryParse(_vipSurcharge.text.trim()) ?? 0).centimes,
      'assignTimeoutSec': int.tryParse(_assignTimeout.text.trim()) ?? 60,
      'lateThresholdMin': int.tryParse(_lateThreshold.text.trim()) ?? 45,
      'supportPhone': _supportPhone.text.trim(),
      'deliveryRadiusKm': num.tryParse(_deliveryRadius.text.trim()) ?? 15,
      'pointsPerHundredDinars': num.tryParse(_pointsPerHundred.text.trim()) ?? 1,
      'pointValueCentimes': int.tryParse(_pointValue.text.trim()) ?? 100,
      'maxPointsPercentOfSubtotal': num.tryParse(_maxPointsPercent.text.trim()) ?? 50,
      'electronicPaymentEnabled': _electronicPayment,
      'minVendorDeliveryFeeCentimes':
          Money.fromDinars(num.tryParse(_minVendorFee.text.trim()) ?? 0).centimes,
      'maxVendorDeliveryFeeCentimes':
          Money.fromDinars(num.tryParse(_maxVendorFee.text.trim()) ?? 0).centimes,
    });

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        ref
          ..invalidate(adminSettingsProvider)
          ..invalidate(adminSettingsRawProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.settingsSaved)),
        );
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(adminSettingsProvider);

    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(adminSettingsProvider),
      ),
      data: (data) {
        _hydrate(data);
        final raw = ref.watch(adminSettingsRawProvider).valueOrNull;
        if (raw != null) _hydrateBounds(raw);

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.adminVendorFees, style: AppText.adminSubheading),
                  Gap.md,
                  AdminField(
                    label: l10n.settingsServiceFee,
                    controller: _serviceFee,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsVipSurcharge,
                    controller: _vipSurcharge,
                    keyboardType: TextInputType.number,
                  ),
                  // The window a shop may set its own delivery fee within.
                  AdminField(
                    label: l10n.settingsMinVendorFee,
                    controller: _minVendorFee,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsMaxVendorFee,
                    controller: _maxVendorFee,
                    keyboardType: TextInputType.number,
                  ),
                  Gap.lg,

                  Text(l10n.adminOrders, style: AppText.adminSubheading),
                  Gap.md,
                  AdminField(
                    label: l10n.settingsAssignTimeout,
                    controller: _assignTimeout,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsLateThreshold,
                    controller: _lateThreshold,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsDeliveryRadius,
                    controller: _deliveryRadius,
                    keyboardType: TextInputType.number,
                  ),
                  Gap.lg,

                  Text(l10n.profileMyPoints, style: AppText.adminSubheading),
                  Gap.md,
                  AdminField(
                    label: l10n.settingsPointsPerHundred,
                    controller: _pointsPerHundred,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsPointValue,
                    controller: _pointValue,
                    keyboardType: TextInputType.number,
                  ),
                  AdminField(
                    label: l10n.settingsMaxPointsPercent,
                    controller: _maxPointsPercent,
                    keyboardType: TextInputType.number,
                  ),
                  Gap.lg,

                  Text(l10n.profileSupport, style: AppText.adminSubheading),
                  Gap.md,
                  AdminField(
                    label: l10n.settingsSupportPhone,
                    controller: _supportPhone,
                    keyboardType: TextInputType.phone,
                  ),
                  AdminSwitchField(
                    label: l10n.settingsElectronicPayment,
                    value: _electronicPayment,
                    onChanged: (value) => setState(() => _electronicPayment = value),
                  ),
                  Gap.xl,

                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.commonSave),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
