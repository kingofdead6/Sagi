import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saji/core/location/location_service.dart';
import 'package:saji/core/map/map_service.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/network/image_upload_service.dart';
import 'package:saji/core/notifications/notification_service.dart';
import 'package:saji/core/socket/socket_service.dart';
import 'package:saji/core/storage/local_cache.dart';
import 'package:saji/core/storage/token_storage.dart';

/// Overridden in `main()` once Hive has opened.
final localCacheProvider = Provider<LocalCache>(
  (ref) => throw UnimplementedError('localCacheProvider must be overridden in main()'),
);

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(service.dispose);
  return service;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(service.dispose);
  return service;
});

final mapServiceProvider = Provider<MapService>((ref) => NominatimMapService());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

/// Set by the auth controller so the interceptor can sign the user out when a
/// refresh finally fails — without the network layer depending on auth.
final sessionExpiredProvider = Provider<SessionExpiredNotifier>(
  (ref) => SessionExpiredNotifier(),
);

class SessionExpiredNotifier {
  Future<void> Function()? handler;

  Future<void> call() async => handler?.call();
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final expired = ref.watch(sessionExpiredProvider);
  return ApiClient(
    storage: ref.watch(tokenStorageProvider),
    onSessionExpired: expired.call,
  );
});

/// Image picking + upload, sharing the authenticated client so the bearer token
/// and refresh-on-401 behaviour apply to uploads too.
final imageUploadServiceProvider = Provider<ImageUploadService>(
  (ref) => ImageUploadService(ref.watch(apiClientProvider)),
);
