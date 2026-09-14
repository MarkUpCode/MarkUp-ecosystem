import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../credit/presentation/widgets/credit_request_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final requests = ref.watch(dashboardCreditRequestsProvider);
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);
    final theme = Theme.of(context);

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tu actividad',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/requests'),
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                  return Column(
                    children: items
                        .take(2)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: CreditRequestCard(
                              request: item,
                              compact: true,
                              onTap: () => context.go('/requests'),
                            ),
                          ),
                        )
                        .toList(),
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
