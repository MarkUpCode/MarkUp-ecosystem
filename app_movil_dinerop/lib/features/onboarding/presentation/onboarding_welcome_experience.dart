import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class OnboardingWelcomeExperience extends StatefulWidget {
  const OnboardingWelcomeExperience({
    super.key,
    required this.isFirstWelcome,
    required this.showSpotlight,
    required this.onCompleteProfile,
    required this.onDismiss,
  });

  final bool isFirstWelcome;
  final bool showSpotlight;
  final VoidCallback onCompleteProfile;
  final VoidCallback onDismiss;

  @override
  State<OnboardingWelcomeExperience> createState() =>
      _OnboardingWelcomeExperienceState();
}

class _OnboardingWelcomeExperienceState
    extends State<OnboardingWelcomeExperience> {
  final _portalController = OverlayPortalController();
  late final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    if (widget.showSpotlight) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _portalController.show();
      });
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingWelcomeExperience oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showSpotlight != oldWidget.showSpotlight) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.showSpotlight) {
          _portalController.show();
        } else {
          _portalController.hide();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: (context) => _SpotlightOverlay(
          layerLink: _layerLink,
          width: constraints.maxWidth,
          isFirstWelcome: widget.isFirstWelcome,
          onDismiss: widget.onDismiss,
          onCompleteProfile: widget.onCompleteProfile,
        ),
        child: CompositedTransformTarget(
          link: _layerLink,
          child: AnimatedOpacity(
            opacity: widget.showSpotlight ? 0 : 1,
            duration: const Duration(milliseconds: 220),
            child: _ProfileCompletionCard(onComplete: widget.onCompleteProfile),
          ),
        ),
      ),
    );
  }
}

class _ProfileCompletionCard extends StatefulWidget {
  const _ProfileCompletionCard({
    required this.onComplete,
    this.spotlight = false,
  });

  final VoidCallback onComplete;
  final bool spotlight;

  @override
  State<_ProfileCompletionCard> createState() => _ProfileCompletionCardState();
}

class _ProfileCompletionCardState extends State<_ProfileCompletionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );
  Timer? _attentionTimer;

  @override
  void initState() {
    super.initState();
    _attentionTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (mounted && !widget.spotlight) _shakeController.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant _ProfileCompletionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spotlight && !oldWidget.spotlight) {
      _shakeController.stop();
      _shakeController.value = 0;
    }
  }

  @override
  void dispose() {
    _attentionTimer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterSize = widget.spotlight ? 88.0 : 62.0;
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final progress = _shakeController.value;
        final shake = math.sin(progress * math.pi * 8) * 4 * (1 - progress);
        return Transform.translate(
          offset: Offset(widget.spotlight ? 0 : shake, 0),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.spotlight ? 19 : 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB347), Color(0xFFF28A20)],
          ),
          borderRadius: BorderRadius.circular(widget.spotlight ? 25 : 20),
          border: Border.all(color: const Color(0xFFFFD08A), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF28A20).withValues(alpha: .25),
              blurRadius: widget.spotlight ? 32 : 14,
              spreadRadius: widget.spotlight ? 4 : 0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/dolarito/dolarito_motivated.png',
                  width: characterSize,
                  height: characterSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.spotlight
                            ? '¡Vamos por nuevas oportunidades!'
                            : 'Tu perfil abre oportunidades',
                        style: TextStyle(
                          color: const Color(0xFF512B0B),
                          fontSize: widget.spotlight ? 19 : 15,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.spotlight
                            ? 'Ayuda a las cooperativas a conocer tu situación. Completa tus datos correctos y actualizados para facilitar la evaluación de tus solicitudes.'
                            : 'Completa tu perfil y acércate a nuevas oportunidades financieras.',
                        style: TextStyle(
                          color: const Color(0xFF61380F),
                          fontSize: widget.spotlight ? 14 : 11,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.spotlight ? 14 : 10),
            SizedBox(
              height: widget.spotlight ? 48 : 39,
              child: FilledButton.icon(
                onPressed: widget.onComplete,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Completar mi perfil'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF61330C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  textStyle: TextStyle(
                    fontSize: widget.spotlight ? 15 : 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightOverlay extends StatefulWidget {
  const _SpotlightOverlay({
    required this.layerLink,
    required this.width,
    required this.isFirstWelcome,
    required this.onDismiss,
    required this.onCompleteProfile,
  });

  final LayerLink layerLink;
  final double width;
  final bool isFirstWelcome;
  final VoidCallback onDismiss;
  final VoidCallback onCompleteProfile;

  @override
  State<_SpotlightOverlay> createState() => _SpotlightOverlayState();
}

class _SpotlightOverlayState extends State<_SpotlightOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entry = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _entry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: CurvedAnimation(parent: _entry, curve: Curves.easeOut),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: const ColoredBox(
              key: ValueKey('onboarding-spotlight-scrim'),
              color: Color(0xD900101D),
            ),
          ),
        ),
        CompositedTransformFollower(
          link: widget.layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              width: widget.width,
              child: _ProfileCompletionCard(
                spotlight: true,
                onComplete: widget.onCompleteProfile,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                tooltip: 'Cerrar',
                onPressed: widget.onDismiss,
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: .14),
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Text(
                widget.isFirstWelcome
                    ? 'Tus datos básicos ya crearon tu cuenta. Este paso ayuda a las cooperativas a evaluar tus solicitudes.'
                    : 'Tu perfil sigue pendiente. Complétalo cuando quieras para continuar con tus solicitudes.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
