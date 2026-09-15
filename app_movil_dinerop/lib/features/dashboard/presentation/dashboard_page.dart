import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../credit/data/models/client_credit_request.dart';
import '../../credit/data/models/credit_enums.dart';
import '../../../core/widgets/cooperative_logo_marquee.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final requests = ref.watch(dashboardCreditRequestsProvider);
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);
    final profileComplete = onboarding.valueOrNull?.formularioCompleto == true;

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
            children: [
              const CooperativeLogoMarquee(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardReveal(
                      child: profile.when(
                        data: (data) => _WelcomeHeader(
                          name: data.firstName?.trim().isNotEmpty == true
                              ? data.firstName!.trim()
                              : 'cliente',
                          profileComplete: profileComplete,
                        ),
                        loading: () => _WelcomeHeader(
                          name: 'cliente',
                          profileComplete: profileComplete,
                        ),
                        error: (_, _) => _WelcomeHeader(
                          name: 'cliente',
                          profileComplete: profileComplete,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    onboarding.when(
                      data: (status) => status.formularioCompleto
                          ? const SizedBox.shrink()
                          : _ProfileProgressCard(
                              complete: false,
                              onTap: () => context.push('/onboarding'),
                            ),
                      loading: () => const SizedBox(
                        height: 70,
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
                      data: (items) => _DashboardContent(
                        requests: items,
                        profileComplete: profileComplete,
                        onViewRequests: () => context.go('/requests'),
                        onRequestCredit: () => context.push('/request-credit'),
                      ),
                      loading: () =>
                          const AppLoader(label: 'Cargando tu actividad...'),
                      error: (error, _) => AppErrorView(
                        message: error is AppException
                            ? error.message
                            : AppErrorMessages.generic,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.requests,
    required this.profileComplete,
    required this.onViewRequests,
    required this.onRequestCredit,
  });

  final List<ClientCreditRequestSummary> requests;
  final bool profileComplete;
  final VoidCallback onViewRequests;
  final VoidCallback onRequestCredit;

  @override
  Widget build(BuildContext context) {
    final latestRequest = _latestRequest(requests);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashboardReveal(
          delay: const Duration(milliseconds: 100),
          child: _CreditProgressSection(
            request: latestRequest,
            profileComplete: profileComplete,
          ),
        ),
        const SizedBox(height: 20),
        _CurrentStatusCard(
          request: latestRequest,
          onViewRequests: onViewRequests,
          onRequestCredit: onRequestCredit,
        ),
        const SizedBox(height: 22),
        Text(
          'Acciones',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_rounded,
                label: 'Solicitar crédito',
                onTap: onRequestCredit,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAction(
                icon: Icons.receipt_long_outlined,
                label: 'Mis solicitudes',
                onTap: onViewRequests,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _RecentRequests(
          requests: requests,
          onViewRequests: onViewRequests,
          onRequestCredit: onRequestCredit,
        ),
      ],
    );
  }
}

ClientCreditRequestSummary? _latestRequest(
  List<ClientCreditRequestSummary> requests,
) {
  if (requests.isEmpty) return null;
  final sorted = [...requests]
    ..sort((a, b) {
      if (a.fechaSolicitud == null && b.fechaSolicitud == null) return 0;
      if (a.fechaSolicitud == null) return 1;
      if (b.fechaSolicitud == null) return -1;
      return b.fechaSolicitud!.compareTo(a.fechaSolicitud!);
    });
  return sorted.first;
}

class _CreditProgressSection extends StatelessWidget {
  const _CreditProgressSection({
    required this.request,
    required this.profileComplete,
  });

  final ClientCreditRequestSummary? request;
  final bool profileComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step = _progressStep(request, profileComplete);
    final progress = step / 4;
    final labels = ['Perfil', 'Solicitud', 'Evaluación', 'Resultado'];

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu proceso de crédito',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            request == null
                ? 'Completa tu perfil para comenzar.'
                : _progressDescription(request!.estado),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: value,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (var index = 1; index <= labels.length; index++) ...[
                Expanded(
                  child: _ProgressStage(
                    label: labels[index - 1],
                    active: index <= step,
                    current: index == step,
                    delay: Duration(milliseconds: index * 90),
                  ),
                ),
                if (index != labels.length) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$step de 4 etapas completadas',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

int _progressStep(ClientCreditRequestSummary? request, bool profileComplete) {
  if (!profileComplete) return 0;
  if (request == null) return 1;
  switch (request.estado) {
    case CreditRequestStatus.creada:
      return 2;
    case CreditRequestStatus.enviada:
    case CreditRequestStatus.solicitandoGarante:
      return 3;
    case CreditRequestStatus.preAprobada:
    case CreditRequestStatus.aceptada:
    case CreditRequestStatus.rechazada:
      return 4;
    case CreditRequestStatus.unknown:
      return 2;
  }
}

String _progressDescription(CreditRequestStatus status) {
  switch (status) {
    case CreditRequestStatus.creada:
      return 'Tu solicitud está lista para ser enviada.';
    case CreditRequestStatus.enviada:
    case CreditRequestStatus.solicitandoGarante:
      return 'Tu solicitud está en evaluación.';
    case CreditRequestStatus.preAprobada:
      return 'Tu solicitud tiene una pre aprobación.';
    case CreditRequestStatus.aceptada:
      return 'Tu crédito ha sido aceptado.';
    case CreditRequestStatus.rechazada:
      return 'La solicitud terminó con una decisión.';
    case CreditRequestStatus.unknown:
      return 'Estamos actualizando el estado de tu solicitud.';
  }
}

class _ProgressStage extends StatelessWidget {
  const _ProgressStage({
    required this.label,
    required this.active,
    required this.current,
    required this.delay,
  });

  final String label;
  final bool active;
  final bool current;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active ? AppColors.success : theme.colorScheme.outline;
    return _DelayedFade(
      delay: delay,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: current ? 28 : 22,
            height: current ? 28 : 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? color.withValues(alpha: 0.12) : null,
              border: Border.all(color: color, width: current ? 2 : 1.5),
            ),
            child: Icon(
              active && !current
                  ? Icons.check_rounded
                  : current
                  ? Icons.circle
                  : Icons.circle_outlined,
              size: current ? 10 : 15,
              color: color,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: active
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard({
    required this.request,
    required this.onViewRequests,
    required this.onRequestCredit,
  });

  final ClientCreditRequestSummary? request;
  final VoidCallback onViewRequests;
  final VoidCallback onRequestCredit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = request == null
        ? null
        : _statusPresentation(request!.estado);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _SurfacePanel(
        key: ValueKey(request?.estado ?? 'empty'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              status?.icon ?? Icons.add_task_rounded,
              color: status?.color ?? AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status?.title ?? 'Aún no tienes una solicitud',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status?.description ?? 'Solicita tu primer crédito.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: request == null
                        ? onRequestCredit
                        : onViewRequests,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text(
                      request == null ? 'Solicitar crédito' : 'Ver seguimiento',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPresentation {
  const _StatusPresentation(
    this.title,
    this.description,
    this.color,
    this.icon,
  );

  final String title;
  final String description;
  final Color color;
  final IconData icon;
}

_StatusPresentation _statusPresentation(CreditRequestStatus status) {
  switch (status) {
    case CreditRequestStatus.preAprobada:
      return const _StatusPresentation(
        '¡Tienes una pre aprobación!',
        'Tu solicitud está lista para el siguiente paso.',
        AppColors.success,
        Icons.verified_rounded,
      );
    case CreditRequestStatus.aceptada:
      return const _StatusPresentation(
        '¡Crédito aceptado!',
        'Tu solicitud fue aceptada por la cooperativa.',
        AppColors.success,
        Icons.check_circle_rounded,
      );
    case CreditRequestStatus.rechazada:
      return const _StatusPresentation(
        'Solicitud no aprobada',
        'La solicitud terminó con una decisión.',
        AppColors.error,
        Icons.cancel_outlined,
      );
    case CreditRequestStatus.creada:
      return const _StatusPresentation(
        'Solicitud creada',
        'Tu solicitud está lista para ser enviada.',
        AppColors.warning,
        Icons.edit_note_rounded,
      );
    case CreditRequestStatus.enviada:
    case CreditRequestStatus.solicitandoGarante:
      return const _StatusPresentation(
        'Solicitud en evaluación',
        'Estamos revisando tu solicitud.',
        AppColors.warning,
        Icons.hourglass_top_rounded,
      );
    case CreditRequestStatus.unknown:
      return const _StatusPresentation(
        'Solicitud en proceso',
        'Estamos actualizando el estado de tu solicitud.',
        AppColors.info,
        Icons.sync_rounded,
      );
  }
}

class _RecentRequests extends StatelessWidget {
  const _RecentRequests({
    required this.requests,
    required this.onViewRequests,
    required this.onRequestCredit,
  });

  final List<ClientCreditRequestSummary> requests;
  final VoidCallback onViewRequests;
  final VoidCallback onRequestCredit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = [...requests]
      ..sort(
        (a, b) => (b.fechaSolicitud ?? DateTime(0)).compareTo(
          a.fechaSolicitud ?? DateTime(0),
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Mis solicitudes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (requests.isNotEmpty)
              TextButton(
                onPressed: onViewRequests,
                child: const Text('Ver todas'),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (recent.isEmpty)
          _SurfacePanel(
            child: Row(
              children: [
                const Icon(Icons.inbox_outlined, color: AppColors.textMuted),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tus solicitudes aparecerán aquí.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )
        else
          ...recent
              .take(3)
              .map(
                (request) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RequestTile(request: request, onTap: onViewRequests),
                ),
              ),
      ],
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request, required this.onTap});

  final ClientCreditRequestSummary request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = _statusPresentation(request.estado);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitud de crédito',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatCurrency(request.monto),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(status.icon, color: status.color, size: 15),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _shortStatus(request.estado),
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: status.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

String _shortStatus(CreditRequestStatus status) {
  switch (status) {
    case CreditRequestStatus.preAprobada:
      return 'Pre aprobada';
    case CreditRequestStatus.aceptada:
      return 'Aceptada';
    case CreditRequestStatus.rechazada:
      return 'Rechazada';
    case CreditRequestStatus.creada:
      return 'Creada';
    case CreditRequestStatus.enviada:
      return 'En evaluación';
    case CreditRequestStatus.solicitandoGarante:
      return 'Solicitando garante';
    case CreditRequestStatus.unknown:
      return 'En proceso';
  }
}

class _SurfacePanel extends StatelessWidget {
  const _SurfacePanel({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardReveal extends StatelessWidget {
  const _DashboardReveal({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return _DelayedFade(delay: delay, child: child);
  }
}

class _DelayedFade extends StatefulWidget {
  const _DelayedFade({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_DelayedFade> createState() => _DelayedFadeState();
}

class _DelayedFadeState extends State<_DelayedFade> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.04),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.name, this.profileComplete = false});

  final String name;
  final bool profileComplete;

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
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),

            if (profileComplete) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 17,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Perfil completo',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 3),

            Text(
              'Tu centro de crédito personal',
              overflow: TextOverflow.ellipsis,
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
