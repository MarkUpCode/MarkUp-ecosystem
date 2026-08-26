import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/cooperative_partner.dart';

class CooperativePartnersView extends StatefulWidget {
  const CooperativePartnersView({
    super.key,
    this.partners = CooperativePartner.initialPartners,
  });

  final List<CooperativePartner> partners;

  @override
  State<CooperativePartnersView> createState() =>
      _CooperativePartnersViewState();
}

class _CooperativePartnersViewState extends State<CooperativePartnersView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _headerAnimation;
  late Animation<double> _userAnimation;

  final List<Animation<double>> _partnerAnimations = [];
  final List<Animation<double>> _connectionAnimations = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // ===============================================================
    // HEADER
    // ===============================================================

    _headerAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.20,
        curve: Curves.easeOutCubic,
      ),
    );

    // ===============================================================
    // USUARIO
    // Aparece primero
    // ===============================================================

    _userAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.08,
        0.30,
        curve: Curves.easeOutBack,
      ),
    );

    // ===============================================================
    // COOPERATIVAS
    // Aparecen secuencialmente
    // ===============================================================

    final count = math.min(widget.partners.length, 3);

    for (int i = 0; i < count; i++) {
      final double start = 0.26 + (i * 0.13);
      final double end = start + 0.20;

      _partnerAnimations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      );

      // =============================================================
      // CONEXIÓN
      // Aparece después de cada cooperativa
      // =============================================================

      final double lineStart = 0.56 + (i * 0.09);
      final double lineEnd = lineStart + 0.16;

      _connectionAnimations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            lineStart.clamp(0.0, 1.0),
            lineEnd.clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          // ===========================================================
          // HEADER
          // ===========================================================

          FadeTransition(
            opacity: _headerAnimation,
            child: Column(
              children: [
                Text(
                  'Varias cooperativas.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Una sola plataforma.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                    color: primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Conectamos tus necesidades con cooperativas aliadas.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ===========================================================
          // NETWORK CONTAINER
          // Mantiene la animación debajo del título.
          // ===========================================================

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final networkHeight =
                math.min(constraints.maxHeight, 350.0);

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: networkHeight,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _NetworkPainter(
                            primaryColor: primary,
                            lineColor: primary,
                            userProgress: _userAnimation.value,
                            partnerProgress: List.generate(
                              _partnerAnimations.length,
                                  (index) => _partnerAnimations[index].value,
                            ),
                            connectionProgress: List.generate(
                              _connectionAnimations.length,
                                  (index) =>
                              _connectionAnimations[index].value,
                            ),
                            isDark: isDark,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // =================================================
                              // COOPERATIVAS
                              // =================================================

                              ...List.generate(
                                math.min(widget.partners.length, 3),
                                    (index) {
                                  final partner = widget.partners[index];

                                  final position =
                                  _getPartnerPosition(
                                    index,
                                    constraints.maxWidth,
                                    networkHeight,
                                  );

                                  return Positioned(
                                    left: position.dx - 43,
                                    top: position.dy - 43,
                                    child: _AnimatedCooperativeNode(
                                      partner: partner,
                                      animation:
                                      _partnerAnimations[index],
                                      primaryColor: primary,
                                      isDark: isDark,
                                    ),
                                  );
                                },
                              ),

                              // =================================================
                              // USUARIO
                              // =================================================

                              Positioned(
                                left: constraints.maxWidth / 2 - 50,
                                top: networkHeight - 112,
                                child: _AnimatedUserNode(
                                  animation: _userAnimation,
                                  primaryColor: primary,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // POSICIONES DE LAS COOPERATIVAS
  // ================================================================

  Offset _getPartnerPosition(
      int index,
      double width,
      double height,
      ) {
    final centerX = width / 2;

    switch (index) {
      case 0:
        return Offset(
          width * 0.23,
          height * 0.20,
        );

      case 1:
        return Offset(
          centerX,
          height * 0.38,
        );

      case 2:
        return Offset(
          width * 0.77,
          height * 0.20,
        );

      default:
        return Offset(
          centerX,
          height * 0.20,
        );
    }
  }
}

// ============================================================================
// NODO DE COOPERATIVA
// ============================================================================

class _AnimatedCooperativeNode extends StatelessWidget {
  const _AnimatedCooperativeNode({
    required this.partner,
    required this.animation,
    required this.primaryColor,
    required this.isDark,
  });

  final CooperativePartner partner;
  final Animation<double> animation;
  final Color primaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = animation.value;
        final opacity = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: Container(
        width: 86,
        height: 86,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              : Colors.white,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _buildLogo(),
      ),
    );
  }

  Widget _buildLogo() {
    if (partner.assetPath != null &&
        partner.assetPath!.isNotEmpty) {
      if (partner.assetPath!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          partner.assetPath!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      }

      return Image.asset(
        partner.assetPath!,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

    if (partner.logoUrl != null &&
        partner.logoUrl!.isNotEmpty) {
      if (partner.logoUrl!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          partner.logoUrl!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      }

      return Image.network(
        partner.logoUrl!,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      );
    }

    return Icon(
      Icons.account_balance_rounded,
      color: primaryColor,
      size: 32,
    );
  }
}

// ============================================================================
// NODO DEL USUARIO
// ============================================================================

class _AnimatedUserNode extends StatelessWidget {
  const _AnimatedUserNode({
    required this.animation,
    required this.primaryColor,
    required this.isDark,
  });

  final Animation<double> animation;
  final Color primaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final opacity = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  : Colors.white,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.10),
                  blurRadius: 22,
                  spreadRadius: 4,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.08),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 38,
                  color: primaryColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Tú',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAINTER DE LA RED
// ============================================================================

class _NetworkPainter extends CustomPainter {
  _NetworkPainter({
    required this.primaryColor,
    required this.lineColor,
    required this.userProgress,
    required this.partnerProgress,
    required this.connectionProgress,
    required this.isDark,
  });

  final Color primaryColor;
  final Color lineColor;

  final double userProgress;
  final List<double> partnerProgress;
  final List<double> connectionProgress;

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // ==============================================================
    // POSICIÓN DEL USUARIO
    // ==============================================================

    final userCenter = Offset(
      centerX,
      size.height - 62,
    );

    // ==============================================================
    // POSICIONES DE LAS COOPERATIVAS
    // ==============================================================

    final partnerPositions = <Offset>[
      Offset(
        size.width * 0.23,
        size.height * 0.20,
      ),
      Offset(
        centerX,
        size.height * 0.38,
      ),
      Offset(
        size.width * 0.77,
        size.height * 0.20,
      ),
    ];

    final paint = Paint()
      ..color = lineColor.withValues(
        alpha: isDark ? 0.20 : 0.15,
      )
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // ==============================================================
    // CONEXIONES
    // ==============================================================

    for (int i = 0;
    i < partnerPositions.length &&
        i < connectionProgress.length;
    i++) {
      final progress = connectionProgress[i];

      if (progress <= 0) {
        continue;
      }

      final start = _pointOnCircle(
        partnerPositions[i],
        userCenter,
        43,
      );

      final end = _pointOnCircle(
        userCenter,
        partnerPositions[i],
        50,
      );

      final currentEnd = Offset(
        start.dx + (end.dx - start.dx) * progress,
        start.dy + (end.dy - start.dy) * progress,
      );

      canvas.drawLine(
        start,
        currentEnd,
        paint,
      );

      // Pequeño punto luminoso al final de la conexión.
      if (progress > 0.85) {
        final dotPaint = Paint()
          ..color = primaryColor.withValues(
            alpha: (progress - 0.85) / 0.15 * 0.45,
          )
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          currentEnd,
          2.5,
          dotPaint,
        );
      }
    }
  }

  Offset _pointOnCircle(
      Offset from,
      Offset to,
      double radius,
      ) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;

    final distance = math.sqrt(
      (dx * dx) + (dy * dy),
    );

    if (distance == 0) {
      return from;
    }

    return Offset(
      from.dx + (dx / distance) * radius,
      from.dy + (dy / distance) * radius,
    );
  }

  @override
  bool shouldRepaint(
      covariant _NetworkPainter oldDelegate,
      ) {
    return oldDelegate.userProgress != userProgress ||
        oldDelegate.partnerProgress != partnerProgress ||
        oldDelegate.connectionProgress != connectionProgress ||
        oldDelegate.isDark != isDark;
  }
}