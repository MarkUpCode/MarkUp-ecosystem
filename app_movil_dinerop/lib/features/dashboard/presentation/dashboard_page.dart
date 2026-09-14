import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../credit/data/models/client_credit_request.dart';
import '../../credit/data/models/credit_enums.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final requests = ref.watch(dashboardCreditRequestsProvider);
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(clientProfileProvider);
            ref.invalidate(dashboardCreditRequestsProvider);
            ref.invalidate(dashboardOnboardingStatusProvider);
            await auth.refreshOnboardingState();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
            children: [
              profile.when(
                data: (data) => _WelcomeHeader(
                  name: data.firstName?.trim().isNotEmpty == true
                      ? data.firstName!.trim()
                      : 'cliente',
                ),
                loading: () => const _WelcomeHeader(name: 'cliente'),
                error: (_, _) => const _WelcomeHeader(name: 'cliente'),
              ),
              const SizedBox(height: 20),
              onboarding.when(
                data: (status) => _ProfileProgressCard(
                  complete: status.formularioCompleto,
                  onTap: status.formularioCompleto
                      ? null
                      : () => context.push('/onboarding'),
                ),
                loading: () => const SizedBox(
                  height: 88,
                  child: AppLoader(label: 'Verificando tu perfil...'),
                ),
                error: (error, _) => AppErrorView(
                  message: error is AppException
                      ? error.message
                      : AppErrorMessages.generic,
                ),
              ),
              const SizedBox(height: 24),
              requests.when(
                data: (items) {
                  if (items.isEmpty) {
                    return AppEmptyState(
                      title: 'Aún no tienes solicitudes',
                      message:
                          'Cuando envíes una solicitud de crédito, podrás seguirla desde aquí.',
                      actionLabel: 'Solicitar crédito',
                      onAction: () => context.push('/request-credit'),
                      icon: Icons.account_balance_wallet_outlined,
                    );
                  }
                  return _DashboardOverview(
                    requests: items,
                    onViewRequests: () => context.go('/requests'),
                  );
                },
                loading: () =>
                    const AppLoader(label: 'Cargando tu actividad...'),
                error: (error, _) => AppErrorView(
                  message: error is AppException
                      ? error.message
                      : AppErrorMessages.generic,
                ),
              ),
              const SizedBox(height: 22),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1E5CB7)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x260F3A7D),
                      blurRadius: 18,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => context.push('/request-credit'),
                  borderRadius: BorderRadius.circular(22),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0x24FFFFFF),
                          child: Icon(
                            Icons.add_chart_rounded,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nueva solicitud',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Encuentra opciones entre cooperativas.',
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview({
    required this.requests,
    required this.onViewRequests,
  });

  final List<ClientCreditRequestSummary> requests;
  final VoidCallback onViewRequests;

  @override
  Widget build(BuildContext context) {
    final active = requests
        .where((request) => request.estado != CreditRequestStatus.rechazada)
        .length;
    final approved = requests
        .where(
          (request) =>
              request.estado == CreditRequestStatus.preAprobada ||
              request.estado == CreditRequestStatus.aceptada,
        )
        .length;
    final total = requests.fold<double>(
      0,
      (sum, request) => sum + request.monto,
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tu panorama',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: onViewRequests,
              child: const Text('Ver solicitudes'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF1769AA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x261D4ED8),
                blurRadius: 18,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.insights_rounded,
                    color: Color(0xB3FFFFFF),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Resumen de solicitudes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xDFFFFFFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(total),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'monto total solicitado',
                style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _OverviewMetric(
                      icon: Icons.pending_actions_rounded,
                      value: '$active',
                      label: 'En seguimiento',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OverviewMetric(
                      icon: Icons.verified_rounded,
                      value: '$approved',
                      label: 'Pre aprobadas',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OverviewMetric(
                      icon: Icons.description_rounded,
                      value: '${requests.length}',
                      label: 'Solicitudes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_circle_outline_rounded,
                label: 'Nueva solicitud',
                onTap: () => context.push('/request-credit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickAction(
                icon: Icons.manage_search_rounded,
                label: 'Buscar solicitud',
                onTap: onViewRequests,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: const Color(0xB3FFFFFF), size: 19),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11),
      ),
    ],
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 21),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: AppColors.primaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 13),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $name',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 3),
            Text(
              'Tu centro de crédito personal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications_none_rounded),
      ),
    ],
  );
}

class _ProfileProgressCard extends StatelessWidget {
  const _ProfileProgressCard({required this.complete, this.onTap});
  final bool complete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = complete ? AppColors.success : AppColors.warning;
    final soft = complete ? AppColors.successSoft : AppColors.warningSoft;
    return Material(
      color: soft,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  complete
                      ? Icons.verified_rounded
                      : Icons.assignment_ind_rounded,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complete
                          ? 'Perfil listo para evaluación'
                          : 'Completa tu perfil',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      complete
                          ? 'Tu información está al día.'
                          : 'Mejora tus opciones con las cooperativas.',
                      style: TextStyle(
                        color: color.withValues(alpha: .92),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (!complete) Icon(Icons.arrow_forward_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
