import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_view.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Every online courier on one map, updating over `agent:location`. Idle and
/// on-delivery are different colours; clicking a marker opens its card.
class AdminFleetPage extends ConsumerStatefulWidget {
  const AdminFleetPage({super.key});

  @override
  ConsumerState<AdminFleetPage> createState() => _AdminFleetPageState();
}

class _AdminFleetPageState extends ConsumerState<AdminFleetPage> {
  String? _selectedAgentId;

  /// Below this the agent list cannot sit beside the map, so it becomes a
  /// drawer opened from a floating button.
  static const _listBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _listBreakpoint;
    final l10n = context.l10n;
    final fleet = ref.watch(fleetProvider);

    return fleet.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(fleetProvider),
      ),
      data: (agents) {
        final located = agents.where((a) => a.location != null).toList();
        final selected =
            agents.where((a) => a.agentId == _selectedAgentId).firstOrNull;

        final center = located.isEmpty
            ? LocationService.fallbackCenter
            : located.first.location!;

        final agentList = Container(
          decoration: BoxDecoration(
            color: AppColors.adminSurface,
            border: isWide
                ? const Border(right: BorderSide(color: AppColors.adminBorder))
                : null,
          ),
          child: agents.isEmpty
              ? EmptyState(
                  title: l10n.adminFleetEmpty,
                  icon: Icons.delivery_dining_outlined,
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    for (final agent in agents)
                      _AgentCard(
                        agent: agent,
                        isSelected: agent.agentId == selected?.agentId,
                        onTap: () {
                          setState(() => _selectedAgentId = agent.agentId);
                          // Picking an agent in the drawer should reveal them
                          // on the map, so close it on the way out.
                          if (!isWide) Navigator.of(context).maybePop();
                        },
                      ),
                  ],
                ),
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          endDrawer: isWide ? null : Drawer(child: SafeArea(child: agentList)),
          floatingActionButton: isWide
              ? null
              : Builder(
                  builder: (context) => FloatingActionButton(
                    backgroundColor: AppColors.adminAccent,
                    foregroundColor: Colors.white,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    child: const Icon(Icons.menu_rounded),
                  ),
                ),
          body: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SajiMap(
                      center: center,
                      zoom: 13,
                      pins: [
                        for (final agent in located)
                          MapPin(
                            point: agent.location!,
                            icon: Icons.delivery_dining_rounded,
                            color: agent.isOnDelivery
                                ? AppColors.primaryGreen
                                : AppColors.textMuted,
                            label: agent.fullName,
                            onTap: () => setState(() => _selectedAgentId = agent.agentId),
                          ),
                      ],
                    ),
                    if (agents.isEmpty)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: const BoxDecoration(
                            color: AppColors.adminSurface,
                            borderRadius: AppRadius.smallBorder,
                            boxShadow: AppShadows.card,
                          ),
                          child: Text(l10n.adminFleetEmpty, style: AppText.adminTable),
                        ),
                      ),
                    PositionedDirectional(
                      top: AppSpacing.lg,
                      start: AppSpacing.lg,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.adminSurface,
                          borderRadius: AppRadius.smallBorder,
                          boxShadow: AppShadows.card,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _Legend(color: AppColors.primaryGreen, label: l10n.adminFleetOnDelivery),
                            Gap.wMd,
                            _Legend(color: AppColors.textMuted, label: l10n.adminFleetIdle),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isWide) SizedBox(width: 320, child: agentList),
            ],
          ),
        );
      },
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent, required this.isSelected, required this.onTap});

  final FleetAgent agent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smallBorder,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.adminRowHover : null,
            borderRadius: AppRadius.smallBorder,
            border: Border.all(
              color: isSelected ? AppColors.adminAccent : AppColors.adminBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: agent.isOnDelivery ? AppColors.primaryGreen : AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap.wSm,
                  Expanded(
                    child: Text(
                      agent.fullName,
                      style: AppText.adminTable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (agent.phone.isNotEmpty)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: l10n.commonCall,
                      onPressed: () => launchUrl(Phone.dialUri(agent.phone)),
                      icon: const Icon(Icons.call_rounded, size: 16),
                    ),
                ],
              ),
              Text(
                agent.isOnDelivery ? l10n.adminFleetOnDelivery : l10n.adminFleetIdle,
                style: AppText.adminNav.copyWith(color: AppColors.textMuted),
              ),
              if (agent.currentOrder != null) ...[
                Gap.sm,
                Row(
                  children: [
                    Text(agent.currentOrder!.code, style: AppText.adminTableHead),
                    Gap.wSm,
                    StatusChip(agent.currentOrder!.status, dense: true),
                  ],
                ),
              ],
              if (agent.lastSeenAt != null)
                Text(
                  l10n.adminFleetLastSeen(
                    '${agent.lastSeenAt!.hour.toString().padLeft(2, '0')}:'
                    '${agent.lastSeenAt!.minute.toString().padLeft(2, '0')}',
                  ),
                  style: AppText.adminNav.copyWith(color: AppColors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap.wXs,
        Text(label, style: AppText.adminNav),
      ],
    );
  }
}
