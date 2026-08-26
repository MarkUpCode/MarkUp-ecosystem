import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';

class WelcomeTrustView extends StatefulWidget {
  const WelcomeTrustView({super.key});

  @override
  State<WelcomeTrustView> createState() => _WelcomeTrustViewState();
}

class _WelcomeTrustViewState extends State<WelcomeTrustView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  late AnimationController _cardsController;

  late Animation<double> _secureFade;
  late Animation<double> _verifiedFade;
  late Animation<double> _protectedFade;

  late Animation<Offset> _secureSlide;
  late Animation<Offset> _verifiedSlide;
  late Animation<Offset> _protectedSlide;

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // HEADER ANIMATION
    // ------------------------------------------------------------
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: const Interval(
        0.0,
        0.7,
        curve: Curves.easeOut,
      ),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutCubic,
      ),
    );

    // ------------------------------------------------------------
    // CARDS ANIMATION
    // ------------------------------------------------------------
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _secureFade = CurvedAnimation(
      parent: _cardsController,
      curve: const Interval(
        0.0,
        0.35,
        curve: Curves.easeOut,
      ),
    );

    _verifiedFade = CurvedAnimation(
      parent: _cardsController,
      curve: const Interval(
        0.25,
        0.60,
        curve: Curves.easeOut,
      ),
    );

    _protectedFade = CurvedAnimation(
      parent: _cardsController,
      curve: const Interval(
        0.50,
        0.90,
        curve: Curves.easeOut,
      ),
    );

    _secureSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardsController,
        curve: const Interval(
          0.0,
          0.35,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _verifiedSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardsController,
        curve: const Interval(
          0.25,
          0.60,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _protectedSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardsController,
        curve: const Interval(
          0.50,
          0.90,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await _headerController.forward();

    if (!mounted) return;

    await Future<void>.delayed(
      const Duration(milliseconds: 120),
    );

    if (!mounted) return;

    _cardsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),

          // ==========================================================
          // HEADER
          // ==========================================================

          FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: Column(
                children: [
                  // Security icon
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.verified_user_rounded,
                      color: theme.colorScheme.primary,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Tu confianza es importante.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Una plataforma pensada para gestionar tus opciones de crédito con seguridad y transparencia.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ==========================================================
          // 100% SEGURO
          // ==========================================================

          FadeTransition(
            opacity: _secureFade,
            child: SlideTransition(
              position: _secureSlide,
              child: const _TrustPillarTile(
                icon: Icons.shield_rounded,
                title: '100% Seguro',
                description:
                'Gestiona tus opciones de crédito dentro de una plataforma confiable.',
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ==========================================================
          // VERIFICADO
          // ==========================================================

          FadeTransition(
            opacity: _verifiedFade,
            child: SlideTransition(
              position: _verifiedSlide,
              child: const _TrustPillarTile(
                icon: Icons.verified_rounded,
                title: 'Verificado',
                description:
                'Conectamos contigo y con cooperativas participantes dentro de un proceso claro.',
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ==========================================================
          // DATOS PROTEGIDOS
          // ==========================================================

          FadeTransition(
            opacity: _protectedFade,
            child: SlideTransition(
              position: _protectedSlide,
              child: const _TrustPillarTile(
                icon: Icons.lock_rounded,
                title: 'Datos Protegidos',
                description:
                'Tu información es tratada de manera confidencial y responsable.',
              ),
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// TRUST PILLAR TILE
// ============================================================================

class _TrustPillarTile extends StatelessWidget {
  const _TrustPillarTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          // ------------------------------------------------------------
          // ICON
          // ------------------------------------------------------------

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.10,
                ),
              ),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          // ------------------------------------------------------------
          // TEXT
          // ------------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.1,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.35,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ------------------------------------------------------------
          // CHECK
          // ------------------------------------------------------------

          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: theme.colorScheme.primary,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}