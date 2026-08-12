import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_button.dart';
import '../../auth/presentation/auth_controller.dart';
import 'widgets/cooperative_partners_view.dart';
import 'widgets/welcome_identity_view.dart';
import 'widgets/welcome_trust_view.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _finishTimer;
  bool _isFinishing = false;

  static const List<Duration> _screenDurations = [
    Duration(seconds: 3),
    Duration(seconds: 3),
    Duration(seconds: 4),
  ];

  @override
  void initState() {
    super.initState();
    _scheduleCurrentStep();
  }

  void _cancelTimers() {
    _finishTimer?.cancel();
  }

  void _scheduleCurrentStep() {
    _cancelTimers();

    _finishTimer = Timer(_screenDurations[_currentPage], () {
      if (!mounted || _isFinishing) return;
      if (_currentPage < _screenDurations.length - 1) {
        _advanceToNextPage();
      } else {
        _finishWelcome();
      }
    });
  }

  void _advanceToNextPage() {
    if (!mounted || _currentPage >= _screenDurations.length - 1) return;
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    if (_isFinishing) {
      return;
    }

    _scheduleCurrentStep();
  }

  Future<void> _finishWelcome() async {
    if (_isFinishing) return;
    _isFinishing = true;
    _cancelTimers();

    final authController = ref.read(authControllerProvider);
    final targetRoute = authController.isAuthenticated ? '/dashboard' : '/login';

    if (!mounted) return;
    context.go(targetRoute);
  }

  @override
  void dispose() {
    _cancelTimers();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _finishWelcome();
                  },
                  child: Text(
                    'Saltar',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: const [
                  WelcomeIdentityView(),
                  WelcomeTrustView(),
                  CooperativePartnersView(),
                ],
              ),
            ),

            // Bottom Navigation Area (Page Indicator & CTA Button)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // Page Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Action Button (Siguiente / Iniciar)
                  AppButton(
                    label: _currentPage == 2 ? 'Comenzar' : 'Continuar',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (_currentPage < 2) {
                        _cancelTimers();
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishWelcome();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
