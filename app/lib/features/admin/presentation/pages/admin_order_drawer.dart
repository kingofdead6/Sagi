import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/text_input_dialog.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:url_launcher/url_launcher.dart';

/// Figma node 2601:1178 (right drawer) — customer info with a one-click call,
/// delivery info, items, the customer's note, and the §6 action buttons.
class AdminOrderDrawer extends ConsumerWidget {
  const AdminOrderDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final order = ref.watch(selectedOrderProvider);

    void close() => ref.read(selectedOrderIdProvider.notifier).state = null;

    return AdminDrawer(
      title: order.valueOrNull?.code ?? l10n.ordersDetails,
      onClose: close,
      actions: order.valueOrNull == null
          ? null
          : _OrderActions(order: order.valueOrNull!, onDone: close),
      child: order.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => ErrorRetry(
          failure: error is Failure ? error : const Failure.unknown(),
          onRetry: () => ref.invalidate(selectedOrderProvider),
        ),
        data: (data) {
          if (data == null) return const SizedBox.shrink();
          return _OrderBody(order: data);
        },
      ),
    );
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.order});

  final AppOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(order.status, isLate: order.isLate),
              Gap.wSm,
              if (order.deliveryType.isVip)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: AppRadius.smallBorder,
                  ),
                  child: Text(
                    l10n.checkoutDeliveryVip,
                    style: AppText.badge.copyWith(color: AppColors.warning),
                  ),
                ),
            ],
          ),
          Gap.lg,

          _Block(
            title: l10n.adminCustomerInfo,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customer?.fullName ?? '', style: AppText.adminTable),
                      Text(
                        Phone.pretty(order.customer?.phone),
                        style: AppText.adminNav,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                if (order.customer?.phone.isNotEmpty ?? false)
                  FilledButton.icon(
                    onPressed: () => launchUrl(Phone.dialUri(order.customer!.phone)),
                    icon: const Icon(Icons.call_rounded, size: 18),
                    label: Text(l10n.adminCallCustomer),
                  ),
              ],
            ),
          ),

          _Block(
            title: l10n.adminDeliveryInfo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line(label: l10n.checkoutAddress, value: order.address.oneLine),
                if (order.address.notes?.isNotEmpty ?? false)
                  _Line(label: l10n.addressNotes, value: order.address.notes!),
                _Line(
                  label: l10n.adminVendors,
                  value: order.vendor?.name ?? '—',
                  trailing: (order.vendor?.phone.isNotEmpty ?? false)
                      ? IconButton(
                          tooltip: l10n.adminCallVendor,
                          onPressed: () => launchUrl(Phone.dialUri(order.vendor!.phone)),
                          icon: const Icon(Icons.call_rounded, size: 18),
                        )
                      : null,
                ),
                _Line(
                  label: l10n.adminAgents,
                  value: order.agent?.fullName ?? l10n.ordersNoAgentYet,
                  trailing: (order.agent?.phone.isNotEmpty ?? false)
                      ? IconButton(
                          tooltip: l10n.ordersCallAgent,
                          onPressed: () => launchUrl(Phone.dialUri(order.agent!.phone)),
                          icon: const Icon(Icons.call_rounded, size: 18),
                        )
                      : null,
                ),
                _Line(
                  label: l10n.checkoutPayment,
                  value: order.paymentMethod == PaymentMethod.cash
                      ? l10n.checkoutPaymentCash
                      : l10n.checkoutPaymentElectronic,
                ),
              ],
            ),
          ),

          _Block(
            title: l10n.ordersItems,
            child: Column(
              children: [
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        Text('${item.qty}×', style: AppText.adminTableHead),
                        Gap.wSm,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.nameSnapshot, style: AppText.adminTable),
                              if (item.optionsLabel.isNotEmpty)
                                Text(
                                  item.optionsLabel,
                                  style: AppText.adminNav.copyWith(color: AppColors.textMuted),
                                ),
                            ],
                          ),
                        ),
                        PriceText(item.lineTotalCentimes, style: AppText.adminTable),
                      ],
                    ),
                  ),
                const Divider(height: AppSpacing.xl),
                _Money(label: l10n.checkoutSubtotal, amount: order.subtotalCentimes),
                _Money(label: l10n.checkoutServiceFee, amount: order.serviceFeeCentimes),
                _Money(label: l10n.checkoutDeliveryFee, amount: order.deliveryFeeCentimes),
                if (order.discountCentimes.isPositive)
                  _Money(label: l10n.checkoutDiscount, amount: order.discountCentimes),
                const Divider(height: AppSpacing.xl),
                _Money(
                  label: l10n.checkoutGrandTotal,
                  amount: order.totalCentimes,
                  emphasise: true,
                ),
              ],
            ),
          ),

          if (order.customerNote?.isNotEmpty ?? false)
            _Block(
              title: l10n.adminCustomerNote,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smallBorder,
                ),
                child: Text(order.customerNote!, style: AppText.adminTable),
              ),
            ),

          _Block(
            title: l10n.ordersHistory,
            child: Column(
              children: [
                for (final event in order.timeline)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: AppColors.adminAccent),
                        Gap.wSm,
                        Expanded(
                          child: Text(
                            context.orderStatusLabel(event.to),
                            style: AppText.adminTable,
                          ),
                        ),
                        Text(
                          '${event.at.hour.toString().padLeft(2, '0')}:'
                          '${event.at.minute.toString().padLeft(2, '0')}',
                          style: AppText.adminNav.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The §6 buttons for this order's current status, and only those.
class _OrderActions extends ConsumerStatefulWidget {
  const _OrderActions({required this.order, required this.onDone});

  final AppOrder order;
  final VoidCallback onDone;

  @override
  ConsumerState<_OrderActions> createState() => _OrderActionsState();
}

class _OrderActionsState extends ConsumerState<_OrderActions> {
  bool _busy = false;

  Future<void> _advance(String status, {String? note}) async {
    setState(() => _busy = true);
    final result = await ref
        .read(adminRepositoryProvider)
        .setStatus(widget.order.id, status, note: note);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case Ok():
        ref
          ..invalidate(selectedOrderProvider)
          ..invalidate(adminOrdersProvider)
          ..invalidate(adminStatsProvider);
      case Err(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }

  Future<void> _cancel() async {
    final l10n = context.l10n;
    final reason = await showSingleTextInputDialog(
      context: context,
      title: l10n.adminCancelReason,
      titleStyle: AppText.adminSubheading,
      label: l10n.adminCancelReason,
      confirmLabel: l10n.commonConfirm,
      danger: true,
    );

    if (reason != null && reason.length >= 3) {
      await _advance('cancelled', note: reason);
    }
  }

  Future<void> _assign() async {
    final selected = await showDialog<AvailableAgent>(
      context: context,
      builder: (context) => _AssignDialog(vendorId: widget.order.vendor?.id),
    );
    if (selected == null || !mounted) return;

    setState(() => _busy = true);
    final result = await ref
        .read(adminRepositoryProvider)
        .assign(widget.order.id, selected.agentId);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case Ok():
        ref
          ..invalidate(selectedOrderProvider)
          ..invalidate(adminOrdersProvider);
      case Err(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Only the transitions the state machine actually allows from here.
    final primary = switch (widget.order.status) {
      OrderStatus.pending => (l10n.adminConfirmOrder, () => _advance('confirmed')),
      OrderStatus.confirmed => (l10n.adminSendToVendor, () => _advance('sent_to_vendor')),
      OrderStatus.sentToVendor => (l10n.adminMarkPreparing, () => _advance('preparing')),
      OrderStatus.preparing => (l10n.adminMarkReady, () => _advance('ready')),
      OrderStatus.ready => (l10n.adminAssignAgent, _assign),
      _ => null,
    };

    if (widget.order.status.isTerminal) {
      return Text(
        context.orderStatusLabel(widget.order.status),
        style: AppText.adminTable,
        textAlign: TextAlign.center,
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _busy ? null : _cancel,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: Text(l10n.adminCancelOrder),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              minimumSize: const Size(0, 44),
            ),
          ),
        ),
        if (primary != null) ...[
          Gap.wMd,
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _busy ? null : primary.$2,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(primary.$1),
            ),
          ),
        ],
      ],
    );
  }
}

