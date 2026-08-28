import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/features/agent/domain/agent_models.dart';

/// A delivery offer with its live countdown. When the timer reaches zero the
/// card calls [onExpired] — the server has already returned the order to the
/// pool by then, so the UI must stop offering it.
class OfferCard extends StatefulWidget {
  const OfferCard({
    required this.offer,
    required this.onAccept,
    required this.onReject,
    required this.onExpired,
    super.key,
    this.isBusy = false,
  });

  final DeliveryOffer offer;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onExpired;
  final bool isBusy;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  Timer? _timer;
  late Duration _remaining = widget.offer.remaining;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = widget.offer.remaining;
      setState(() => _remaining = next);
      if (next == Duration.zero) {
        _timer?.cancel();
        widget.onExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final order = widget.offer.order;
    final total = widget.offer.timeoutSec;
    final progress = total == 0 ? 0.0 : (_remaining.inSeconds / total).clamp(0.0, 1.0);
    final urgent = _remaining.inSeconds <= 15;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.agentNewOffer, style: AppText.cardTitle)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (urgent ? AppColors.danger : AppColors.primaryGreen)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.stadium),
                ),
                child: Text(
                  l10n.agentOfferExpires(_remaining.inSeconds),
                  style: AppText.badge.copyWith(
                    color: urgent ? AppColors.danger : AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          Gap.sm,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.stadium),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.searchFill,
              valueColor: AlwaysStoppedAnimation(
                urgent ? AppColors.danger : AppColors.primaryGreen,
              ),
            ),
          ),
          Gap.lg,

          _Waypoint(
            icon: Icons.storefront_rounded,
            color: AppColors.primaryGreenDeep,
            title: widget.offer.pickup?.name ?? order.vendor?.name ?? '',
            subtitle: widget.offer.pickup?.address ?? '',
            label: l10n.agentPickup,
          ),
          Gap.sm,
          _Waypoint(
            icon: Icons.home_rounded,
            color: AppColors.primaryGreen,
            title: order.address.label,
            subtitle: widget.offer.dropoff?.address ?? order.address.oneLine,
            label: l10n.agentDropoff,
          ),
          Gap.lg,

          Row(
            children: [
              if (widget.offer.distanceKm != null)
                Expanded(
                  child: _Metric(
                    label: l10n.agentDistance,
                    value: l10n.vendorKm(widget.offer.distanceKm!.toStringAsFixed(1)),
                  ),
                ),
              Expanded(
                child: _Metric(
                  label: l10n.agentPayout,
                  value: widget.offer.payoutCentimes.format(),
                  highlight: true,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: l10n.cartTotal,
                  value: order.totalCentimes.format(),
                ),
              ),
            ],
          ),
          Gap.lg,

          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l10n.agentReject,
                  icon: Icons.close_rounded,
                  color: AppColors.danger,
                  onPressed: widget.isBusy ? null : widget.onReject,
                ),
              ),
              Gap.wMd,
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: l10n.agentAccept,
                  icon: Icons.check_rounded,
                  isLoading: widget.isBusy,
                  height: 48,
                  onPressed: widget.onAccept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Waypoint extends StatelessWidget {
  const _Waypoint({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: color),
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
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.badge.copyWith(color: AppColors.textMuted)),
        Text(
          value,
          style: AppText.bodyStrong.copyWith(
            color: highlight ? AppColors.primaryGreen : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
