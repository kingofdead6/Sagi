import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

/// A tiny JSON cache on top of Hive. Every list in the app writes through here
/// so a cold start on a bad connection still renders the last known data.
class LocalCache {
  LocalCache._(this._box);

  static const _boxName = 'saji_cache';
  static LocalCache? _instance;

  final Box<String> _box;

  static Future<LocalCache> open() async {
    if (_instance != null) return _instance!;
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(_boxName);
    return _instance = LocalCache._(box);
  }

  /// Cached entries older than this are treated as missing.
  static const defaultTtl = Duration(hours: 12);

  Future<void> writeJson(String key, Object? value) async {
    await _box.put(
      key,
      jsonEncode({'at': DateTime.now().millisecondsSinceEpoch, 'value': value}),
    );
  }

  dynamic readJson(String key, {Duration ttl = defaultTtl}) {
    final raw = _box.get(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final at = DateTime.fromMillisecondsSinceEpoch(decoded['at'] as int);
      if (DateTime.now().difference(at) > ttl) return null;
      return decoded['value'];
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> readList(String key, {Duration ttl = defaultTtl}) {
    final value = readJson(key, ttl: ttl);
    if (value is List) return value.whereType<Map<String, dynamic>>().toList();
    return const [];
  }

  Future<void> remove(String key) => _box.delete(key);

  Future<void> clear() => _box.clear();
}
