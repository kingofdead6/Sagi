import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/network/image_upload_service.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/app_image.dart';

/// Pick-and-upload control for the admin forms.
///
/// Uploading happens as soon as an image is chosen, so by the time the form is
/// saved [value] is already a stored Cloudinary asset and the save is a plain
/// JSON patch. Passing the previous `publicId` lets the server delete the asset
/// being replaced.
class AdminImageField extends ConsumerStatefulWidget {
  const AdminImageField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.folder,
    super.key,
    this.height = 150,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String label;
  final ImageRef? value;
  final ValueChanged<ImageRef?> onChanged;
  final UploadFolder folder;
  final double height;
  final IconData fallbackIcon;

  @override
  ConsumerState<AdminImageField> createState() => _AdminImageFieldState();
}

class _AdminImageFieldState extends ConsumerState<AdminImageField> {
  bool _busy = false;
  double _progress = 0;

  Future<void> _pick() async {
    final service = ref.read(imageUploadServiceProvider);
    final file = await service.pick();
    if (file == null) return;

    setState(() {
      _busy = true;
      _progress = 0;
    });

    final result = await service.upload(
      file,
      folder: widget.folder,
      replaces: widget.value?.publicId,
      onProgress: (value) {
        if (mounted) setState(() => _progress = value);
      },
    );

    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case Ok(:final value):
        widget.onChanged(value);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final image = widget.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppText.adminTableHead),
          Gap.xs,
          InkWell(
            onTap: _busy ? null : _pick,
            borderRadius: AppRadius.smallBorder,
            child: Container(
              height: widget.height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.searchFill,
                borderRadius: AppRadius.smallBorder,
                border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.35)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _busy
                  ? _Uploading(progress: _progress)
                  : image == null
                      ? _Empty(icon: widget.fallbackIcon, label: l10n.adminImagePick)
                      : AppImage(
                          image: image,
                          height: widget.height,
                          width: double.infinity,
                          fallbackIcon: widget.fallbackIcon,
                        ),
            ),
          ),
          if (image != null && !_busy)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => widget.onChanged(null),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: Text(l10n.adminImageRemove),
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              ),
            ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 30),
        Gap.xs,
        Text(label, style: AppText.adminTable.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

class _Uploading extends StatelessWidget {
  const _Uploading({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indeterminate until the first byte lands, then a real bar.
            LinearProgressIndicator(
              value: progress <= 0 ? null : progress,
              color: AppColors.adminAccent,
              backgroundColor: AppColors.searchFill,
            ),
            Gap.xs,
            Text('${(progress * 100).round()}%', style: AppText.adminTable),
          ],
        ),
      ),
    );
  }
}
