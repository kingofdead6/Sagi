import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/agent/presentation/agent_controller.dart';
import 'package:saji/features/orders/domain/order.dart';

/// The courier's history filters, so the provider below can react to them.
class HistoryFilters {
  const HistoryFilters({this.from, this.to, this.status});

  final DateTime? from;
  final DateTime? to;
  final String? status;

  HistoryFilters copyWith({DateTime? from, DateTime? to, String? status, bool clear = false}) =>
      clear
          ? const HistoryFilters()
          : HistoryFilters(
              from: from ?? this.from,
              to: to ?? this.to,
              status: status ?? this.status,
            );
}

final historyFiltersProvider =
    StateProvider.autoDispose<HistoryFilters>((ref) => const HistoryFilters());

final agentHistoryProvider =
    FutureProvider.autoDispose<Paged<AppOrder>>((ref) async {
  final filters = ref.watch(historyFiltersProvider);
  final result = await ref.watch(agentControllerProvider.notifier).history(
        from: filters.from,
        to: filters.to,
        status: filters.status,
      );
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AgentHistoryView extends ConsumerWidget {
  const AgentHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final history = ref.watch(agentHistoryProvider);
    final stats = ref.watch(agentControllerProvider).stats;
    final filters = ref.watch(historyFiltersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Row(
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.agentDeliveries,
                  value: '${stats.deliveries}',
                  icon: Icons.local_shipping_rounded,
                ),
              ),
              Gap.wMd,
              Expanded(
                child: _Stat(
                  label: l10n.agentEarnings,
                  value: stats.earningsCentimes.format(),
                  icon: Icons.payments_rounded,
                  highlight: true,
                ),
              ),
              Gap.wMd,
              Expanded(
                child: _Stat(
                  label: l10n.agentAvgTime,
                  value: l10n.vendorMinutes(stats.avgMinutes),
                  icon: Icons.timer_rounded,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            children: [
              _Chip(
                label: l10n.filterAll,
                isActive: filters.status == null && filters.from == null,
                onTap: () =>
                    ref.read(historyFiltersProvider.notifier).state = const HistoryFilters(),
              ),
              Gap.wSm,
              _Chip(
                label: l10n.commonToday,
                isActive: filters.from != null,
                onTap: () {
                  final now = DateTime.now();
                  ref.read(historyFiltersProvider.notifier).state = filters.copyWith(
                    from: DateTime(now.year, now.month, now.day),
                    to: now,
                  );
                },
              ),
              Gap.wSm,
              _Chip(
                label: l10n.statusDelivered,
                isActive: filters.status == 'delivered',
                onTap: () => ref.read(historyFiltersProvider.notifier).state =
                    filters.copyWith(status: 'delivered'),
              ),
              Gap.wSm,
              _Chip(
                label: l10n.statusCancelled,
                isActive: filters.status == 'cancelled',
                onTap: () => ref.read(historyFiltersProvider.notifier).state =
                    filters.copyWith(status: 'cancelled'),
              ),
            ],
          ),
        ),
        Gap.md,

        Expanded(
          child: history.when(
            loading: () => const AppSkeletonList(itemHeight: 88, count: 5),
            error: (error, _) => ErrorRetry(
              failure: error is Failure ? error : const Failure.unknown(),
              onRetry: () => ref.invalidate(agentHistoryProvider),
            ),
            data: (page) {
              if (page.isEmpty) {
                return EmptyState(title: l10n.emptyTitle, icon: Icons.history_rounded);
              }

              return RefreshIndicator(
                color: AppColors.primaryGreen,
                onRefresh: () async => ref.invalidate(agentHistoryProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH,
                    0,
                    AppSpacing.screenH,
                    AppSpacing.xxl,
                  ),
                  itemCount: page.items.length,
                  separatorBuilder: (_, __) => Gap.sm,
                  itemBuilder: (context, index) {
                    final order = page.items[index];
                    return Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.cardBorder,
                        boxShadow: AppShadows.card,
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.code, style: AppText.bodyStrong),
                                Text(
                                  order.vendor?.name ?? '',
                                  style: AppText.meta,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusChip(order.status, dense: true),
                              Gap.xs,
                              PriceText(
                                order.deliveryFeeCentimes,
                                style: AppText.metaStrong,
                                color: AppColors.primaryGreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumBorder,
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: highlight ? AppColors.primaryGreen : AppColors.textSecondary,
          ),
          Gap.xs,
          Text(
            value,
            style: AppText.metaStrong.copyWith(
              color: highlight ? AppColors.primaryGreen : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: AppText.badge.copyWith(color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.stadium),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.stadium),
          boxShadow: AppShadows.card,
        ),
        child: Text(
          label,
          style: AppText.metaStrong.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
