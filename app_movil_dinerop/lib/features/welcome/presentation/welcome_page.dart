import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/auth_controller.dart';
import 'widgets/cooperative_partners_view.dart';
import 'widgets/welcome_identity_view.dart';
import 'widgets/welcome_trust_view.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  Timer? _autoPlayTimer;

  bool _isPaused = false;
  bool _isFinishing = false;
  bool _isPageChanging = false;

  DateTime? _pageStartedAt;

  static const int _pageCount = 3;

  static const List<Duration> _screenDurations = [
    Duration(seconds: 3),
    Duration(seconds: 3),
    Duration(seconds: 4),
  ];

  @override
  void initState() {
    super.initState();

    _pageStartedAt = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAutoPlay();
      }
    });
  }

  // ---------------------------------------------------------------------------
  // AUTOPLAY
  // ---------------------------------------------------------------------------

  void _startAutoPlay() {
    _cancelAutoPlay();

    if (!mounted || _isPaused || _isFinishing) {
      return;
    }

    _pageStartedAt = DateTime.now();

    _autoPlayTimer = Timer(
      _screenDurations[_currentPage],
      _handleAutoPlayFinished,
    );
  }

  void _cancelAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _handleAutoPlayFinished() {
    if (!mounted || _isPaused || _isFinishing) {
      return;
    }

    if (_currentPage < _pageCount - 1) {
      _goToPage(_currentPage + 1);
    } else {
      _finishWelcome();
    }
  }

  // ---------------------------------------------------------------------------
  // PAUSE / RESUME
  // ---------------------------------------------------------------------------

  void _pauseStory() {
    if (_isPaused || _isFinishing) {
      return;
    }

    _isPaused = true;
    _cancelAutoPlay();

    setState(() {});
  }

  void _resumeStory() {
    if (!_isPaused || _isFinishing) {
      return;
    }

    _isPaused = false;

    // Al soltar reiniciamos el tiempo de la pantalla.
    //
    // Esto evita que una persona mantenga presionado durante mucho tiempo
    // y que la pantalla cambie inmediatamente al soltar.
    _startAutoPlay();

    setState(() {});
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  Future<void> _goToPage(int page) async {
    if (!mounted ||
        _isFinishing ||
        _isPageChanging ||
        page < 0 ||
        page >= _pageCount) {
      return;
    }

    _cancelAutoPlay();

    _isPageChanging = true;

    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );

    _isPageChanging = false;

    if (!mounted || _isFinishing) {
      return;
    }

    _pageStartedAt = DateTime.now();

    _startAutoPlay();
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _pageCount - 1) {
      _goToPage(_currentPage + 1);
    } else {
      _finishWelcome();
    }
  }

  void _handleTap(TapUpDetails details) {
    if (!mounted || _isFinishing) {
      return;
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final tapPosition = details.globalPosition.dx;

    // Mitad izquierda → anterior
    if (tapPosition < screenWidth * 0.35) {
      _goToPreviousPage();
      return;
    }

    // Mitad derecha → siguiente
    if (tapPosition > screenWidth * 0.65) {
      _goToNextPage();
      return;
    }

    // Zona central → no hacemos nada.
    //
    // Esto permite que botones/enlaces que agreguemos posteriormente
    // puedan utilizar la zona central sin interferencias.
  }

  // ---------------------------------------------------------------------------
  // PAGE CHANGE
  // ---------------------------------------------------------------------------

  void _onPageChanged(int index) {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentPage = index;
    });

    if (_isFinishing || _isPaused) {
      return;
    }

    _pageStartedAt = DateTime.now();

    _startAutoPlay();
  }

  // ---------------------------------------------------------------------------
  // FINISH
  // ---------------------------------------------------------------------------

  Future<void> _finishWelcome() async {
    if (_isFinishing) {
      return;
    }

    _isFinishing = true;

    _cancelAutoPlay();

    final authController = ref.read(authControllerProvider);

    final targetRoute = authController.isAuthenticated
        ? '/dashboard'
        : '/login';

    if (!mounted) {
      return;
    }

    context.go(targetRoute);
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _cancelAutoPlay();
    _pageController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        onTapUp: _handleTap,
        child: Column(
          children: [
            // -----------------------------------------------------------
            // TOP AREA — ahora reserva su espacio, ya no flota encima
            // -----------------------------------------------------------
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        _pageCount,
                            (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == _pageCount - 1 ? 0 : 4,
                            ),
                            child: _StoryProgressBar(
                              isCompleted: index < _currentPage,
                              isCurrent: index == _currentPage,
                              isPaused: _isPaused,
                              duration: _screenDurations[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _finishWelcome,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: theme.colorScheme.outlineVariant),
                            ),
                            child: Text(
                              'Saltar',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------
            // CONTENIDO
            // -----------------------------------------------------------
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: const [
                  WelcomeIdentityView(),
                  WelcomeTrustView(),
                  CooperativePartnersView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// STORY PROGRESS BAR
// =============================================================================

class _StoryProgressBar extends StatefulWidget {
  const _StoryProgressBar({
    required this.isCompleted,
    required this.isCurrent,
    required this.isPaused,
    required this.duration,
  });

  final bool isCompleted;
  final bool isCurrent;
  final bool isPaused;
  final Duration duration;

  @override
  State<_StoryProgressBar> createState() => _StoryProgressBarState();
}

class _StoryProgressBarState extends State<_StoryProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.isCurrent && !widget.isPaused) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _StoryProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCompleted) {
      _controller.value = 1;
      return;
    }

    if (!widget.isCurrent) {
      _controller.value = 0;
      _controller.stop();
      return;
    }

    if (widget.isPaused) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.16,
    );

    final foregroundColor = theme.colorScheme.primary;

    if (widget.isCompleted) {
      return Container(
        height: 4,
        decoration: BoxDecoration(
          color: foregroundColor,
          borderRadius: BorderRadius.circular(99),
        ),
      );
    }

    if (!widget.isCurrent) {
      return Container(
        height: 4,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(99),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: _controller.value,
              backgroundColor: backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor,
              ),
            ),
          ),
        );
      },
    );
  }
}