import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[BOOT 1] main started');
  debugPrint('[BOOT 2] ProviderScope created');
  runApp(const ProviderScope(child: DineropApp()));
}
