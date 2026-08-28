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
  const AdminColumn({
    required this.label,
    required this.build,
    this.flex = 1,
    this.width,
    this.minWidth,
  });

  final String label;
  final Widget Function(T row) build;
  final int flex;
  final double? width;

  /// Width this column refuses to shrink below. Once the columns together need
  /// more room than the viewport, the table scrolls sideways instead of
  /// crushing every cell — which is what made narrow windows unusable.
  final double? minWidth;

  /// What this column occupies when the table is laid out at its floor width.
  double get _floor => width ?? minWidth ?? _defaultMinWidth;

  static const _defaultMinWidth = 120.0;
}

/// The dashboard table: sticky header, hover highlight, and a row tint that
/// carries the order's status colour.
class AdminDataTable<T> extends StatefulWidget {
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
  State<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends State<AdminDataTable<T>> {
  final _horizontal = ScrollController();

  /// Horizontal padding applied to both the header and every row.
  static const _rowPadding = AppSpacing.lg * 2;

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty && widget.emptyState != null) return widget.emptyState!;

    final floor = widget.columns.fold<double>(0, (sum, c) => sum + c._floor) + _rowPadding;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Wide enough: keep the flexible layout so columns fill the window.
        // Too narrow: lay the table out at its floor width and scroll.
        final needsScroll = constraints.maxWidth < floor;
        final tableWidth = needsScroll ? floor : constraints.maxWidth;

        final table = SizedBox(
          width: tableWidth,
          child: Column(
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
                    for (final column in widget.columns)
                      _Cell(
                        flex: column.flex,
                        width: column.width,
                        minWidth: column.minWidth,
                        pinned: needsScroll,
                        child: Text(column.label, style: AppText.adminTableHead),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.rows.length,
                  itemBuilder: (context, index) {
                    final row = widget.rows[index];
                    return _TableRow<T>(
                      row: row,
                      columns: widget.columns,
                      onTap: widget.onRowTap,
                      tint: widget.rowColor?.call(row),
                      pinned: needsScroll,
                    );
                  },
                ),
              ),
            ],
          ),
        );

        if (!needsScroll) return table;

        // One scroll view wraps header and body together, so they can never
        // drift out of alignment the way two synced controllers would.
        return Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontal,
            scrollDirection: Axis.horizontal,
            child: table,
          ),
        );
      },
    );
  }
}

class _TableRow<T> extends StatefulWidget {
  const _TableRow({
    required this.row,
    required this.columns,
    this.pinned = false,
    required this.onTap,
    this.tint,
  });

  final T row;
  final List<AdminColumn<T>> columns;
  final void Function(T row)? onTap;
  final bool pinned;
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
                  minWidth: column.minWidth,
                  pinned: widget.pinned,
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
  const _Cell({
    required this.child,
    required this.flex,
    this.width,
    this.minWidth,
    this.pinned = false,
  });

  final Widget child;
  final int flex;
  final double? width;
  final double? minWidth;

  /// True while the table is laid out at its floor width inside a horizontal
  /// scroller, where `Expanded` has no bounded width to expand into.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    if (width != null) return SizedBox(width: width, child: child);
    if (pinned) {
      return SizedBox(width: minWidth ?? AdminColumn._defaultMinWidth, child: child);
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
