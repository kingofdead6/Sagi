import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/agent/domain/agent_models.dart';
import 'package:saji/features/agent/presentation/agent_controller.dart';
import 'package:saji/features/agent/presentation/swipe_confirm.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:url_launcher/url_launcher.dart';

/// The courier's working screen: map with pickup → dropoff, one-tap calls,
/// hand-off to an external navigator, and the swipe that advances the order.
class ActiveDeliveryView extends ConsumerWidget {
  const ActiveDeliveryView({required this.delivery, super.key});

  final ActiveDelivery delivery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(agentControllerProvider);
    final controller = ref.read(agentControllerProvider.notifier);
    final order = delivery.order;

    final pickup = delivery.pickup?.point;
    final dropoff = delivery.dropoff?.point;
    final position = state.position;

    // Before pickup the courier heads to the vendor; after, to the customer.
    final isBeforePickup = order.status == OrderStatus.accepted;
    final target = isBeforePickup ? pickup : dropoff;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.xxl,
      ),
      children: [
        Row(
          children: [
            Expanded(child: Text(order.code, style: AppText.cardTitle)),
            StatusChip(order.status),
          ],
        ),
        Gap.md,

        if (target != null)
          ClipRRect(
            borderRadius: AppRadius.cardBorder,
            child: SizedBox(
              height: 220,
              child: SajiMap(
                center: position ?? target,
                zoom: 14,
                pins: [
                  if (pickup != null)
                    MapPin(
                      point: pickup,
                      icon: Icons.storefront_rounded,
                      color: AppColors.primaryGreenDeep,
                      label: delivery.pickup?.name,
                    ),
                  if (dropoff != null)
                    MapPin(
                      point: dropoff,
                      icon: Icons.home_rounded,
                      color: AppColors.primaryGreen,
                      label: order.address.label,
                    ),
                  if (position != null)
                    MapPin(
                      point: position,
                      icon: Icons.delivery_dining_rounded,
                      color: AppColors.info,
                    ),
                ],
                route: [
                  if (position != null) position,
                  if (pickup != null && isBeforePickup) pickup,
                  if (dropoff != null && !isBeforePickup) dropoff,
                ].whereType<LatLng>().toList(),
              ),
            ),
          ),
        Gap.md,

        _ContactCard(
          icon: Icons.storefront_rounded,
          title: delivery.pickup?.name ?? order.vendor?.name ?? '',
          subtitle: delivery.pickup?.address ?? '',
          label: l10n.agentPickup,
          phone: delivery.pickup?.phone ?? order.vendor?.phone,
          onNavigate: pickup == null ? null : () => _openNavigation(pickup),
        ),
        Gap.sm,
        _ContactCard(
          icon: Icons.person_rounded,
          title: order.customer?.fullName ?? order.address.label,
          subtitle: order.address.oneLine,
          label: l10n.agentDropoff,
          phone: order.customer?.phone,
          onNavigate: dropoff == null ? null : () => _openNavigation(dropoff),
        ),

        if (order.customerNote != null && order.customerNote!.isNotEmpty) ...[
          Gap.md,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.mediumBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.adminCustomerNote, style: AppText.metaStrong),
                Gap.xs,
                Text(order.customerNote!, style: AppText.body),
              ],
            ),
          ),
        ],

        Gap.md,
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardBorder,
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  order.paymentMethod == PaymentMethod.cash
                      ? l10n.agentCashAmount(order.totalCentimes.format())
                      : l10n.cartTotal,
                  style: AppText.bodyStrong,
                ),
              ),
              PriceText(
                order.totalCentimes,
                style: AppText.cardTitle,
                color: AppColors.primaryGreen,
              ),
            ],
          ),
        ),
        Gap.xl,

        _ActionForStatus(
          status: order.status,
          isBusy: state.isBusy,
          isCash: order.paymentMethod == PaymentMethod.cash,
          onAdvance: (next, {cashCollected}) async {
            final result = await controller.advance(
              order.id,
              next,
              cashCollected: cashCollected,
            );
            if (!context.mounted) return;
            if (result case Err(:final failure)) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
            }
          },
        ),
      ],
    );
  }

  /// Hands off to whatever navigator the phone has (Google Maps, Waze, …).
  Future<void> _openNavigation(LatLng point) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination='
      '${point.latitude},${point.longitude}&travelmode=driving',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ActionForStatus extends StatelessWidget {
  const _ActionForStatus({
    required this.status,
    required this.isBusy,
    required this.isCash,
    required this.onAdvance,
  });

  final OrderStatus status;
  final bool isBusy;
  final bool isCash;
  final Future<void> Function(String next, {bool? cashCollected}) onAdvance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return switch (status) {
      OrderStatus.accepted => SwipeConfirm(
          label: l10n.agentSwipePickedUp,
          isBusy: isBusy,
          onConfirmed: () => onAdvance('picked_up'),
        ),
      OrderStatus.pickedUp => SwipeConfirm(
          label: l10n.agentSwipeOnTheWay,
          isBusy: isBusy,
          onConfirmed: () => onAdvance('on_the_way'),
        ),
      OrderStatus.onTheWay => SwipeConfirm(
          label: l10n.agentSwipeDelivered,
          isBusy: isBusy,
          // Cash orders require the courier to confirm they collected it.
          onConfirmed: () async {
            if (!isCash) {
              await onAdvance('delivered');
              return;
            }
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.surface,
                title: Text(l10n.agentCashCollected, style: AppText.cardTitle),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.commonConfirm),
                  ),
                ],
              ),
            );
            if (confirmed ?? false) await onAdvance('delivered', cashCollected: true);
          },
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.label,
    this.phone,
    this.onNavigate,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String label;
  final String? phone;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.searchFill,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          Gap.wMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.badge.copyWith(color: AppColors.textMuted)),
                Text(title, style: AppText.bodyStrong, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: AppText.meta, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (phone != null && phone!.isNotEmpty)
            IconButton(
              tooltip: l10n.commonCall,
              onPressed: () => launchUrl(Phone.dialUri(phone!)),
              icon: const Icon(Icons.call_rounded, color: AppColors.primaryGreen),
            ),
          if (onNavigate != null)
            IconButton(
              tooltip: l10n.agentNavigate,
              onPressed: onNavigate,
              icon: const Icon(Icons.navigation_rounded, color: AppColors.info),
            ),
        ],
      ),
    );
  }
}
