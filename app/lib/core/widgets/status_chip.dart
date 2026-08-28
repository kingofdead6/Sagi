import 'package:flutter/material.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/orders/domain/order_status.dart';

/// The colour a status carries everywhere — customer tracking, agent list and
/// the admin board row all read from here.
Color statusColor(OrderStatus status) => switch (status) {
      OrderStatus.pending => AppColors.warning,
      OrderStatus.confirmed || OrderStatus.sentToVendor => AppColors.info,
      OrderStatus.preparing || OrderStatus.ready => AppColors.adminAccent,
      OrderStatus.assigned || OrderStatus.accepted => const Color(0xFF7C3AED),
      OrderStatus.pickedUp || OrderStatus.onTheWay => AppColors.primaryGreen,
      OrderStatus.delivered => AppColors.primaryGreenDeep,
      OrderStatus.cancelled => AppColors.danger,
    };

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key, this.isLate = false, this.dense = false});

  final OrderStatus status;
  final bool isLate;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = isLate ? AppColors.danger : statusColor(status);
    final label = isLate ? context.l10n.statusLate : context.orderStatusLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.sm : AppSpacing.md,
        vertical: dense ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.stadium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLate) ...[
            Icon(Icons.schedule_rounded, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppText.badge.copyWith(color: color)),
        ],
      ),
    );
  }
}
