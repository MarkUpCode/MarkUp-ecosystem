import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WelcomeIdentityView extends StatefulWidget {
  const WelcomeIdentityView({super.key});

  @override
  State<WelcomeIdentityView> createState() => _WelcomeIdentityViewState();
}

class _WelcomeIdentityViewState extends State<WelcomeIdentityView>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _institutionController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late Animation<double> _legalFade;
  late Animation<Offset> _legalSlide;

  late Animation<double> _sepsFade;
  late Animation<Offset> _sepsSlide;

  late Animation<double> _banksFade;
  late Animation<Offset> _banksSlide;

  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // MAIN ANIMATION
    // ============================================================

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutCubic,
      ),
    );

    // ============================================================
    // INSTITUTIONAL STAGGERED ANIMATION
    // ============================================================

    _institutionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Plataforma legalmente constituida
    _legalFade = CurvedAnimation(
      parent: _institutionController,
      curve: const Interval(
        0.00,
        0.30,
        curve: Curves.easeOut,
      ),
    );

    _legalSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _institutionController,
        curve: const Interval(
          0.00,
          0.30,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // SEPS
    _sepsFade = CurvedAnimation(
      parent: _institutionController,
      curve: const Interval(
        0.22,
        0.55,
        curve: Curves.easeOut,
      ),
    );

    _sepsSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _institutionController,
        curve: const Interval(
          0.22,
          0.55,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Superintendencia de Bancos
    _banksFade = CurvedAnimation(
      parent: _institutionController,
      curve: const Interval(
        0.45,
        0.78,
        curve: Curves.easeOut,
      ),
    );

    _banksSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _institutionController,
        curve: const Interval(
          0.45,
          0.78,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Footer
    _footerFade = CurvedAnimation(
      parent: _institutionController,
      curve: const Interval(
        0.70,
        1.00,
        curve: Curves.easeOut,
      ),
    );

    // ============================================================
    // START
    // ============================================================

    _mainController.forward().then((_) {
      if (mounted) {
        _institutionController.forward();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary =
    isDark ? AppColors.darkPrimary : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ============================================================
              // LOGO
              // ============================================================

              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimaryContainer
                      : AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.14),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(
                        alpha: isDark ? 0.12 : 0.07,
                      ),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: primary,
                  size: 46,
                ),
              ),

              const SizedBox(height: 24),

              // ============================================================
              // BRAND
              // ============================================================

              Text(
                'DINEROP',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // MAIN MESSAGE
              // ============================================================

              Text(
                'Tu camino hacia mejores\nopciones de crédito.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Conectamos personas con cooperativas\nde ahorro y crédito.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              // ============================================================
              // LEGAL PLATFORM CARD
              // ============================================================

              FadeTransition(
                opacity: _legalFade,
                child: SlideTransition(
                  position: _legalSlide,
                  child: _InstitutionCard(
                    icon: Icons.verified_user_rounded,
                    title: 'Plataforma legalmente constituida',
                    subtitle: 'República del Ecuador',
                    primary: primary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ============================================================
              // SEPS CARD
              // ============================================================

              FadeTransition(
                opacity: _sepsFade,
                child: SlideTransition(
                  position: _sepsSlide,
                  child: _InstitutionCard(
                    icon: Icons.account_balance_outlined,
                    title: 'SEPS',
                    subtitle:
                    'Superintendencia de Economía Popular y Solidaria',
                    primary: primary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ============================================================
              // SUPERINTENDENCIA DE BANCOS CARD
              // ============================================================

              FadeTransition(
                opacity: _banksFade,
                child: SlideTransition(
                  position: _banksSlide,
                  child: _InstitutionCard(
                    icon: Icons.account_balance_rounded,
                    title: 'Superintendencia de Bancos',
                    subtitle: 'Superintendencia de Bancos del Ecuador',
                    primary: primary,
                  ),
                ),
              ),

              const SizedBox(height: 13),

              // ============================================================
              // FOOTER
              // ============================================================

              FadeTransition(
                opacity: _footerFade,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Bajo el marco normativo vigente',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// INSTITUTION CARD
// ============================================================================

class _InstitutionCard extends StatelessWidget {
  const _InstitutionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark
                  ? 0.10
                  : 0.025,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    height: 1.2,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Verified indicator
          Icon(
            Icons.check_circle_rounded,
            color: primary.withValues(alpha: 0.75),
            size: 17,
          ),
        ],
      ),
    );
  }
}