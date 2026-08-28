import 'package:flutter/widgets.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/l10n/generated/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Maps a [Failure] onto the Arabic message the user should read. The
  /// server's own message wins when it sent one worth showing.
  String failureMessage(Failure failure) {
    final serverMessage = failure.message;
    if (serverMessage != null && serverMessage.isNotEmpty) return serverMessage;

    return switch (failure.kind) {
      FailureKind.network => l10n.errorNetwork,
      FailureKind.timeout => l10n.errorTimeout,
      FailureKind.unauthorized => l10n.errorUnauthorized,
      FailureKind.forbidden => l10n.errorForbidden,
      FailureKind.notFound => l10n.errorNotFound,
      FailureKind.conflict => l10n.errorConflict,
      FailureKind.validation => l10n.errorValidation,
      FailureKind.rateLimited => l10n.errorTooMany,
      FailureKind.server => l10n.errorServer,
      FailureKind.unknown => l10n.errorGeneric,
    };
  }

  String orderStatusLabel(OrderStatus status) => switch (status) {
        OrderStatus.pending => l10n.statusPending,
        OrderStatus.confirmed => l10n.statusConfirmed,
        OrderStatus.sentToVendor => l10n.statusSentToVendor,
        OrderStatus.preparing => l10n.statusPreparing,
        OrderStatus.ready => l10n.statusReady,
        OrderStatus.assigned => l10n.statusAssigned,
        OrderStatus.accepted => l10n.statusAccepted,
        OrderStatus.pickedUp => l10n.statusPickedUp,
        OrderStatus.onTheWay => l10n.statusOnTheWay,
        OrderStatus.delivered => l10n.statusDelivered,
        OrderStatus.cancelled => l10n.statusCancelled,
      };
}
