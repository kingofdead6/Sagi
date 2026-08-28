import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/checkout/presentation/checkout_controller.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/features/orders/presentation/orders_controller.dart';
import 'package:saji/features/orders/presentation/rating_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

/// Live tracking: the status stepper renders from `order.events` — never from a
/// guess — and the courier's marker appears once the order is `on_the_way`.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final order = ref.watch(orderDetailProvider(orderId));
    final agentPosition = ref.watch(agentTrackingProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.ordersDetails, style: AppText.header),
      ),
      body: order.when(
        loading: () => const AppSkeletonList(itemHeight: 120, count: 4),
        error: (error, _) => ErrorRetry(
          failure: error is Failure ? error : const Failure.unknown(),
          onRetry: () => ref.invalidate(orderDetailProvider(orderId)),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.lg,
            AppSpacing.screenH,
            AppSpacing.xxl,
          ),
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(data.code, style: AppText.cardTitle)),
                      StatusChip(data.status, isLate: data.isLate),
                    ],
                  ),
                  Gap.xs,
                  Text(data.vendor?.name ?? '', style: AppText.meta),
                ],
              ),
            ),
            Gap.md,

            // The live map only appears once a courier is actually carrying it.
            if (data.status.isOnRoad && data.deliveryLocation != null) ...[
              _Card(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: AppRadius.cardBorder,
                  child: SizedBox(
                    height: 220,
                    child: SajiMap(
                      center: agentPosition ?? data.deliveryLocation!,
                      zoom: 14,
                      pins: [
                        MapPin(
                          point: data.deliveryLocation!,
                          icon: Icons.home_rounded,
                          color: AppColors.primaryGreenDeep,
                          label: data.address.label,
                        ),
                        if (agentPosition != null)
                          MapPin(
                            point: agentPosition,
                            icon: Icons.delivery_dining_rounded,
                            color: AppColors.primaryGreen,
                            label: data.agent?.fullName,
                          ),
                      ],
                      route: agentPosition == null
                          ? const <LatLng>[]
                          : [agentPosition, data.deliveryLocation!],
                    ),
                  ),
                ),
              ),
              Gap.md,
            ],

            _Card(child: _StatusStepper(order: data)),
            Gap.md,

            if (data.hasAgent)
              _Card(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.searchFill,
                      child: Icon(Icons.person_rounded, color: AppColors.textSecondary),
                    ),
                    Gap.wMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.agent!.fullName, style: AppText.bodyStrong),
                          Text(l10n.ordersAgentOnWay, style: AppText.meta),
                        ],
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => launchUrl(Phone.dialUri(data.agent!.phone)),
                      style: IconButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                      icon: const Icon(Icons.call_rounded, color: Colors.white),
                      tooltip: l10n.ordersCallAgent,
                    ),
                  ],
                ),
              )
            else if (data.status.isActive)
              _Card(child: Text(l10n.ordersNoAgentYet, style: AppText.meta)),
            Gap.md,

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.ordersItems, style: AppText.cardTitle),
                  Gap.sm,
                  for (final item in data.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Row(
                        children: [
                          Text('${item.qty}×', style: AppText.metaStrong),
                          Gap.wSm,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.nameSnapshot, style: AppText.body),
                                if (item.optionsLabel.isNotEmpty)
                                  Text(item.optionsLabel, style: AppText.meta),
                              ],
                            ),
                          ),
                          PriceText(item.lineTotalCentimes, style: AppText.metaStrong),
                        ],
                      ),
                    ),
                  const Divider(height: AppSpacing.xl),
                  _Row(label: l10n.checkoutSubtotal, amount: data.subtotalCentimes),
                  _Row(label: l10n.checkoutServiceFee, amount: data.serviceFeeCentimes),
                  _Row(label: l10n.checkoutDeliveryFee, amount: data.deliveryFeeCentimes),
                  if (data.discountCentimes.isPositive)
                    _Row(label: l10n.checkoutDiscount, amount: data.discountCentimes),
                  const Divider(height: AppSpacing.xl),
                  _Row(
                    label: l10n.checkoutGrandTotal,
                    amount: data.totalCentimes,
                    emphasise: true,
                  ),
                ],
              ),
            ),
            Gap.md,

            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkoutAddress, style: AppText.cardTitle),
                  Gap.sm,
                  Text(data.address.oneLine, style: AppText.body),
                  if (data.address.notes != null && data.address.notes!.isNotEmpty) ...[
                    Gap.xs,
                    Text(data.address.notes!, style: AppText.meta),
                  ],
                  if (data.customerNote != null && data.customerNote!.isNotEmpty) ...[
                    Gap.md,
                    Text(l10n.checkoutNote, style: AppText.bodyStrong),
                    Text(data.customerNote!, style: AppText.meta),
                  ],
                ],
              ),
            ),
            Gap.xl,

            if (data.status.canCustomerCancel)
              PrimaryButton(
                label: l10n.ordersCancel,
                color: AppColors.danger,
                onPressed: () => _cancel(context, ref, data.id),
              ),
            if (data.status == OrderStatus.delivered)
              PrimaryButton(
                label: l10n.ordersRate,
                icon: Icons.star_rounded,
                onPressed: () => showRatingSheet(context, ref, data),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, String id) async {
    final l10n = context.l10n;
    final controller = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.ordersCancelReason, style: AppText.cardTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppText.body,
          decoration: InputDecoration(hintText: l10n.ordersCancelReasonHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    controller.dispose();

    if (reason == null || reason.length < 3 || !context.mounted) return;

    final result = await ref.read(orderRepositoryProvider).cancel(id, reason);
    if (!context.mounted) return;

    switch (result) {
      case Ok():
        ref
          ..invalidate(orderDetailProvider(id))
          ..invalidate(myOrdersProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.ordersCancelled)),
        );
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }
}

