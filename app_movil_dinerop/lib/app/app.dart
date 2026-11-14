import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import 'providers.dart';
import 'router/app_router.dart';

class DineropApp extends ConsumerStatefulWidget {
  const DineropApp({super.key});

  @override
  ConsumerState<DineropApp> createState() => _DineropAppState();
}

class _DineropAppState extends ConsumerState<DineropApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    ref.invalidate(clientProfileProvider);
    ref.invalidate(dashboardCreditRequestsProvider);
    ref.invalidate(dashboardOnboardingStatusProvider);
    ref.invalidate(requestsProvider);
    unawaited(ref.read(authControllerProvider).refreshOnboardingState());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[BOOT 3] DineropApp created');
    debugPrint('[BOOT 4] Router initialized');
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'DINEROP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

