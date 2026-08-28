import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/models/image_ref.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/network/image_upload_service.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/app_image.dart';
import 'package:saji/core/widgets/app_logo.dart';
import 'package:saji/core/widgets/app_skeleton.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/features/admin/presentation/admin_image_field.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/features/catalog/domain/product.dart';
import 'package:saji/features/portal/data/portal_repository.dart';
import 'package:saji/features/vendors/domain/vendor.dart';

/// The shop owner's whole app: their menu, grouped by section, plus the one
/// switch that matters day to day — whether the shop is accepting orders.
///
/// Deliberately narrow. Fees, delivery area and orders stay with the admin, so
/// nothing here can put a shop into a state the dispatcher did not intend.
class PortalScreen extends ConsumerWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vendor = ref.watch(portalVendorProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        titleSpacing: AppSpacing.screenH,
        title: Row(
          children: [
            const AppLogo.mark(size: 32),
            Gap.wSm,
            Expanded(
              child: Text(
                vendor.valueOrNull?.name ?? l10n.portalTitle,
                style: AppText.header,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.authLogout,
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      floatingActionButton: vendor.hasValue
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              onPressed: () => _editProduct(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.portalAddProduct),
            )
          : null,
      body: vendor.when(
        loading: () => const AppSkeletonList(itemHeight: 96, count: 4),
        error: (error, _) => ErrorRetry(
          failure: error is Failure ? error : const Failure.unknown(),
          onRetry: () => ref.invalidate(portalVendorProvider),
        ),
        data: (shop) => RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(portalVendorProvider)
              ..invalidate(portalSectionsProvider)
              ..invalidate(portalProductsProvider);
          },
          child: _Menu(shop: shop),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.authLogout, style: AppText.sectionTitle),
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
    if (confirmed ?? false) await ref.read(authControllerProvider.notifier).logout();
  }
}

Future<void> _editProduct(
  BuildContext context,
  WidgetRef ref, {
  Product? product,
}) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => _ProductDialog(product: product),
  );
  if (saved ?? false) ref.invalidate(portalProductsProvider);
}

class _Menu extends ConsumerWidget {
  const _Menu({required this.shop});

  final Vendor shop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sections = ref.watch(portalSectionsProvider).valueOrNull ?? const <MenuSection>[];
    final products = ref.watch(portalProductsProvider);

    return products.when(
      loading: () => const AppSkeletonList(itemHeight: 96, count: 4),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(portalProductsProvider),
      ),
      data: (items) {
        // Group by section so the owner sees the menu the way a customer does.
        final bySection = <String?, List<Product>>{};
        for (final product in items) {
          bySection.putIfAbsent(product.section, () => []).add(product);
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.md,
            AppSpacing.screenH,
            120,
          ),
          children: [
            _OpenSwitch(shop: shop),
            Gap.lg,
            _SectionsBar(sections: sections),
            Gap.lg,
            if (items.isEmpty)
              EmptyState(
                icon: Icons.restaurant_menu_rounded,
                title: l10n.portalEmptyTitle,
                message: l10n.portalEmptyMessage,
              )
            else ...[
              for (final section in sections)
                if (bySection[section.id]?.isNotEmpty ?? false) ...[
                  Text(section.name, style: AppText.sectionTitle),
                  Gap.sm,
                  for (final product in bySection[section.id]!)
                    _ProductRow(product: product),
                  Gap.lg,
                ],
              // Products with no section, or whose section was deleted.
              if (bySection[null]?.isNotEmpty ?? false) ...[
                Text(l10n.portalUnsectioned, style: AppText.sectionTitle),
                Gap.sm,
                for (final product in bySection[null]!) _ProductRow(product: product),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _OpenSwitch extends ConsumerStatefulWidget {
  const _OpenSwitch({required this.shop});

  final Vendor shop;

  @override
  ConsumerState<_OpenSwitch> createState() => _OpenSwitchState();
}

class _OpenSwitchState extends ConsumerState<_OpenSwitch> {
  late bool _isOpen = widget.shop.isOpen;
  bool _saving = false;

  Future<void> _toggle(bool value) async {
    setState(() {
      _isOpen = value;
      _saving = true;
    });

    final result = await ref.read(portalRepositoryProvider).setOpen(isOpen: value);
    if (!mounted) return;
    setState(() => _saving = false);

    if (result case Err(:final failure)) {
      // Put the switch back where it was — the shop did not actually change.
      setState(() => _isOpen = !value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.failureMessage(failure))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = _isOpen ? AppColors.primaryGreen : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_isOpen ? Icons.storefront_rounded : Icons.no_meals_rounded, color: color),
          Gap.wMd,
          Expanded(
            child: Text(
              _isOpen ? l10n.portalOpen : l10n.portalClosed,
              style: AppText.bodyStrong,
            ),
          ),
          Switch(
            value: _isOpen,
            activeTrackColor: AppColors.primaryGreen,
            onChanged: _saving ? null : _toggle,
          ),
        ],
      ),
    );
  }
}

class _SectionsBar extends ConsumerWidget {
  const _SectionsBar({required this.sections});

  final List<MenuSection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.portalSections, style: AppText.sectionTitle)),
            TextButton.icon(
              onPressed: () => _addSection(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.portalAddSection),
            ),
          ],
        ),
        if (sections.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final section in sections)
                Chip(
                  label: Text(section.name, style: AppText.meta),
                  backgroundColor: AppColors.surface,
                  onDeleted: () => _deleteSection(context, ref, section),
                ),
            ],
          ),
      ],
    );
  }

  Future<void> _addSection(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.portalAddSection, style: AppText.sectionTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.portalSectionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || !context.mounted) return;

    final result = await ref
        .read(portalRepositoryProvider)
        .createSection(name, sections.length);
    if (!context.mounted) return;

    switch (result) {
      case Ok():
        ref.invalidate(portalSectionsProvider);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  Future<void> _deleteSection(
    BuildContext context,
    WidgetRef ref,
    MenuSection section,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(section.name, style: AppText.sectionTitle),
        content: Text(l10n.portalDeleteSectionHint, style: AppText.body),
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
    if (!(confirmed ?? false) || !context.mounted) return;

    final result = await ref.read(portalRepositoryProvider).deleteSection(section.id);
    if (!context.mounted) return;

    switch (result) {
      case Ok():
        ref
          ..invalidate(portalSectionsProvider)
          ..invalidate(portalProductsProvider);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }
}

class _ProductRow extends ConsumerWidget {
  const _ProductRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          AppImage(
            image: product.image,
            width: 56,
            height: 56,
            radius: AppRadius.small,
            fallbackIcon: Icons.fastfood_rounded,
          ),
          Gap.wMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppText.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap.xs,
                Text(product.priceCentimes.format(), style: AppText.metaStrong),
                if (!product.isAvailable) ...[
                  Gap.xs,
                  Text(
                    l10n.portalUnavailable,
                    style: AppText.meta.copyWith(color: AppColors.danger),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen),
            onPressed: () => _editProduct(context, ref, product: product),
          ),
        ],
      ),
    );
  }
}

