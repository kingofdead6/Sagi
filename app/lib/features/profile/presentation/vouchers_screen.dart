import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/features/profile/domain/customer_voucher.dart';

/// The vouchers still available to this customer. The server does the
/// filtering — anything expired, exhausted or already redeemed never arrives.
final myVouchersProvider = FutureProvider.autoDispose<List<CustomerVoucher>>((ref) async {
  final result = await ref.watch(apiClientProvider).get<List<CustomerVoucher>>(
        Api.myVouchers,
        parse: (data) => (data as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(CustomerVoucher.fromJson)
            .toList(),
      );

  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class VouchersScreen extends ConsumerWidget {
  const VouchersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vouchers = ref.watch(myVouchersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.profileVouchers, style: AppText.header),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(myVouchersProvider.future),
        child: vouchers.when(
          loading: () => const AppSkeletonList(itemHeight: 108, count: 3),
          error: (error, _) => ErrorRetry(
            failure: error is Failure ? error : const Failure.unknown(),
            onRetry: () => ref.invalidate(myVouchersProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                // A scrollable is required for pull-to-refresh to work on an
                // otherwise empty screen.
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
                  EmptyState(
                    icon: Icons.confirmation_num_outlined,
                    title: l10n.vouchersEmptyTitle,
                    message: l10n.vouchersEmptyMessage,
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.screenH),
              itemCount: items.length,
              separatorBuilder: (_, __) => Gap.md,
              itemBuilder: (context, index) => _VoucherCard(voucher: items[index]),
            );
          },
        ),
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.voucher});

  final CustomerVoucher voucher;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.12),
              borderRadius: AppRadius.smallBorder,
            ),
            child: const Icon(
              Icons.confirmation_num_rounded,
              color: AppColors.primaryGreen,
            ),
          ),
          Gap.wMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_headline(context), style: AppText.bodyStrong),
                Gap.xs,
                Text(voucher.code, style: AppText.metaStrong),
                if (voucher.hasMinimum) ...[
                  Gap.xs,
                  Text(
                    l10n.vouchersMinOrder(
                      Money(voucher.minOrderCentimes).format(),
                    ),
                    style: AppText.meta,
                  ),
                ],
                if (voucher.endsAt != null) ...[
                  Gap.xs,
                  Text(
                    l10n.vouchersExpires(_formatDate(voucher.endsAt!)),
                    style: AppText.meta.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.vouchersCopy,
            icon: const Icon(Icons.copy_rounded, color: AppColors.primaryGreen),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: voucher.code));
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.vouchersCopied(voucher.code))));
            },
          ),
        ],
      ),
    );
  }

  String _headline(BuildContext context) {
    final l10n = context.l10n;
    return switch (voucher.type) {
      CustomerVoucherType.percentage => l10n.vouchersPercentOff('${voucher.value}'),
      CustomerVoucherType.fixed =>
        l10n.vouchersAmountOff(Money(voucher.value.toInt()).format()),
      CustomerVoucherType.freeDelivery => l10n.vouchersFreeDelivery,
    };
  }

  String _formatDate(DateTime date) =>
      '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
}
