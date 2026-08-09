import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.user?.email ?? '-', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  AppBadge(label: auth.user?.status.name.toUpperCase() ?? 'UNKNOWN'),
                  const SizedBox(height: 12),
                  Text('Rol: ${auth.user?.role.name.toUpperCase() ?? '-'}', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Onboarding: ${auth.onboardingComplete ? 'COMPLETO' : 'PENDIENTE'}', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Cerrar sesión',
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authControllerProvider).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}