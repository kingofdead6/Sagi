import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/features/checkout/presentation/checkout_controller.dart';
import 'package:saji/features/orders/domain/order.dart';
import 'package:saji/features/orders/presentation/orders_controller.dart';

Future<void> showRatingSheet(BuildContext context, WidgetRef ref, AppOrder order) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
    ),
    builder: (context) => _RatingSheet(order: order),
  );
}

class _RatingSheet extends ConsumerStatefulWidget {
  const _RatingSheet({required this.order});

  final AppOrder order;

  @override
  ConsumerState<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends ConsumerState<_RatingSheet> {
  final _comment = TextEditingController();
  int _vendorRating = 5;
  int _agentRating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);

    final result = await ref.read(orderRepositoryProvider).rate(
          orderId: widget.order.id,
          vendorRating: _vendorRating,
          agentRating: widget.order.hasAgent ? _agentRating : null,
          comment: _comment.text.trim(),
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok():
        ref.invalidate(orderDetailProvider(widget.order.id));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.ratingThanks)),
        );
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenH,
        right: AppSpacing.screenH,
        top: AppSpacing.xl,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(l10n.ratingTitle, style: AppText.cardTitle)),
          Gap.xl,
          Text(l10n.ratingVendor, style: AppText.bodyStrong),
          Gap.sm,
          _Stars(value: _vendorRating, onChanged: (v) => setState(() => _vendorRating = v)),
          if (widget.order.hasAgent) ...[
            Gap.lg,
            Text(l10n.ratingAgent, style: AppText.bodyStrong),
            Gap.sm,
            _Stars(value: _agentRating, onChanged: (v) => setState(() => _agentRating = v)),
          ],
          Gap.lg,
          TextField(
            controller: _comment,
            maxLines: 3,
            maxLength: 500,
            style: AppText.body,
            decoration: InputDecoration(
              hintText: l10n.ratingCommentHint,
              counterText: '',
              contentPadding: const EdgeInsets.all(AppSpacing.lg),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Gap.lg,
          PrimaryButton(
            label: l10n.ratingSubmit,
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            onPressed: () => onChanged(i),
            visualDensity: VisualDensity.compact,
            icon: Icon(
              i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 34,
              color: i <= value ? AppColors.warning : AppColors.dotDivider,
            ),
          ),
      ],
    );
  }
}
