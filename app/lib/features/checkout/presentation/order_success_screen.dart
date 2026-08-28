import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/features/orders/presentation/orders_controller.dart';

/// "سنتصل بك لتأكيد الطلب" — the confirmation call is the product, so the
/// success screen says so plainly rather than promising instant dispatch.
class OrderSuccessScreen extends ConsumerWidget {
  const OrderSuccessScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final order = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 68,
                  color: AppColors.primaryGreen,
                ),
              ),
              Gap.xl,
              Text(l10n.successTitle, style: AppText.sectionTitle, textAlign: TextAlign.center),
              Gap.sm,
              Text(
                l10n.successMessage,
                style: AppText.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              Gap.lg,
              order.maybeWhen(
                data: (data) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.stadium),
                    boxShadow: AppShadows.card,
                  ),
                  child: Text(l10n.successOrderCode(data.code), style: AppText.bodyStrong),
                ),
                orElse: () => const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: l10n.successTrack,
                icon: Icons.local_shipping_rounded,
                onPressed: () => context.go(Routes.orderDetailPath(orderId)),
              ),
              Gap.md,
              TextButton(
                onPressed: () => context.go(Routes.home),
                child: Text(l10n.successBackHome, style: AppText.bodyStrong),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
