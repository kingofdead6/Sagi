import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/profile/presentation/settings_controller.dart';

/// Notification preferences. The per-category switches are stored locally and
/// consulted before a push is surfaced; the system-level permission is a
/// separate thing, so it gets its own row that deep-links to OS settings.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  PermissionStatus? _permission;

  @override
  void initState() {
    super.initState();
    _refreshPermission();
  }

  Future<void> _refreshPermission() async {
    final status = await Permission.notification.status;
    if (mounted) setState(() => _permission = status);
  }

  Future<void> _requestOrOpen() async {
    final status = _permission;
    // Once permanently denied, only the OS settings screen can turn it back on.
    if (status != null && status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await Permission.notification.request();
    }
    await _refreshPermission();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prefs = ref.watch(notificationPrefsProvider);
    final controller = ref.read(notificationPrefsProvider.notifier);
    final granted = _permission?.isGranted ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l10n.profileNotifications, style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        children: [
          _PermissionCard(
            granted: granted,
            onTap: _requestOrOpen,
          ),
          Gap.lg,
          Text(l10n.notificationsCategories, style: AppText.sectionTitle),
          Gap.sm,
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardBorder,
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                for (final channel in NotificationChannel.values)
                  SwitchListTile(
                    title: Text(_titleFor(context, channel), style: AppText.body),
                    subtitle: Text(_subtitleFor(context, channel), style: AppText.meta),
                    value: prefs[channel.key] ?? channel.defaultOn,
                    activeTrackColor: AppColors.primaryGreen,
                    // Switching a category off while the OS permission is off
                    // would be meaningless, so the whole group is disabled.
                    onChanged: granted
                        ? (value) => controller.toggle(channel, value: value)
                        : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _titleFor(BuildContext context, NotificationChannel channel) {
    final l10n = context.l10n;
    return switch (channel) {
      NotificationChannel.orderUpdates => l10n.notificationsOrderUpdates,
      NotificationChannel.promotions => l10n.notificationsPromotions,
      NotificationChannel.newVendors => l10n.notificationsNewVendors,
    };
  }

  String _subtitleFor(BuildContext context, NotificationChannel channel) {
    final l10n = context.l10n;
    return switch (channel) {
      NotificationChannel.orderUpdates => l10n.notificationsOrderUpdatesHint,
      NotificationChannel.promotions => l10n.notificationsPromotionsHint,
      NotificationChannel.newVendors => l10n.notificationsNewVendorsHint,
    };
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({required this.granted, required this.onTap});

  final bool granted;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = granted ? AppColors.primaryGreen : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            granted ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
            color: color,
          ),
          Gap.wMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  granted ? l10n.notificationsEnabled : l10n.notificationsDisabled,
                  style: AppText.bodyStrong,
                ),
                Gap.xs,
                Text(
                  granted ? l10n.notificationsEnabledHint : l10n.notificationsDisabledHint,
                  style: AppText.meta,
                ),
              ],
            ),
          ),
          if (!granted)
            TextButton(
              onPressed: onTap,
              child: Text(l10n.notificationsEnable, style: AppText.metaStrong),
            ),
        ],
      ),
    );
  }
}
