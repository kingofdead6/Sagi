import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/app/app.dart';
import 'package:saji/core/providers/core_providers.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/features/profile/presentation/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  final cache = await LocalCache.open();
  final settings = await SettingsStore.open();

  final container = ProviderContainer(
    overrides: [
      localCacheProvider.overrideWithValue(cache),
      settingsStoreProvider.overrideWithValue(settings),
    ],
  );

  // Push is optional: without a Firebase config the app still runs fully.
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SajiApp(),
    ),
  );
}
