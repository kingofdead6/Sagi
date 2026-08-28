import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/router.dart';
import 'package:saji/app/theme/app_theme.dart';
import 'package:saji/features/auth/domain/user.dart';
import 'package:saji/features/auth/presentation/auth_controller.dart';
import 'package:saji/l10n/generated/app_localizations.dart';

class SajiApp extends ConsumerWidget {
  const SajiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // The admin dashboard has its own visual language; the customer and agent
    // surfaces share the green one.
    final isAdmin = ref.watch(authControllerProvider).role == UserRole.admin;

    return MaterialApp.router(
      title: 'ساجي',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: isAdmin ? AppTheme.admin : AppTheme.customer,

      // Arabic RTL is the only shipped locale at v1. The direction is set once
      // here — never per widget.
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      builder: (context, child) {
        // Cap text scaling so the dense Figma layouts stay readable.
        final scale = MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.3,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
