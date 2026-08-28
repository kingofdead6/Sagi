import 'package:flutter/material.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';

/// A dashboard counter tile.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.color = AppColors.adminAccent,
    this.hint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: AppRadius.smallBorder,
        border: Border.all(color: AppColors.adminBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smallBorder,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              Gap.wMd,
              Expanded(
                child: Text(
                  label,
                  style: AppText.adminNav,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap.md,
          Text(value, style: AppText.adminStat, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (hint != null)
            Text(
              hint!,
              style: AppText.adminNav.copyWith(color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

/// A column definition for [AdminDataTable].
class AdminColumn<T> {
  const AdminColumn({required this.label, required this.build, this.flex = 1, this.width});

  final String label;
  final Widget Function(T row) build;
  final int flex;
  final double? width;
}

/// The dashboard table: sticky header, hover highlight, and a row tint that
/// carries the order's status colour.
class AdminDataTable<T> extends StatelessWidget {
  const AdminDataTable({
    required this.columns,
    required this.rows,
    super.key,
    this.onRowTap,
    this.rowColor,
    this.emptyState,
  });

  final List<AdminColumn<T>> columns;
  final List<T> rows;
  final void Function(T row)? onRowTap;
  final Color? Function(T row)? rowColor;
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && emptyState != null) return emptyState!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.adminRowHover,
            border: Border(bottom: BorderSide(color: AppColors.adminBorder)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              for (final column in columns)
                _Cell(
                  flex: column.flex,
                  width: column.width,
                  child: Text(column.label, style: AppText.adminTableHead),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = rows[index];
              return _TableRow<T>(
                row: row,
                columns: columns,
                onTap: onRowTap,
                tint: rowColor?.call(row),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TableRow<T> extends StatefulWidget {
  const _TableRow({
    required this.row,
    required this.columns,
    required this.onTap,
    this.tint,
  });

  final T row;
  final List<AdminColumn<T>> columns;
  final void Function(T row)? onTap;
  final Color? tint;

  @override
  State<_TableRow<T>> createState() => _TableRowState<T>();
}

class _TableRowState<T> extends State<_TableRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap == null ? null : () => widget.onTap!(widget.row),
        child: Container(
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.adminRowHover
                : (widget.tint ?? AppColors.adminSurface),
            border: const Border(bottom: BorderSide(color: AppColors.adminBorder, width: 0.5)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              for (final column in widget.columns)
                _Cell(
                  flex: column.flex,
                  width: column.width,
                  child: column.build(widget.row),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.child, required this.flex, this.width});

  final Widget child;
  final int flex;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return Expanded(flex: flex, child: child);
  }
}

/// The right-hand slide-over used for order details and every CRUD form.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    required this.title,
    required this.child,
    required this.onClose,
    super.key,
    this.actions,
    this.width = 460,
  });

  final String title;
  final Widget child;
  final VoidCallback onClose;
  final Widget? actions;
  final double width;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width;

    return Material(
      elevation: 8,
      color: AppColors.adminSurface,
      child: SizedBox(
        width: width > maxWidth ? maxWidth : width,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.adminBorder)),
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppText.adminSubheading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    ),
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(child: child)),
              if (actions != null)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.adminBorder)),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: actions,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A labelled field used across every admin form.
class AdminField extends StatelessWidget {
  const AdminField({
    required this.label,
    required this.controller,
    super.key,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.adminTableHead),
          Gap.xs,
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled,
            style: AppText.adminTable,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class AdminSwitchField extends StatelessWidget {
  const AdminSwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppText.adminTable),
      value: value,
      activeTrackColor: AppColors.adminAccent,
      onChanged: onChanged,
    );
  }
}
