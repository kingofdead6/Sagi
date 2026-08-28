import 'package:flutter/foundation.dart';

/// The `{items, page, limit, total, hasMore}` envelope every list endpoint returns.
@immutable
class Paged<T> {
  const Paged({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  const Paged.empty()
      : items = const [],
        page = 1,
        limit = 20,
        total = 0,
        hasMore = false;

  factory Paged.fromJson(dynamic json, T Function(Map<String, dynamic>) parse) {
    if (json is List) {
      final items = json.whereType<Map<String, dynamic>>().map(parse).toList();
      return Paged(items: items, page: 1, limit: items.length, total: items.length, hasMore: false);
    }
    final map = json as Map<String, dynamic>;
    return Paged(
      items: (map['items'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(parse)
          .toList(),
      page: (map['page'] as num?)?.toInt() ?? 1,
      limit: (map['limit'] as num?)?.toInt() ?? 20,
      total: (map['total'] as num?)?.toInt() ?? 0,
      hasMore: map['hasMore'] as bool? ?? false,
    );
  }

  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  bool get isEmpty => items.isEmpty;

  Paged<T> append(Paged<T> next) => Paged(
        items: [...items, ...next.items],
        page: next.page,
        limit: next.limit,
        total: next.total,
        hasMore: next.hasMore,
      );
}
