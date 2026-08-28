import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';

/// How far back the analytics tab looks.
final analyticsRangeProvider = StateProvider<int>((ref) => 30);

({DateTime from, DateTime to}) _range(int days) {
  final to = DateTime.now();
  return (from: to.subtract(Duration(days: days)), to: to);
}

final ordersSeriesProvider =
    FutureProvider.autoDispose<List<TimeSeriesPoint>>((ref) async {
  final range = _range(ref.watch(analyticsRangeProvider));
  final result = await ref
      .watch(adminRepositoryProvider)
      .ordersOverTime(from: range.from, to: range.to);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

final rankedProvider =
    FutureProvider.autoDispose.family<List<RankedRow>, String>((ref, path) async {
  final range = _range(ref.watch(analyticsRangeProvider));
  final result =
      await ref.watch(adminRepositoryProvider).ranked(path, from: range.from, to: range.to);
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final days = ref.watch(analyticsRangeProvider);
    final series = ref.watch(ordersSeriesProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            Text(l10n.adminAnalyticsRange, style: AppText.adminSubheading),
            const Spacer(),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7')),
                ButtonSegment(value: 30, label: Text('30')),
                ButtonSegment(value: 90, label: Text('90')),
              ],
              selected: {days},
              onSelectionChanged: (selection) =>
                  ref.read(analyticsRangeProvider.notifier).state = selection.first,
            ),
          ],
        ),
        Gap.lg,

        _Panel(
          title: l10n.adminAnalyticsOrdersOverTime,
          child: series.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => ErrorRetry(
              failure: error is Failure ? error : const Failure.unknown(),
              compact: true,
              onRetry: () => ref.invalidate(ordersSeriesProvider),
            ),
            data: (points) => _BarChart(points: points),
          ),
        ),
        Gap.lg,

        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            _RankedPanel(
              title: l10n.adminAnalyticsTopVendors,
              path: Api.adminAnalyticsTopVendors,
              showAmount: true,
            ),
            _RankedPanel(
              title: l10n.adminAnalyticsTopProducts,
              path: Api.adminAnalyticsTopProducts,
            ),
            _RankedPanel(
              title: l10n.adminAnalyticsAgents,
              path: Api.adminAnalyticsAgents,
              showAmount: true,
            ),
            _RankedPanel(
              title: l10n.adminAnalyticsCancellations,
              path: Api.adminAnalyticsCancellations,
            ),
          ],
        ),
      ],
    );
  }
}

/// A dependency-free bar chart — the data is simple enough that pulling in a
/// charting package would not have earned its weight.
class _BarChart extends StatelessWidget {
  const _BarChart({required this.points});

  final List<TimeSeriesPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: Text(context.l10n.emptyTitle, style: AppText.adminTable)),
      );
    }

    final maxOrders = points.map((p) => p.orders).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final point in points)
            Expanded(
              child: Tooltip(
                message: '${point.date}\n'
                    '${point.orders} · ${point.revenueCentimes.format()}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: maxOrders == 0
                            ? 2
                            : (point.orders / maxOrders * 170).clamp(2, 170),
                        decoration: BoxDecoration(
                          color: AppColors.adminAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (point.cancelled > 0)
                        Container(
                          height: maxOrders == 0
                              ? 1
                              : (point.cancelled / maxOrders * 170).clamp(1, 170),
                          color: AppColors.danger,
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RankedPanel extends ConsumerWidget {
  const _RankedPanel({required this.title, required this.path, this.showAmount = false});

  final String title;
  final String path;
  final bool showAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(rankedProvider(path));

    return SizedBox(
      width: 420,
      child: _Panel(
        title: title,
        child: rows.when(
          loading: () => const SizedBox(
            height: 140,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => ErrorRetry(
            failure: error is Failure ? error : const Failure.unknown(),
            compact: true,
            onRetry: () => ref.invalidate(rankedProvider(path)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(context.l10n.emptyTitle, style: AppText.adminTable),
              );
            }

            return Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text('${i + 1}', style: AppText.adminTableHead),
                        ),
                        Expanded(
                          child: Text(
                            items[i].name,
                            style: AppText.adminTable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${items[i].count}', style: AppText.adminTable),
                        if (showAmount) ...[
                          Gap.wMd,
                          PriceText(items[i].amount, style: AppText.adminTable),
                        ],
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: AppRadius.smallBorder,
        border: Border.all(color: AppColors.adminBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.adminSubheading),
          Gap.md,
          child,
        ],
      ),
    );
  }
}
