import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/features/agent/presentation/active_delivery_view.dart';
import 'package:saji/features/agent/presentation/agent_controller.dart';
import 'package:saji/features/agent/presentation/agent_history_view.dart';
import 'package:saji/features/agent/presentation/offer_card.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';

/// The courier's whole app: online toggle in the bar, then offers, the active
/// delivery, and history in three tabs.
class AgentHomeScreen extends ConsumerWidget {
  const AgentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(agentControllerProvider);
    final controller = ref.read(agentControllerProvider.notifier);
    final user = ref.watch(currentUserProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.fullName ?? l10n.agentTitle, style: AppText.header),
              Text(
                state.isOnline ? l10n.agentOnline : l10n.agentOffline,
                style: AppText.meta.copyWith(
                  color: state.isOnline ? AppColors.primaryGreen : AppColors.textMuted,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Switch(
                value: state.isOnline,
                activeTrackColor: AppColors.primaryGreen,
                onChanged: state.isBusy
                    ? null
                    : (value) => controller.toggleOnline(isOnline: value),
              ),
            ),
            IconButton(
              tooltip: l10n.authLogout,
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryGreen,
            labelStyle: AppText.metaStrong,
            tabs: [
              Tab(text: '${l10n.agentNewOffer} (${state.offers.length})'),
              Tab(text: l10n.agentActiveDelivery),
              Tab(text: l10n.agentHistory),
            ],
          ),
        ),
        body: Column(
          children: [
            if (!state.isOnline)
              _Banner(
                icon: Icons.power_settings_new_rounded,
                message: l10n.agentOfflineHint,
                color: AppColors.warning,
              ),
            if (state.locationDenied && state.isOnline)
              _Banner(
                icon: Icons.location_off_rounded,
                message: l10n.locationPermissionDenied,
                color: AppColors.danger,
              ),
            if (state.isOnline && !state.locationDenied)
              _Banner(
                icon: Icons.my_location_rounded,
                message: l10n.agentLocationRunning,
                color: AppColors.primaryGreen,
              ),

            Expanded(
              child: TabBarView(
                children: [
                  const _OffersTab(),
                  if (state.active == null)
                    EmptyState(
                      title: l10n.agentNoActiveDelivery,
                      icon: Icons.local_shipping_outlined,
                      message: state.isOnline ? null : l10n.agentOfflineHint,
                    )
                  else
                    ActiveDeliveryView(delivery: state.active!),
                  const AgentHistoryView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OffersTab extends ConsumerWidget {
  const _OffersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(agentControllerProvider);
    final controller = ref.read(agentControllerProvider.notifier);

    if (state.offers.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: controller.refreshOffers,
        child: Stack(
          children: [
            ListView(), // keeps pull-to-refresh usable on an empty list
            EmptyState(
              title: l10n.agentNoOffers,
              icon: Icons.inbox_outlined,
              message: state.isOnline ? null : l10n.agentOfflineHint,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: controller.refreshOffers,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        itemCount: state.offers.length,
        separatorBuilder: (_, __) => Gap.lg,
        itemBuilder: (context, index) {
          final offer = state.offers[index];
          return OfferCard(
            key: ValueKey(offer.assignmentId),
            offer: offer,
            isBusy: state.isBusy,
            onExpired: controller.refreshOffers,
            onAccept: () async {
              final result = await controller.accept(offer.order.id);
              if (!context.mounted) return;
              if (result case Err(:final failure)) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
              } else {
                DefaultTabController.of(context).animateTo(1);
              }
            },
            onReject: () => _pickRejectReason(context, ref, offer.order.id),
          );
        },
      ),
    );
  }

  Future<void> _pickRejectReason(BuildContext context, WidgetRef ref, String orderId) async {
    final l10n = context.l10n;
    final reasons = [
      l10n.agentRejectTooFar,
      l10n.agentRejectBusy,
      l10n.agentRejectVehicle,
      l10n.agentRejectOther,
    ];

    final reason = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap.lg,
            Text(l10n.agentRejectReason, style: AppText.cardTitle),
            Gap.md,
            for (final item in reasons)
              ListTile(
                title: Text(item, style: AppText.body),
                onTap: () => Navigator.of(context).pop(item),
              ),
            Gap.lg,
          ],
        ),
      ),
    );

    if (reason == null || !context.mounted) return;
    final result = await ref.read(agentControllerProvider.notifier).reject(orderId, reason);
    if (!context.mounted) return;
    if (result case Err(:final failure)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));
    }
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.message, required this.color});

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          Gap.wSm,
          Expanded(child: Text(message, style: AppText.meta)),
        ],
      ),
    );
  }
}
