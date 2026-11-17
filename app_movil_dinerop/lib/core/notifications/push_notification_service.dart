import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di.dart';
import '../network/api_client.dart';

class PushNotificationEvent {
  const PushNotificationEvent({
    required this.type,
    required this.title,
    required this.body,
    required this.opened,
    this.solicitudId,
  });

  final String type;
  final String? title;
  final String? body;
  final bool opened;
  final int? solicitudId;

  factory PushNotificationEvent.fromData(
    Map<String, dynamic> data, {
    String? title,
    String? body,
    required bool opened,
  }) => PushNotificationEvent(
    type: (data['type'] ?? '').toString(),
    title: title,
    body: body,
    opened: opened,
    solicitudId: int.tryParse((data['solicitudId'] ?? '').toString()),
  );
}

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  final service = PushNotificationService(ref.watch(apiClientProvider));
  ref.onDispose(service.dispose);
  return service;
});

class PushNotificationService {
  PushNotificationService(this._client);

  final ApiClient _client;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final StreamController<PushNotificationEvent> _events =
      StreamController<PushNotificationEvent>.broadcast();
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  Future<void>? _initialization;
  PushNotificationEvent? _pendingOpenedEvent;

  Stream<PushNotificationEvent> get events => _events.stream;

  PushNotificationEvent? consumePendingOpenedEvent() {
    final event = _pendingOpenedEvent;
    _pendingOpenedEvent = null;
    return event;
  }

  Future<void> initializeAndRegister() =>
      _initialization ??= _initializeAndRegister();

  Future<void> _initializeAndRegister() async {
    if (kIsWeb) return;

    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: DarwinInitializationSettings(),
      );
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleLocalNotificationResponse,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'credit_updates',
              'Actualizaciones de crédito',
              description: 'Aceptaciones y ofertas de crédito',
              importance: Importance.high,
            ),
          );

      _foregroundSubscription ??= FirebaseMessaging.onMessage.listen((message) {
        _publish(message, opened: false);
        unawaited(_showForegroundNotification(message));
      });
      _openedSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _publish(message, opened: true),
      );
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) _publish(initialMessage, opened: true);

      final token = await messaging.getToken();
      if (token == null || token.isEmpty) return;

      await _registerToken(token);
      _tokenRefreshSubscription ??= messaging.onTokenRefresh.listen(
        (newToken) => unawaited(_registerToken(newToken)),
      );
    } catch (error, stackTrace) {
      debugPrint('[PUSH] Initialization skipped/failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      message.hashCode,
      notification.title ?? 'Dinerop',
      notification.body ?? 'Tienes una actualización en tu crédito.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'credit_updates',
          'Actualizaciones de crédito',
          channelDescription: 'Aceptaciones y ofertas de crédito',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _publish(RemoteMessage message, {required bool opened}) {
    if (_events.isClosed) return;
    _publishEvent(
      PushNotificationEvent.fromData(
        message.data,
        title: message.notification?.title,
        body: message.notification?.body,
        opened: opened,
      ),
    );
  }

  void _publishEvent(PushNotificationEvent event) {
    if (_events.isClosed) return;
    if (event.opened && !_events.hasListener) {
      _pendingOpenedEvent = event;
    } else {
      _events.add(event);
    }
  }

  void _handleLocalNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty || _events.isClosed) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        _publishEvent(PushNotificationEvent.fromData(decoded, opened: true));
      }
    } catch (error) {
      debugPrint('[PUSH] Could not read notification payload: $error');
    }
  }

  void dispose() {
    unawaited(_foregroundSubscription?.cancel());
    unawaited(_openedSubscription?.cancel());
    unawaited(_tokenRefreshSubscription?.cancel());
    unawaited(_events.close());
  }

  Future<void> _registerToken(String token) async {
    try {
      await _client.request<void>(
        '/api/notifications/devices/token',
        method: 'POST',
        body: {'token': token},
      );
      debugPrint('[PUSH] Device token registered');
    } catch (error) {
      debugPrint('[PUSH] Token registration failed: $error');
    }
  }
}
