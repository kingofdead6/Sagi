import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/features/profile/domain/address.dart';
import 'package:saji/features/profile/presentation/address_controller.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final addresses = ref.watch(addressesControllerProvider);
    final controller = ref.read(addressesControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.addressTitle, style: AppText.header),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => context.push(Routes.locationSetup),
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(l10n.addressAdd),
      ),
      body: addresses.when(
        loading: () => const AppSkeletonList(itemHeight: 100, count: 3),
        error: (error, _) => ErrorRetry(
          failure: error is Failure ? error : const Failure.unknown(),
          onRetry: controller.load,
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              title: l10n.addressEmpty,
              icon: Icons.location_off_outlined,
              actionLabel: l10n.addressAdd,
              onAction: () => context.push(Routes.locationSetup),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              120,
            ),
            itemCount: items.length,
            separatorBuilder: (_, __) => Gap.md,
            itemBuilder: (context, index) => _AddressCard(
              address: items[index],
              onSetDefault: () => controller.setDefault(items[index].id),
              onEdit: () => context.push('${Routes.addressEdit}?id=${items[index].id}'),
              onDelete: () => _confirmDelete(context, controller, items[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AddressesController controller,
    Address address,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.commonDelete, style: AppText.cardTitle),
        content: Text(l10n.addressDeleteConfirm, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await controller.remove(address.id);
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  final Address address;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: address.isDefault ? null : onSetDefault,
      borderRadius: AppRadius.cardBorder,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.card,
          border: address.isDefault
              ? Border.all(color: AppColors.primaryGreen, width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(
              address.isDefault ? Icons.check_circle_rounded : Icons.location_on_outlined,
              color: address.isDefault ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            Gap.wMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.label, style: AppText.bodyStrong),
                      if (address.isDefault) ...[
                        Gap.wSm,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.stadium),
                          ),
                          child: Text(
                            l10n.addressDefault,
                            style: AppText.badge.copyWith(color: AppColors.primaryGreen),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Gap.xs,
                  Text(address.oneLine, style: AppText.meta),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
              onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(l10n.commonEdit)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    l10n.commonDelete,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