class _ProductDialog extends ConsumerStatefulWidget {
  const _ProductDialog({required this.product});

  final Product? product;

  @override
  ConsumerState<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends ConsumerState<_ProductDialog> {
  late final _name = TextEditingController(text: widget.product?.name ?? '');
  late final _description = TextEditingController(text: widget.product?.description ?? '');
  late final _price = TextEditingController(
    text: widget.product == null
        ? ''
        : widget.product!.priceCentimes.dinars.toStringAsFixed(0),
  );

  late String? _sectionId = widget.product?.section;
  late bool _available = widget.product?.isAvailable ?? true;
  late ImageRef? _image = widget.product?.image;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final dinars = num.tryParse(_price.text.trim());
    if (_name.text.trim().isEmpty || dinars == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorValidation)),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(portalRepositoryProvider).saveProduct(
      {
        'name': _name.text.trim(),
        if (_description.text.trim().isNotEmpty) 'description': _description.text.trim(),
        'section': _sectionId,
        // The form takes dinars; the wire always carries centimes.
        'priceCentimes': Money.fromDinars(dinars).centimes,
        'image': _image?.toJson(),
        'isAvailable': _available,
      },
      id: widget.product?.id,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  Future<void> _delete() async {
    final id = widget.product?.id;
    if (id == null) return;

    setState(() => _saving = true);
    final result = await ref.read(portalRepositoryProvider).deleteProduct(id);
    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.failureMessage(failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sections = ref.watch(portalSectionsProvider).valueOrNull ?? const <MenuSection>[];

    return AlertDialog(
      title: Text(
        widget.product == null ? l10n.portalAddProduct : l10n.portalEditProduct,
        style: AppText.sectionTitle,
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminImageField(
                label: l10n.adminProductImage,
                value: _image,
                folder: UploadFolder.products,
                fallbackIcon: Icons.fastfood_rounded,
                onChanged: (image) => setState(() => _image = image),
              ),
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: l10n.adminProductName),
              ),
              Gap.md,
              TextField(
                controller: _description,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.adminVendorDescription),
              ),
              Gap.md,
              TextField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.adminProductPrice),
              ),
              Gap.md,
              DropdownButtonFormField<String?>(
                initialValue: _sectionId,
                decoration: InputDecoration(labelText: l10n.portalSections),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.portalUnsectioned)),
                  for (final section in sections)
                    DropdownMenuItem(value: section.id, child: Text(section.name)),
                ],
                onChanged: (value) => setState(() => _sectionId = value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adminProductAvailable, style: AppText.body),
                value: _available,
                activeTrackColor: AppColors.primaryGreen,
                onChanged: (value) => setState(() => _available = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.product != null)
          TextButton(
            onPressed: _saving ? null : _delete,
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
