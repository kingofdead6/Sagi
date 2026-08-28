import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saji/app/theme/app_theme.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/money.dart';
import 'package:saji/core/widgets/empty_state.dart';
import 'package:saji/core/widgets/error_retry.dart';
import 'package:saji/core/widgets/price_text.dart';
import 'package:saji/core/widgets/primary_button.dart';
import 'package:saji/core/widgets/qty_stepper.dart';
import 'package:saji/core/widgets/status_chip.dart';
import 'package:saji/features/orders/domain/order_status.dart';
import 'package:saji/l10n/generated/app_localizations.dart';

/// Wraps a widget in the app's real locale and theme, so tests exercise the
/// Arabic RTL configuration the app actually ships.
Widget wrap(Widget child) => MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.customer,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('the app runs right-to-left in Arabic', (tester) async {
    await tester.pumpWidget(wrap(const Text('مرحباً')));
    final direction = Directionality.of(tester.element(find.text('مرحباً')));
    expect(direction, TextDirection.rtl);
  });

  testWidgets('PriceText renders the amount and the currency', (tester) async {
    await tester.pumpWidget(wrap(const PriceText(Money(135000))));
    expect(find.textContaining('1350.0'), findsOneWidget);
    expect(find.textContaining('د.ج'), findsOneWidget);
  });

  testWidgets('PrimaryButton disables itself and spins while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(PrimaryButton(label: 'تأكيد', isLoading: true, onPressed: () => taps++)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets('PrimaryButton fires when enabled', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(PrimaryButton(label: 'تأكيد', onPressed: () => taps++)));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('QtyStepper respects its bounds', (tester) async {
    var value = 1;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => QtyStepper(
            value: value,
            max: 3,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    // At the minimum, decrement is disabled.
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(value, 1);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
    }
    expect(value, 3);
  });

  testWidgets('StatusChip shows the Arabic label for each status', (tester) async {
    await tester.pumpWidget(wrap(const StatusChip(OrderStatus.preparing)));
    expect(find.text('قيد التحضير'), findsOneWidget);
  });

  testWidgets('StatusChip switches to the late label', (tester) async {
    await tester.pumpWidget(
      wrap(const StatusChip(OrderStatus.preparing, isLate: true)),
    );
    expect(find.text('متأخر'), findsOneWidget);
  });

  testWidgets('EmptyState offers an action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        EmptyState(
          title: 'سلتك فارغة',
          actionLabel: 'تصفّح المتاجر',
          onAction: () => tapped = true,
        ),
      ),
    );

    expect(find.text('سلتك فارغة'), findsOneWidget);
    await tester.tap(find.text('تصفّح المتاجر'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('ErrorRetry shows the offline message and retries', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      wrap(ErrorRetry(failure: const Failure.network(), onRetry: () => retries++)),
    );

    expect(find.text('لا يوجد اتصال بالإنترنت، تحقق من الشبكة'), findsOneWidget);
    await tester.tap(find.text('إعادة المحاولة'));
    await tester.pump();
    expect(retries, 1);
  });

  testWidgets('ErrorRetry prefers the message the server sent', (tester) async {
    await tester.pumpWidget(
      wrap(
        ErrorRetry(
          failure: const Failure(kind: FailureKind.conflict, message: 'لم تعد القسيمة صالحة'),
          onRetry: () {},
        ),
      ),
    );
    expect(find.text('لم تعد القسيمة صالحة'), findsOneWidget);
  });
}
