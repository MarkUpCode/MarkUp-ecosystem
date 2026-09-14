import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../onboarding/data/models/pre_registration_data.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final mode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          children: [
            Text(
              'Mi perfil',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Información de tu cuenta y preferencias.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            profile.when(
              data: (data) => _ProfileHero(
                data: data,
                onboardingComplete: auth.onboardingComplete,
              ),
              loading: () => const _ProfileHero(onboardingComplete: false),
              error: (_, _) => _ProfileHero(
                email: auth.user?.email,
                onboardingComplete: auth.onboardingComplete,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Datos de contacto',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            profile.when(
              data: (data) => _ContactCard(data: data),
              loading: () => const _ContactCard(),
              error: (_, _) => _ContactCard(email: auth.user?.email),
            ),
            const SizedBox(height: 22),
            Text(
              'Apariencia',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            AppCard(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _ThemeOption(
                    title: 'Tema claro',
                    icon: Icons.light_mode_outlined,
                    selected: mode == ThemeMode.light,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                  ),
                  const Divider(height: 12),
                  _ThemeOption(
                    title: 'Tema oscuro',
                    icon: Icons.dark_mode_outlined,
                    selected: mode == ThemeMode.dark,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                  ),
                  const Divider(height: 12),
                  _ThemeOption(
                    title: 'Seguir al sistema',
                    icon: Icons.brightness_auto_rounded,
                    selected: mode == ThemeMode.system,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            AppButton(
              label: 'Cerrar sesión',
              variant: AppButtonVariant.outlined,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authControllerProvider).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({this.data, this.email, required this.onboardingComplete});
  final PreRegistrationData? data;
  final String? email;
  final bool onboardingComplete;

  @override
  Widget build(BuildContext context) {
    final first = data?.firstName?.trim();
    final last = data?.lastName?.trim();
    final name = [
      first,
      last,
    ].whereType<String>().where((item) => item.isNotEmpty).join(' ');
    final visibleName = name.isEmpty ? 'Cliente DINEROP' : name;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1E5CB7)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0x24FFFFFF),
            child: Text(
              visibleName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visibleName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data?.email ?? email ?? 'Cargando contacto...',
                  style: const TextStyle(
                    color: Color(0xDFFFFFFF),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 11),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x24FFFFFF),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    onboardingComplete ? 'Perfil completo' : 'Perfil pendiente',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({this.data, this.email});
  final PreRegistrationData? data;
  final String? email;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      children: [
        _InfoRow(
          icon: Icons.email_outlined,
          label: 'Correo electrónico',
          value: data?.email ?? email ?? '—',
        ),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'Teléfono',
          value: data?.phone ?? '—',
        ),
        _InfoRow(
          icon: Icons.badge_outlined,
          label: 'Cédula',
          value: data?.identification ?? '—',
        ),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'Ubicación',
          value:
              [data?.city, data?.province]
                  .whereType<String>()
                  .where((item) => item.isNotEmpty)
                  .join(', ')
                  .isEmpty
              ? '—'
              : [data?.city, data?.province]
                    .whereType<String>()
                    .where((item) => item.isNotEmpty)
                    .join(', '),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: AppColors.primary, size: 19),
    ),
    title: Text(label, style: Theme.of(context).textTheme.bodySmall),
    subtitle: Text(
      value,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(
      icon,
      color: selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurfaceVariant,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      ),
    ),
    trailing: selected
        ? Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).colorScheme.primary,
          )
        : null,
  );
}
