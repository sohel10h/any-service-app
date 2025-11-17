import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/data/model/network/websocket/websocket_notification_model.dart';

class WebSocketService extends GetxService with WidgetsBindingObserver {
  static WebSocketService get to => Get.find<WebSocketService>();

  WebSocketService({
    required this.baseUrl,
    this.reconnectInterval = const Duration(seconds: 5),
    this.autoReconnect = true,
    this.queryParamsBuilder,
  });

  final String baseUrl;
  Duration reconnectInterval;
  bool autoReconnect;
  Map<String, String> Function()? queryParamsBuilder;
  WebSocket? _socket;
  Timer? _reconnectTimer;
  final RxBool isConnected = false.obs;
  final RxBool _isConnecting = false.obs;
  final StreamController<Map<String, dynamic>> _rawMessageController = StreamController.broadcast();

  Stream<Map<String, dynamic>> get onRawMessage => _rawMessageController.stream;
  final Map<String, List<Function(Map<String, dynamic>)>> _handlers = {};

  Future<WebSocketService> init() async {
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  Future<void> connect() async {
    if (_isConnecting.value || isConnected.value) return;
    _isConnecting.value = true;
    _stopReconnectTimer();
    try {
      final uri = _buildUri();
      _log('Attempting websocket connect -> $uri');
      _socket = await WebSocket.connect(uri.toString()).timeout(const Duration(seconds: 10));
      _socket!.pingInterval = const Duration(seconds: 20);
      _socket!.listen(
        _onData,
        onDone: _onDone,
        onError: _onError,
        cancelOnError: true,
      );
      isConnected.value = true;
      _isConnecting.value = false;
      _log('Websocket connected');
      _emitInternal('ready', {'message': 'connected'});
    } catch (e, st) {
      _isConnecting.value = false;
      _log('Websocket connect error: $e');
      await _checkUnAuthorization(e);
      _emitInternal('error', {'error': e.toString(), 'stack': st.toString()});
      if (autoReconnect) _startReconnectTimer();
    }
  }

  Future<void> disconnect() async {
    _stopReconnectTimer();
    if (_socket != null) {
      try {
        await _socket!.close();
      } catch (e) {
        _log('Error closing websocket: $e');
      }
      _socket = null;
    }
    autoReconnect = false;
    isConnected.value = false;
    _isConnecting.value = false;
    WidgetsBinding.instance.removeObserver(this);
    _rawMessageController.close();
    _log('Websocket disconnected manually');
  }

  Future<void> send(Map<String, dynamic> payload) async {
    if (!isConnected.value || _socket == null) {
      _log('Send failed: socket not connected');
      throw SocketException('Websocket not connected');
    }
    try {
      final text = jsonEncode(payload);
      _socket!.add(text);
    } catch (e) {
      _log('Send error: $e');
      rethrow;
    }
  }

  void on(String type, Function(Map<String, dynamic>) handler) {
    _handlers.putIfAbsent(type, () => []).add(handler);
  }

  void off(String type, Function(Map<String, dynamic>) handler) {
    _handlers[type]?.remove(handler);
  }

  Uri _buildUri() {
    final builder = queryParamsBuilder;
    final params = builder?.call() ?? <String, String>{};
    final uri = Uri.parse(baseUrl).replace(queryParameters: params);
    return uri;
  }

  void _onData(dynamic raw) {
    _log('WS RAW: $raw');
    try {
      final Map<String, dynamic> payload = raw is String ? jsonDecode(raw) : jsonDecode(jsonEncode(raw));
      _rawMessageController.add(payload);
      _handleTypedPayload(payload);
    } catch (e, st) {
      _log('Parse error: $e');
      _emitInternal('error', {'error': 'invalid_json', 'raw': raw, 'stack': st.toString()});
    }
  }

  void _onDone() {
    _log('Websocket connection closed (onDone)');
    isConnected.value = false;
    _emitInternal('closed', {});
    if (autoReconnect) _startReconnectTimer();
  }

  void _onError(dynamic error) async {
    _log('Websocket error: $error');
    await _checkUnAuthorization(error);
    isConnected.value = false;
    _emitInternal('error', {'error': error.toString()});
    if (autoReconnect) _startReconnectTimer();
  }

  Future<void> _checkUnAuthorization(dynamic error) async {
    // Detect unauthorized / expired token
    if (error.toString().contains('401') || error.toString().contains('jwt')) {
      _log('Token expired detected on websocket. Refreshing token...');
      // Use refreshTokenAndRetry with connect as the retry callback
      final result = await ApiService().postRefreshTokenAndRetry(
        () async => await HelperFunction.initWebSockets(
          StorageHelper.getValue(StorageHelper.authToken) ?? "",
        ),
      );
      _log('After refreshing token websocket status: $result');
      if (result != null) {
        isConnected.value = true;
        _isConnecting.value = false;
        _log('Token refreshed and websocket reconnected successfully.');
        return;
      } else {
        _log('Token refresh failed. Logging out...');
        HelperFunction.logOut();
      }
    }
  }

  void _handleTypedPayload(Map<String, dynamic> payload) {
    final type = (payload['type'] ?? '').toString();
    if (type == 'notification') {
      final notificationRaw = payload['notification'];
      if (notificationRaw != null) {
        final notificationMap = notificationRaw is Map ? Map<String, dynamic>.from(notificationRaw) : <String, dynamic>{};
        final model = WebsocketNotificationModel.fromMap(notificationMap);
        final wrapped = {
          'raw': payload,
          'parsed': model,
        };
        _emitInternal('notification', wrapped);
        return;
      }
    }
    _callHandlers(type, payload);
  }

  void _callHandlers(String type, Map<String, dynamic> payload) {
    final handlers = _handlers[type];
    if (handlers != null && handlers.isNotEmpty) {
      for (final h in List<Function>.from(handlers)) {
        try {
          h(payload);
        } catch (e) {
          _log('Handler for $type threw: $e');
        }
      }
    }
  }

  void _emitInternal(String type, Map<String, dynamic> data) {
    _callHandlers(type, data);
  }

  void _startReconnectTimer() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;
    _log('Starting reconnect timer (interval: ${reconnectInterval.inSeconds}s)');
    _reconnectTimer = Timer.periodic(reconnectInterval, (_) async {
      if (isConnected.value) {
        _stopReconnectTimer();
        return;
      }
      if (!_isConnecting.value) {
        await connect();
      }
    });
  }

  void _stopReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _log('AppLifecycleState -> $state');
    if (state == AppLifecycleState.resumed) {
      // app foreground
      if (autoReconnect) connect();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      // app background: close connection and stop trying to reconnect
      _stopReconnectTimer();
      try {
        _socket?.close();
      } catch (_) {}
      _socket = null;
      isConnected.value = false;
    }
  }

  void _log(String message) {
    log('[WebSocketService] $message');
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _rawMessageController.close();
    _stopReconnectTimer();
    super.onClose();
  }
}
