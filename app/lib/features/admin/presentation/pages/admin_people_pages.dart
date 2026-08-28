import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/theme/spacing.dart';
import 'package:saji/app/theme/text_styles.dart';
import 'package:saji/app/theme/tokens.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/l10n_ext.dart';
import 'package:saji/core/models/page.dart';
import 'package:saji/core/phone.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/features/admin/domain/admin_models.dart';
import 'package:saji/features/admin/presentation/admin_controller.dart';
import 'package:saji/features/admin/presentation/admin_widgets.dart';

// ─────────────────────────────── agents ───────────────────────────────────

final adminAgentsProvider = FutureProvider.autoDispose<Paged<ManagedUser>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).agents();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminAgentsPage extends ConsumerWidget {
  const AdminAgentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final agents = ref.watch(adminAgentsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _createAgent(context, ref),
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: Text(l10n.adminAgentNew),
              ),
            ],
          ),
        ),
        Expanded(
          child: agents.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorRetry(
              failure: error is Failure ? error : const Failure.unknown(),
              onRetry: () => ref.invalidate(adminAgentsProvider),
            ),
            data: (page) => AdminDataTable<ManagedUser>(
              rows: page.items,
              emptyState: EmptyState(
                title: l10n.emptyTitle,
                icon: Icons.delivery_dining_outlined,
                actionLabel: l10n.adminAgentNew,
                onAction: () => _createAgent(context, ref),
              ),
              columns: [
                AdminColumn(
                  label: l10n.authFullName,
                  flex: 2,
                  build: (u) => Text(u.fullName, style: AppText.adminTable),
                ),
                AdminColumn(
                  label: l10n.authPhone,
                  build: (u) => Text(
                    Phone.pretty(u.phone),
                    style: AppText.adminNav,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                AdminColumn(
                  label: l10n.agentOnline,
                  width: 110,
                  build: (u) => _Dot(
                    active: u.isOnline,
                    label: u.isOnline ? l10n.agentOnline : l10n.agentOffline,
                  ),
                ),
                AdminColumn(
                  label: l10n.adminColActions,
                  width: 160,
                  build: (u) => _AgentActions(agent: u),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createAgent(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => const _AgentDialog(),
    );
    if (created ?? false) ref.invalidate(adminAgentsProvider);
  }
}

class _AgentActions extends ConsumerStatefulWidget {
  const _AgentActions({required this.agent});

  final ManagedUser agent;

  @override
  ConsumerState<_AgentActions> createState() => _AgentActionsState();
}

class _AgentActionsState extends ConsumerState<_AgentActions> {
  bool _busy = false;

  Future<void> _toggle() async {
    setState(() => _busy = true);
    final result = await ref.read(adminRepositoryProvider).updateAgent(
      widget.agent.id,
      {'isActive': !widget.agent.isActive},
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) ref.invalidate(adminAgentsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final active = widget.agent.isActive;

    return TextButton(
      onPressed: _busy ? null : _toggle,
      style: TextButton.styleFrom(
        foregroundColor: active ? AppColors.danger : AppColors.primaryGreen,
      ),
      child: Text(active ? l10n.adminAgentSuspend : l10n.adminAgentActivate),
    );
  }
}

class _AgentDialog extends ConsumerStatefulWidget {
  const _AgentDialog();

  @override
  ConsumerState<_AgentDialog> createState() => _AgentDialogState();
}

class _AgentDialogState extends ConsumerState<_AgentDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final normalized = Phone.normalize(_phone.text);
    if (_name.text.trim().length < 2 || normalized == null || _password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorValidation)),
      );
      return;
    }

    setState(() => _saving = true);
    final result = await ref.read(adminRepositoryProvider).createAgent(
          fullName: _name.text.trim(),
          phone: normalized,
          password: _password.text,
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.adminAgentNew, style: AppText.adminSubheading),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminField(label: l10n.authFullName, controller: _name),
            AdminField(
              label: l10n.authPhone,
              controller: _phone,
              hint: '0X XX XX XX XX',
              keyboardType: TextInputType.phone,
            ),
            AdminField(
              label: l10n.adminAgentTempPassword,
              controller: _password,
              hint: l10n.authPasswordHint,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

// ────────────────────────────── customers ─────────────────────────────────

final adminCustomersProvider = FutureProvider.autoDispose<Paged<ManagedUser>>((ref) async {
  final result = await ref.watch(adminRepositoryProvider).customers();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});

class AdminCustomersPage extends ConsumerWidget {
  const AdminCustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final customers = ref.watch(adminCustomersProvider);

    return customers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorRetry(
        failure: error is Failure ? error : const Failure.unknown(),
        onRetry: () => ref.invalidate(adminCustomersProvider),
      ),
      data: (page) => AdminDataTable<ManagedUser>(
        rows: page.items,
        emptyState: EmptyState(title: l10n.emptyTitle, icon: Icons.people_outline_rounded),
        columns: [
          AdminColumn(
            label: l10n.authFullName,
            flex: 2,
            build: (u) => Text(u.fullName, style: AppText.adminTable),
          ),
          AdminColumn(
            label: l10n.authPhone,
            build: (u) => Text(
              Phone.pretty(u.phone),
              style: AppText.adminNav,
              textDirection: TextDirection.ltr,
            ),
          ),
          AdminColumn(
            label: l10n.profileMyPoints,
            width: 100,
            build: (u) => Text('${u.points}', style: AppText.adminTable),
          ),
          AdminColumn(
            label: l10n.adminColActions,
            width: 160,
            build: (u) => _BlockToggle(customer: u),
          ),
        ],
      ),
    );
  }
}

class _BlockToggle extends ConsumerStatefulWidget {
  const _BlockToggle({required this.customer});

  final ManagedUser customer;

  @override
  ConsumerState<_BlockToggle> createState() => _BlockToggleState();
}

class _BlockToggleState extends ConsumerState<_BlockToggle> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final blocked = widget.customer.isBlocked;

    return TextButton(
      onPressed: _busy
          ? null
          : () async {
              setState(() => _busy = true);
              final result = await ref.read(adminRepositoryProvider).updateCustomer(
                widget.customer.id,
                {'isBlocked': !blocked},
              );
              if (!mounted) return;
              setState(() => _busy = false);
              if (result.isOk) ref.invalidate(adminCustomersProvider);
            },
      style: TextButton.styleFrom(
        foregroundColor: blocked ? AppColors.primaryGreen : AppColors.danger,
      ),
      child: Text(blocked ? l10n.adminCustomerUnblock : l10n.adminCustomerBlock),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active, required this.label});

  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryGreen : AppColors.textMuted;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Gap.wSm,
        Flexible(
          child: Text(
            label,
            style: AppText.adminNav.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
