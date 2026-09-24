import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (error) {
    debugPrint('[PUSH] Firebase is not configured yet: $error');
  }

  debugPrint('[BOOT 1] main started');

  // Inicializar los datos de idioma utilizados por DateFormat.
  await initializeDateFormatting('es', null);

  debugPrint('[BOOT 2] Date formatting initialized');

  debugPrint('[BOOT 3] ProviderScope created');

  runApp(const ProviderScope(child: DineropApp()));
}
