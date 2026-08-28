import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Persisted user preferences: the app language and which push categories the
/// customer wants. Kept in its own Hive box rather than the shared JSON cache,
/// whose entries expire on a TTL — preferences must not.
class SettingsStore {
  SettingsStore(this._box);

  static const _boxName = 'saji_settings';
  static const _localeKey = 'locale';
  static const _notificationsKey = 'notifications';

  final Box<String> _box;

  static Future<SettingsStore> open() async =>
      SettingsStore(await Hive.openBox<String>(_boxName));

  String? readLocale() => _box.get(_localeKey);

  Future<void> writeLocale(String code) => _box.put(_localeKey, code);

  Map<String, bool> readNotifications() {
    final raw = _box.get(_notificationsKey);
    if (raw == null) return const {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value == true));
    } catch (_) {
      // A corrupt value should fall back to defaults, not crash the app.
      return const {};
    }
  }

  Future<void> writeNotifications(Map<String, bool> value) =>
      _box.put(_notificationsKey, jsonEncode(value));
}

/// Overridden in `main()` once Hive has opened.
final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => throw UnimplementedError('settingsStoreProvider must be overridden in main()'),
);

// ── language ────────────────────────────────────────────────────────────────

/// The locales the app actually ships translations for.
enum AppLanguage {
  ar('ar', 'العربية'),
  fr('fr', 'Français'),
  en('en', 'English');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  static AppLanguage fromCode(String? code) =>
      AppLanguage.values.firstWhere((l) => l.code == code, orElse: () => AppLanguage.ar);
}

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._store) : super(Locale(AppLanguage.fromCode(_store.readLocale()).code));

  final SettingsStore _store;

  AppLanguage get language => AppLanguage.fromCode(state.languageCode);

  Future<void> select(AppLanguage language) async {
    if (language.code == state.languageCode) return;
    await _store.writeLocale(language.code);
    state = Locale(language.code);
  }
}

final localeControllerProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(ref.watch(settingsStoreProvider)),
);

// ── notifications ───────────────────────────────────────────────────────────

/// The push categories a customer can opt out of. Order status is not one of
/// them: the whole product is the admin phoning about an order.
enum NotificationChannel {
  orderUpdates('orderUpdates', defaultOn: true),
  promotions('promotions', defaultOn: true),
  newVendors('newVendors', defaultOn: false);

  const NotificationChannel(this.key, {required this.defaultOn});

  final String key;
  final bool defaultOn;
}

class NotificationPrefsController extends StateNotifier<Map<String, bool>> {
  NotificationPrefsController(this._store) : super(_initial(_store));

  final SettingsStore _store;

  static Map<String, bool> _initial(SettingsStore store) {
    final saved = store.readNotifications();
    return {
      for (final channel in NotificationChannel.values)
        channel.key: saved[channel.key] ?? channel.defaultOn,
    };
  }

  bool isEnabled(NotificationChannel channel) => state[channel.key] ?? channel.defaultOn;

  Future<void> toggle(NotificationChannel channel, {required bool value}) async {
    final next = {...state, channel.key: value};
    state = next;
    await _store.writeNotifications(next);
  }
}

final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsController, Map<String, bool>>(
  (ref) => NotificationPrefsController(ref.watch(settingsStoreProvider)),
);
