import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('[BOOT 1] main started');

  // Inicializar los datos de idioma utilizados por DateFormat.
  await initializeDateFormatting('es', null);

  debugPrint('[BOOT 2] Date formatting initialized');

  debugPrint('[BOOT 3] ProviderScope created');

  runApp(
    const ProviderScope(
      child: DineropApp(),
    ),
  );
}