/// Renders straight from `order.events` — the audit trail the server keeps.
class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.order});

  final AppOrder order;

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.cancelled) {
      return Row(
        children: [
          const Icon(Icons.cancel_rounded, color: AppColors.danger),
          Gap.wMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.statusCancelled, style: AppText.bodyStrong),
                if (order.cancelledReason != null)
                  Text(order.cancelledReason!, style: AppText.meta),
              ],
            ),
          ),
        ],
      );
    }

    final currentStep = order.status.stepIndex;
    final reachedAt = <OrderStatus, DateTime>{};
    for (final event in order.events) {
      reachedAt.putIfAbsent(event.to, () => event.at);
    }

    return Column(
      children: [
        for (var i = 0; i < OrderStatus.customerSteps.length; i++)
          _StepRow(
            status: OrderStatus.customerSteps[i],
            isDone: i <= currentStep,
            isCurrent: i == currentStep,
            isLast: i == OrderStatus.customerSteps.length - 1,
            at: reachedAt[OrderStatus.customerSteps[i]],
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.status,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
    this.at,
  });

  final OrderStatus status;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;
  final DateTime? at;

  @override
  Widget build(BuildContext context) {
    final color = isDone ? AppColors.primaryGreen : AppColors.dotDivider;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone ? color : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: color.withValues(alpha: 0.4))),
            ],
          ),
          Gap.wMd,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.orderStatusLabel(status),
                    style: isCurrent ? AppText.bodyStrong : AppText.body,
                  ),
                  if (at != null)
                    Text(
                      '${at!.hour.toString().padLeft(2, '0')}:'
                      '${at!.minute.toString().padLeft(2, '0')}',
                      style: AppText.meta,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.amount, this.emphasise = false});

  final String label;
  final Money amount;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasise ? AppText.bodyStrong : AppText.meta),
          PriceText(
            amount,
            style: emphasise ? AppText.bodyStrong : AppText.metaStrong,
            color: emphasise ? AppColors.primaryGreen : AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
