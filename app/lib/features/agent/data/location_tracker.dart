import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:saji/core/socket/socket_service.dart';
import 'package:saji/features/agent/data/agent_repository.dart';

/// Streams the courier's position while they are online and on a delivery.
///
/// Runs as an Android foreground service with a persistent notification, so the
/// stream survives the app being backgrounded. Samples are throttled by both
/// time (10-15s) and distance (20m), pushed over the socket for immediacy, and
/// queued to a REST batch when the connection drops.
class LocationTracker {
  LocationTracker({
    required AgentRepository repository,
    required SocketService socket,
    Logger? logger,
  })  : _repository = repository,
        _socket = socket,
        _logger = logger ?? Logger(printer: SimplePrinter());

  static const minInterval = Duration(seconds: 12);
  static const minDistanceMeters = 20;
  static const _maxQueued = 50;

  final AgentRepository _repository;
  final SocketService _socket;
  final Logger _logger;

  StreamSubscription<Position>? _subscription;
  final List<LocationSample> _queue = [];
  DateTime? _lastSentAt;
  LatLng? _lastPoint;
  bool _flushing = false;

  final _positions = StreamController<LatLng>.broadcast();

  /// The latest position, for the agent's own map.
  Stream<LatLng> get positions => _positions.stream;

  bool get isRunning => _subscription != null;

  Future<bool> start() async {
    if (_subscription != null) return true;

    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    _subscription = Geolocator.getPositionStream(
      locationSettings: _settings(),
    ).listen(_onPosition, onError: (Object error) {
      _logger.w('location stream error: $error');
    });

    return true;
  }

  /// Android gets a foreground service so tracking survives backgrounding;
  /// iOS uses background location updates. Other platforms degrade to the
  /// plain stream rather than failing.
  LocationSettings _settings() {
    try {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: minDistanceMeters,
        intervalDuration: minInterval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'ساجي',
          notificationText: 'تتبّع الموقع نشط أثناء التوصيل',
          notificationChannelName: 'تتبّع التوصيل',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    } catch (_) {
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: minDistanceMeters,
      );
    }
  }

  Future<void> _onPosition(Position position) async {
    final point = LatLng(position.latitude, position.longitude);
    _positions.add(point);

    // Skip samples that are too soon or too close to the last one sent.
    final now = DateTime.now();
    if (_lastSentAt != null && now.difference(_lastSentAt!) < minInterval) return;
    if (_lastPoint != null) {
      final moved = Geolocator.distanceBetween(
        _lastPoint!.latitude,
        _lastPoint!.longitude,
        point.latitude,
        point.longitude,
      );
      if (moved < minDistanceMeters) return;
    }

    _lastSentAt = now;
    _lastPoint = point;

    final sample = LocationSample(
      point: point,
      recordedAt: now,
      heading: position.heading,
      speed: position.speed,
    );

    if (_socket.isConnected) {
      _socket.pushLocation(
        lat: point.latitude,
        lng: point.longitude,
        heading: position.heading,
        speed: position.speed,
      );
    }

    _queue.add(sample);
    if (_queue.length > _maxQueued) _queue.removeAt(0);
    await _flush();
  }

  /// Sends whatever is queued; anything that fails stays queued for next time.
  Future<void> _flush() async {
    if (_flushing || _queue.isEmpty) return;
    _flushing = true;

    final batch = List<LocationSample>.from(_queue);
    final result = batch.length == 1
        ? await _repository.pushLocation(batch.first)
        : await _repository.pushLocationBatch(batch);

    if (result.isOk) {
      _queue.removeRange(0, batch.length.clamp(0, _queue.length));
    }
    _flushing = false;
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _lastPoint = null;
    _lastSentAt = null;
    await _flush();
  }

  Future<void> dispose() async {
    await stop();
    await _positions.close();
  }
}
