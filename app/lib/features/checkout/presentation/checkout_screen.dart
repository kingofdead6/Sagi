import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/sticky_bottom_bar.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/cart/presentation/cart_controller.dart';
import 'package:saji/features/checkout/presentation/checkout_controller.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

/// Figma nodes 2601:644 / 2601:898 — address, delivery type, payment, voucher,
/// points, then the server's breakdown and "تاكيد الطلب".
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _voucher = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(checkoutControllerProvider.notifier).refreshQuote(),
    );
  }

  @override
  void dispose() {
    _voucher.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final address = ref.read(defaultAddressProvider);
    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.checkoutNoAddress)),
      );
      return;
    }

    final controller = ref.read(checkoutControllerProvider.notifier)
      ..setNote(_note.text.trim());
    final result = await controller.submit(address.id);
    if (!mounted) return;

    switch (result) {
      case Ok(:final value):
        await ref.read(authControllerProvider.notifier).refreshUser();
        if (!mounted) return;
        context.go(Routes.orderSuccessPath(value.id));
      case Err(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);
    final address = ref.watch(defaultAddressProvider);
    final cart = ref.watch(cartControllerProvider);
    final user = ref.watch(currentUserProvider);
    final quote = state.quote;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.checkoutTitle, style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          AppSpacing.xxl,
        ),
        children: [
          // ── address ────────────────────────────────────────────────────
          _Section(
            title: l10n.checkoutAddress,
            trailing: TextButton(
              onPressed: () => context.push(Routes.addresses),
              child: Text(l10n.checkoutChangeAddress),
            ),
            child: address == null
                ? _Warning(message: l10n.checkoutNoAddress)
                : Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primaryGreen),
                      Gap.wMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address.label, style: AppText.bodyStrong),
                            Text(address.oneLine, style: AppText.meta),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          // ── delivery type ──────────────────────────────────────────────
          _Section(
            title: l10n.checkoutDeliveryType,
            child: Column(
              children: [
                _ChoiceTile(
                  title: l10n.checkoutDeliveryNormal,
                  icon: Icons.delivery_dining_rounded,
                  isSelected: state.deliveryType == DeliveryType.normal,
                  onTap: () => controller.setDeliveryType(DeliveryType.normal),
                ),
                Gap.sm,
                _ChoiceTile(
                  title: l10n.checkoutDeliveryVip,
                  subtitle: l10n.checkoutDeliveryVipHint,
                  icon: Icons.bolt_rounded,
                  isSelected: state.deliveryType == DeliveryType.vip,
                  onTap: () => controller.setDeliveryType(DeliveryType.vip),
                ),
              ],
            ),
          ),

          // ── payment ────────────────────────────────────────────────────
          _Section(
            title: l10n.checkoutPayment,
            child: Column(
              children: [
                _ChoiceTile(
                  title: l10n.checkoutPaymentCash,
                  icon: Icons.payments_rounded,
                  isSelected: state.paymentMethod == PaymentMethod.cash,
                  onTap: () => controller.setPaymentMethod(PaymentMethod.cash),
                ),
                Gap.sm,
                // Electronic payment exists in the enum and the UI but is
                // disabled at v1 — cash only (see DECISIONS.md).
                _ChoiceTile(
                  title: l10n.checkoutPaymentElectronic,
                  subtitle: l10n.checkoutPaymentSoon,
                  icon: Icons.credit_card_rounded,
                  isSelected: false,
                  enabled: false,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ── voucher ────────────────────────────────────────────────────
          _Section(
            title: l10n.checkoutVoucher,
            child: quote?.voucherCode != null
                ? Row(
                    children: [
                      const Icon(Icons.local_offer_rounded, color: AppColors.primaryGreen),
                      Gap.wMd,
                      Expanded(child: Text(quote!.voucherCode!, style: AppText.bodyStrong)),
                      TextButton(
                        onPressed: state.isQuoting ? null : controller.removeVoucher,
                        child: Text(
                          l10n.checkoutVoucherRemove,
                          style: AppText.metaStrong.copyWith(color: AppColors.danger),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _voucher,
                          textCapitalization: TextCapitalization.characters,
                          style: AppText.body,
                          decoration: InputDecoration(
                            hintText: l10n.checkoutVoucherHint,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                      Gap.wSm,
                      TextButton(
                        onPressed: state.isQuoting
                            ? null
                            : () => controller.applyVoucher(_voucher.text),
                        child: Text(l10n.checkoutVoucherApply),
                      ),
                    ],
                  ),
          ),

          // ── points ─────────────────────────────────────────────────────
          if ((user?.points ?? 0) > 0)
            _Section(
              title: l10n.checkoutUsePoints,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkoutPointsBalance(user!.points), style: AppText.meta),
                  Gap.sm,
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: state.pointsToUse.toDouble().clamp(0, user.points.toDouble()),
                          max: user.points.toDouble(),
                          divisions: user.points > 1 ? user.points : null,
                          activeColor: AppColors.primaryGreen,
                          label: '${state.pointsToUse}',
                          onChanged: (value) => controller.setPoints(value.round()),
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        child: Text(
                          '${quote?.pointsUsed ?? state.pointsToUse}',
                          textAlign: TextAlign.center,
                          style: AppText.bodyStrong,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // ── note ───────────────────────────────────────────────────────
          _Section(
            title: l10n.checkoutNote,
            child: TextField(
              controller: _note,
              maxLines: 3,
              maxLength: 400,
              style: AppText.body,
              decoration: InputDecoration(
                hintText: l10n.checkoutNoteHint,
                counterText: '',
                contentPadding: const EdgeInsets.all(AppSpacing.lg),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── breakdown ──────────────────────────────────────────────────
          _Section(
            title: l10n.checkoutSubtotal,
            child: state.isQuoting && quote == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(color: AppColors.primaryGreen),
                    ),
                  )
                : Column(
                    children: [
                      if (quote?.hasWarnings ?? false)
                        for (final warning in quote!.warnings)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _Warning(message: warning),
                          ),
                      _BreakdownRow(
                        label: l10n.checkoutSubtotal,
                        amount: quote?.subtotalCentimes ?? cart.estimatedSubtotal,
                      ),
                      _BreakdownRow(
                        label: l10n.checkoutServiceFee,
                        amount: quote?.serviceFeeCentimes ?? const Money.zero(),
                      ),
                      _BreakdownRow(
                        label: l10n.checkoutDeliveryFee,
                        amount: quote?.deliveryFeeCentimes ?? const Money.zero(),
                      ),
                      if (quote?.hasDiscount ?? false)
                        _BreakdownRow(
                          label: l10n.checkoutDiscount,
                          amount: quote!.discountCentimes,
                          isDiscount: true,
                        ),
                      const Divider(height: AppSpacing.xl),
                      _BreakdownRow(
                        label: l10n.checkoutGrandTotal,
                        amount: quote?.totalCentimes ?? const Money.zero(),
                        emphasise: true,
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: PrimaryButton(
          label: quote == null
              ? l10n.checkoutSubmit
              : '${l10n.checkoutSubmit} · ${quote.totalCentimes.format()}',
          isLoading: state.isSubmitting || state.isQuoting,
          onPressed: state.canSubmit && address != null && cart.isNotEmpty ? _submit : null,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppText.cardTitle)),
              if (trailing != null) trailing!,
            ],
          ),
          Gap.sm,
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardBorder,
              boxShadow: AppShadows.card,
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadius.mediumBorder,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mediumBorder,
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.searchFill,
              width: isSelected ? 1.6 : 1,
            ),
            color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.06) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary),
              Gap.wMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.bodyStrong),
                    if (subtitle != null) Text(subtitle!, style: AppText.meta),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
    this.emphasise = false,
  });

  final String label;
  final Money amount;
  final bool isDiscount;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasise ? AppText.bodyStrong : AppText.meta),
          PriceText(
            amount,
            style: emphasise ? AppText.cardTitle : AppText.metaStrong,
            color: isDiscount
                ? AppColors.primaryGreen
                : (emphasise ? AppColors.primaryGreen : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: AppRadius.smallBorder,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.warning),
          Gap.wSm,
          Expanded(child: Text(message, style: AppText.meta)),
        ],
      ),
    );
  }
}
