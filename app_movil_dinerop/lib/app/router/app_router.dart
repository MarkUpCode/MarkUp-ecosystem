import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/screens/activation_page.dart';
import '../../features/auth/presentation/screens/complete_registration_page.dart';
import '../../features/auth/presentation/screens/forgot_password_page.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/pending_activation_page.dart';
import '../../features/auth/presentation/screens/register_page.dart';
import '../../features/auth/presentation/screens/reset_password_page.dart';
import '../../features/auth/presentation/screens/splash_page.dart';
import '../../features/cooperative/presentation/cooperatives_page.dart';
import '../../features/credit/presentation/credit_simulator_page.dart';
import '../../features/credit/presentation/investment_simulator_page.dart';
import '../../features/credit/presentation/request_credit_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/requests/presentation/requests_page.dart';
import '../../features/welcome/presentation/welcome_page.dart';
import '../shell/app_shell.dart';

CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0),
            end: Offset.zero,
          ).animate(fade),
          child: child,
        ),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authController = ref.read(authControllerProvider);
  debugPrint('[BOOT] Creating router');

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authController,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublicRoute = <String>{
        '/splash',
        '/welcome',
        '/login',
        '/register',
        '/activate',
        '/complete-registration',
        '/forgot-password',
        '/reset-password',
        '/simulate-credit',
        '/simulate-investment',
      }.contains(location);

      if (authController.isBootstrapping) {
        return location == '/splash' ? null : '/splash';
      }

      if (location == '/splash') {
        return '/welcome';
      }

      if (!authController.isAuthenticated) {
        return isPublicRoute ? null : '/login';
      }

      if (authController.requiresActivation) {
        return location == '/pending-activation' || isPublicRoute
            ? null
            : '/pending-activation';
      }

      if (location == '/login' ||
          location == '/register' ||
          location == '/splash' ||
          location == '/pending-activation') {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
        _fadePage(state: state, child: const SplashPage()),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) =>
        _fadePage(state: state, child: const WelcomePage()),
      ),
      GoRoute(
        path: '/simulate-credit',
        builder: (context, state) => const CreditSimulatorPage(),
      ),

      GoRoute(
        path: '/simulate-investment',
        builder: (context, state) => const InvestmentSimulatorPage(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
        _fadePage(state: state, child: const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/activate',
        builder: (context, state) =>
            ActivationPage(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: '/complete-registration',
        builder: (context, state) =>
            CompleteRegistrationPage(email: state.uri.queryParameters['email']),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) =>
            ResetPasswordPage(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: '/pending-activation',
        builder: (context, state) =>
            PendingActivationPage(
              email: state.uri.queryParameters['email'],
              message: state.uri.queryParameters['message'],
            ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/request-credit',
        builder: (context, state) => const RequestCreditPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                _fadePage(state: state, child: const DashboardPage()),
          ),
          GoRoute(
            path: '/requests',
            builder: (context, state) => const RequestsPage(),
          ),
          GoRoute(
            path: '/cooperatives',
            builder: (context, state) => const CooperativesPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});

