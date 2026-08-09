import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../auth/presentation/auth_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final requestsAsync = ref.watch(dashboardCreditRequestsProvider);
    final onboardingAsync = ref.watch(dashboardOnboardingStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DINEROP'),
        actions: [
          IconButton(
            onPressed: () => context.push('/request-credit'),
            icon: const Icon(Icons.add_card_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardCreditRequestsProvider);
            ref.invalidate(dashboardOnboardingStatusProvider);
            await authState.refreshOnboardingState();
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              AppHeader(
                title: 'Hola, ${authState.user?.email.split('@').first ?? 'cliente'}',
                subtitle: 'Gestiona tu crédito, onboarding y cooperativas en un solo lugar.',
              ),
              const SizedBox(height: 20),
              onboardingAsync.when(
                data: (status) => AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estado del onboarding', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              status.formularioCompleto ? 'Completo' : 'Pendiente',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      AppBadge(
                        label: status.formularioCompleto ? 'Listo' : 'Falta completar',
                        color: status.formularioCompleto ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12) : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.12),
                      ),
                    ],
                  ),
                ),
                loading: () => const AppLoader(label: 'Cargando estado...'),
                error: (error, stackTrace) => AppErrorView(message: error is AppException ? error.message : AppErrorMessages.generic),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: AppButton(label: 'Solicitar crédito', icon: Icons.add_circle_outline_rounded, onPressed: () => context.push('/request-credit'))),
                ],
              ),
              const SizedBox(height: 24),
              Text('Solicitudes recientes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              requestsAsync.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return AppEmptyState(
                      title: 'Aún no tienes solicitudes',
                      message: 'Cuando envíes una solicitud de crédito aparecerá aquí su seguimiento.',
                      actionLabel: 'Solicitar crédito',
                      onAction: () => context.push('/request-credit'),
                      icon: Icons.receipt_long_outlined,
                    );
                  }

                  return Column(
                    children: requests.take(3).map((request) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatCurrency(request.monto), style: Theme.of(context).textTheme.headlineSmall),
                                  AppBadge(label: request.estado.name.toUpperCase()),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(request.tipo, style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 4),
                              Text(formatDate(request.fechaSolicitud), style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const AppLoader(label: 'Cargando solicitudes...'),
                error: (error, stackTrace) => AppErrorView(message: error is AppException ? error.message : AppErrorMessages.generic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}