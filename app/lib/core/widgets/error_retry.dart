import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';

/// The error state every screen shows: a localised Arabic message plus retry.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({required this.failure, required this.onRetry, super.key, this.compact = false});

  final Failure failure;
  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final offline = failure.isOffline;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          offline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
          size: compact ? 32 : 56,
          color: AppColors.textMuted,
        ),
        Gap.md,
        Text(
          l10n.errorRetryTitle,
          style: compact ? AppText.bodyStrong : AppText.cardTitle,
          textAlign: TextAlign.center,
        ),
        Gap.xs,
        Text(
          context.failureMessage(failure),
          style: AppText.meta,
          textAlign: TextAlign.center,
        ),
        Gap.lg,
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(l10n.commonRetry),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryGreen,
            side: const BorderSide(color: AppColors.primaryGreen),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          ),
        ),
      ],
    );

    return Center(
      child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: content),
    );
  }
}
