import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/api_client.dart';

class PushNotificationService {
  PushNotificationService(this._client);

  final ApiClient _client;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeAndRegister() async {
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
      await _localNotifications.initialize(initializationSettings);
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

      FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      final token = await messaging.getToken();
      if (token == null || token.isEmpty) return;

      await _registerToken(token);
      messaging.onTokenRefresh.listen((newToken) {
        unawaited(_registerToken(newToken));
      });
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
    );
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
