import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class DineropApp extends ConsumerWidget {
  const DineropApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('[BOOT 3] DineropApp created');
    debugPrint('[BOOT 4] Router initialized');
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'DINEROP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
