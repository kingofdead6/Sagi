import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/pages/admin_order_drawer.dart';
import 'package:saji/features/admin/presentation/pages/admin_orders_board.dart';

/// The full orders page: every filter, search by code or phone, CSV export.
class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedOrderIdProvider);

    return Row(
      children: [
        const Expanded(
          child: Column(
            children: [
              AdminOrdersFilterBar(),
              Expanded(child: AdminOrdersBoard()),
            ],
          ),
        ),
        if (selectedId != null) const AdminOrderDrawer(),
      ],
    );
  }
}