/// Online agents sorted by distance to the vendor, with their current load.
class _AssignDialog extends ConsumerWidget {
  const _AssignDialog({this.vendorId});

  final String? vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final agents = ref.watch(availableAgentsProvider(vendorId));

    return AlertDialog(
      title: Text(l10n.adminAssignTitle, style: AppText.adminSubheading),
      content: SizedBox(
        width: 420,
        child: agents.when(
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => ErrorRetry(
            failure: error is Failure ? error : const Failure.unknown(),
            compact: true,
            onRetry: () => ref.invalidate(availableAgentsProvider(vendorId)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(l10n.adminAssignEmpty, style: AppText.adminTable),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final agent = items[index];
                final busy = agent.currentOrder != null;
                return ListTile(
                  enabled: !busy,
                  leading: CircleAvatar(
                    backgroundColor: busy
                        ? AppColors.searchFill
                        : AppColors.primaryGreen.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.delivery_dining_rounded,
                      color: busy ? AppColors.textMuted : AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                  title: Text(agent.fullName, style: AppText.adminTable),
                  subtitle: Text(
                    [
                      if (agent.distanceKm != null)
                        l10n.vendorKm(agent.distanceKm!.toStringAsFixed(1)),
                      l10n.adminAgentLoad(agent.currentLoad),
                    ].join(' · '),
                    style: AppText.adminNav,
                  ),
                  onTap: busy ? null : () => Navigator.of(context).pop(agent),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.adminTableHead),
          Gap.sm,
          child,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: AppText.adminNav.copyWith(color: AppColors.textMuted),
            ),
          ),
          Expanded(child: Text(value, style: AppText.adminTable)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Money extends StatelessWidget {
  const _Money({required this.label, required this.amount, this.emphasise = false});

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
          Text(label, style: emphasise ? AppText.adminTableHead : AppText.adminNav),
          PriceText(
            amount,
            style: emphasise ? AppText.adminSubheading : AppText.adminTable,
            color: emphasise ? AppColors.adminAccent : AppColors.adminText,
          ),
        ],
      ),
    );
  }
}
