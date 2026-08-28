import 'dart:async';

import 'package:logger/logger.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Every realtime event the server can push (§7).
class SocketEvents {
  static const orderNew = 'order:new';
  static const orderStatus = 'order:status';
  static const orderAssigned = 'order:assigned';
  static const orderLate = 'order:late';
  static const agentLocation = 'agent:location';
  static const agentStatus = 'agent:status';

  static const agentLocationUpdate = 'agent:location:update';
  static const joinOrder = 'order:join';
  static const leaveOrder = 'order:leave';
}

typedef SocketPayload = Map<String, dynamic>;

/// One socket for the whole app. Screens subscribe to typed streams rather than
/// registering their own listeners, so nothing leaks when a route pops.
class SocketService {
  SocketService({Logger? logger}) : _logger = logger ?? Logger(printer: SimplePrinter());

  final Logger _logger;
  io.Socket? _socket;
  String? _token;

  final _orderNew = StreamController<SocketPayload>.broadcast();
  final _orderStatus = StreamController<SocketPayload>.broadcast();
  final _orderAssigned = StreamController<SocketPayload>.broadcast();
  final _orderLate = StreamController<SocketPayload>.broadcast();
  final _agentLocation = StreamController<SocketPayload>.broadcast();
  final _agentStatus = StreamController<SocketPayload>.broadcast();
  final _connection = StreamController<bool>.broadcast();

  Stream<SocketPayload> get onOrderNew => _orderNew.stream;
  Stream<SocketPayload> get onOrderStatus => _orderStatus.stream;
  Stream<SocketPayload> get onOrderAssigned => _orderAssigned.stream;
  Stream<SocketPayload> get onOrderLate => _orderLate.stream;
  Stream<SocketPayload> get onAgentLocation => _agentLocation.stream;
  Stream<SocketPayload> get onAgentStatus => _agentStatus.stream;
  Stream<bool> get onConnectionChange => _connection.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String accessToken) async {
    if (_socket != null && _token == accessToken) return;
    await disconnect();
    _token = accessToken;

    final socket = io.io(
      Api.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': accessToken})
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(8000)
          .disableAutoConnect()
          .build(),
    );

    _socket = socket;
    socket
      ..onConnect((_) {
        _logger.i('socket connected');
        _connection.add(true);
      })
      ..onDisconnect((_) => _connection.add(false))
      ..onConnectError((error) => _logger.w('socket connect error: $error'))
      ..on(SocketEvents.orderNew, (data) => _emit(_orderNew, data))
      ..on(SocketEvents.orderStatus, (data) => _emit(_orderStatus, data))
      ..on(SocketEvents.orderAssigned, (data) => _emit(_orderAssigned, data))
      ..on(SocketEvents.orderLate, (data) => _emit(_orderLate, data))
      ..on(SocketEvents.agentLocation, (data) => _emit(_agentLocation, data))
      ..on(SocketEvents.agentStatus, (data) => _emit(_agentStatus, data))
      ..connect();
  }

  void _emit(StreamController<SocketPayload> controller, dynamic data) {
    if (data is Map) {
      controller.add(Map<String, dynamic>.from(data));
    }
  }

  /// Joins an order room; the server authorises the join against the order.
  void joinOrder(String orderId) => _socket?.emit(SocketEvents.joinOrder, orderId);

  void leaveOrder(String orderId) => _socket?.emit(SocketEvents.leaveOrder, orderId);

  void pushLocation({
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    int? battery,
  }) {
    _socket?.emit(SocketEvents.agentLocationUpdate, {
      'lat': lat,
      'lng': lng,
      if (heading != null) 'heading': heading,
      if (speed != null) 'speed': speed,
      if (battery != null) 'battery': battery,
    });
  }

  Future<void> disconnect() async {
    _socket?.dispose();
    _socket = null;
    _token = null;
    _connection.add(false);
  }

  Future<void> dispose() async {
    await disconnect();
    await _orderNew.close();
    await _orderStatus.close();
    await _orderAssigned.close();
    await _orderLate.close();
    await _agentLocation.close();
    await _agentStatus.close();
    await _connection.close();
  }
}
