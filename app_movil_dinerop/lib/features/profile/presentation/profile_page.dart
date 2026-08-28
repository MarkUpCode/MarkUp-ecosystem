import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // User Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user?.email ?? 'Usuario',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rol: ${auth.user?.role.name.toUpperCase() ?? '-'}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estado de cuenta:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppBadge(
                        label:
                            auth.user?.status.name.toUpperCase() ?? 'UNKNOWN',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Formulario de perfil:',
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppBadge(
                        label: auth.onboardingComplete
                            ? 'COMPLETO'
                            : 'PENDIENTE',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appearance & Theme Selector
            Text('Apariencia y Tema', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Personaliza cómo se ve la aplicación en tu dispositivo. Tu preferencia quedará guardada.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _ThemeOptionTile(
                    title: 'Tema Claro',
                    subtitle: 'Predeterminado · Alta claridad y limpieza',
                    icon: Icons.light_mode_outlined,
                    selectedIcon: Icons.light_mode_rounded,
                    isSelected: currentThemeMode == ThemeMode.light,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.light);
                    },
                  ),
                  const Divider(height: 16),
                  _ThemeOptionTile(
                    title: 'Tema Oscuro',
                    subtitle: 'Elegante y cómodo para entornos con poca luz',
                    icon: Icons.dark_mode_outlined,
                    selectedIcon: Icons.dark_mode_rounded,
                    isSelected: currentThemeMode == ThemeMode.dark,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.dark);
                    },
                  ),
                  const Divider(height: 16),
                  _ThemeOptionTile(
                    title: 'Seguir al Sistema',
                    subtitle: 'Se ajusta automáticamente con tu dispositivo',
                    icon: Icons.brightness_auto_outlined,
                    selectedIcon: Icons.brightness_auto_rounded,
                    isSelected: currentThemeMode == ThemeMode.system,
                    onTap: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            AppButton(
              label: 'Cerrar sesión',
              variant: AppButtonVariant.outlined,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authControllerProvider).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 22,
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
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
