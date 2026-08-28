import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saji/app/routes.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/features/profile/presentation/settings_controller.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Figma node 2601:1029 — phone header, settings groups, follow-us, join-us,
/// and the danger zone at the bottom.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: Text(l10n.profileTitle, style: AppText.header),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.lg,
          AppSpacing.screenH,
          140,
        ),
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardBorder,
              boxShadow: AppShadows.card,
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Gap.wLg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? '',
                        style: AppText.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap.xs,
                      Text(
                        Phone.pretty(user?.phone),
                        style: AppText.meta,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.lg,

          _Group(
            title: l10n.profileAccount,
            children: [
              _Tile(
                icon: Icons.location_on_outlined,
                label: l10n.profileMyAddresses,
                onTap: () => context.push(Routes.addresses),
              ),
              _Tile(
                icon: Icons.stars_rounded,
                label: l10n.profileMyPoints,
                trailing: Text(
                  l10n.profilePointsValue(user?.points ?? 0),
                  style: AppText.metaStrong.copyWith(color: AppColors.primaryGreen),
                ),
              ),
              _Tile(
                icon: Icons.confirmation_num_outlined,
                label: l10n.profileVouchers,
                onTap: () => context.push(Routes.vouchers),
              ),
            ],
          ),

          _Group(
            title: l10n.profileSettings,
            children: [
              _Tile(
                icon: Icons.notifications_none_rounded,
                label: l10n.profileNotifications,
                onTap: () => context.push(Routes.notifications),
              ),
              _Tile(
                icon: Icons.language_rounded,
                label: l10n.profileLanguage,
                trailing: Text(
                  ref.watch(localeControllerProvider.notifier).language.label,
                  style: AppText.meta,
                ),
                onTap: () => context.push(Routes.language),
              ),
              _Tile(
                icon: Icons.headset_mic_outlined,
                label: l10n.profileSupport,
                onTap: () => launchUrl(Phone.dialUri('+213770000000')),
              ),
            ],
          ),

          _Group(
            title: l10n.profileFollowUs,
            children: const [
              _Tile(icon: Icons.facebook_rounded, label: 'Facebook'),
              _Tile(icon: Icons.camera_alt_outlined, label: 'Instagram'),
            ],
          ),

          _Group(
            title: l10n.profileJoinUs,
            children: [
              _Tile(
                icon: Icons.storefront_outlined,
                label: l10n.profileJoinUsHint,
                onTap: () => launchUrl(Phone.dialUri('+213770000000')),
              ),
            ],
          ),

          Gap.lg,
          _Group(
            title: l10n.profileDangerZone,
            children: [
              _Tile(
                icon: Icons.logout_rounded,
                label: l10n.authLogout,
                color: AppColors.danger,
                onTap: () => _confirmLogout(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.authLogout, style: AppText.cardTitle),
        content: Text(l10n.authLogoutConfirm, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(l10n.authLogout),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm, right: AppSpacing.xs),
            child: Text(title, style: AppText.metaStrong),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.cardBorder,
              boxShadow: AppShadows.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.textSecondary;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: tint),
      title: Text(label, style: AppText.body.copyWith(color: color)),
      trailing: trailing ??
          (onTap == null
              ? null
              : const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted)),
    );
  }
}
