import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

/// Push notifications. Firebase is optional at runtime: without a
/// `google-services.json` the app still runs, it simply never receives push.
class NotificationService {
  NotificationService({Logger? logger}) : _logger = logger ?? Logger(printer: SimplePrinter());

  static const ordersChannel = AndroidNotificationChannel(
    'saji_orders',
    'تحديثات الطلبات',
    description: 'إشعارات حالة الطلب',
    importance: Importance.high,
  );

  /// Delivery offers ring loudly and use a full-screen intent on Android.
  static const offersChannel = AndroidNotificationChannel(
    'saji_offers',
    'عروض التوصيل',
    description: 'طلبات التوصيل الجديدة للسائقين',
    importance: Importance.max,
  );

  final Logger _logger;
  final _local = FlutterLocalNotificationsPlugin();
  final _tapped = StreamController<Map<String, dynamic>>.broadcast();

  bool _available = false;

  /// Emits the data payload of a notification the user tapped.
  Stream<Map<String, dynamic>> get onNotificationTap => _tapped.stream;

  bool get isAvailable => _available;

  Future<void> init() async {
    await _initLocal();

    try {
      await Firebase.initializeApp();
      _available = true;
    } catch (error) {
      _logger.w('Firebase not configured — push disabled ($error)');
      return;
    }

    try {
      await FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onMessage.listen(_showForeground);
      FirebaseMessaging.onMessageOpenedApp.listen((message) => _tapped.add(message.data));

      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) _tapped.add(initial.data);
    } catch (error) {
      _logger.w('Failed to wire FCM listeners: $error');
    }
  }

  Future<void> _initLocal() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
    );

    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) _tapped.add({'raw': payload});
      },
    );

    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(ordersChannel);
    await androidPlugin?.createNotificationChannel(offersChannel);
  }

  Future<void> _showForeground(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final isOffer = message.data['type'] == 'offer';
    final channel = isOffer ? offersChannel : ordersChannel;

    await _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: isOffer ? Priority.max : Priority.high,
          fullScreenIntent: isOffer,
        ),
        iOS: const DarwinNotificationDetails(presentSound: true),
      ),
      payload: message.data['orderId'] as String?,
    );
  }

  /// The device token to register with the API. Null when Firebase is absent.
  Future<String?> token() async {
    if (!_available) return null;
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  String get platform => defaultTargetPlatform == TargetPlatform.iOS
      ? 'ios'
      : kIsWeb
          ? 'web'
          : 'android';

  Future<void> dispose() => _tapped.close();
}
