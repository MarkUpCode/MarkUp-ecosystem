import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';

class WelcomeTrustView extends StatefulWidget {
  const WelcomeTrustView({super.key});

  @override
  State<WelcomeTrustView> createState() => _WelcomeTrustViewState();
}

class _WelcomeTrustViewState extends State<WelcomeTrustView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),

            // Header Icon Badge
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: theme.colorScheme.primary,
                  size: 36,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Tu confianza es importante.',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              'Gestiona tus opciones de crédito de forma clara y transparente.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            // 3 Trust Concept Cards
            const _TrustPillarTile(
              icon: Icons.article_outlined,
              title: 'Información clara',
              description: 'Toda la información sobre términos y condiciones sin letras pequeñas.',
            ),
            const SizedBox(height: 12),

            const _TrustPillarTile(
              icon: Icons.visibility_outlined,
              title: 'Proceso transparente',
              description: 'Sigue el estado real de tu solicitud paso a paso.',
            ),
            const SizedBox(height: 12),

            const _TrustPillarTile(
              icon: Icons.shield_outlined,
              title: 'Gestión responsable',
              description: 'Tus datos son tratados de manera confidencial e institucional.',
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
