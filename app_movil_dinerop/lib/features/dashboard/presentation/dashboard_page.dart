import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/widgets/cooperative_logo_marquee.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../dolarito/models/dolarito_reaction.dart';
import '../../dolarito/providers/dolarito_provider.dart';
import '../../dolarito/widgets/dolarito_widget.dart';
import '../../auth/presentation/auth_controller.dart';
import 'sections/dashboard_exploration_sections.dart';

const _navy = Color(0xFF142B4A);
const _muted = Color(0xFF718096);

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final requests = ref.watch(dashboardCreditRequestsProvider);
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);
    final dolaritoService = ref.watch(dolaritoServiceProvider);
    final dolaritoState = ref.watch(dolaritoProvider);
    final profileComplete = onboarding.valueOrNull?.formularioCompleto == true;
    DolaritoReaction? dolaritoReaction;
    if (onboarding.hasError) {
      dolaritoReaction = dolaritoService.profileStatusError();
    } else if (onboarding.valueOrNull?.formularioCompleto == false) {
      dolaritoReaction = dolaritoService.onboardingRequired();
    } else if (profileComplete && requests.hasError) {
      dolaritoReaction = dolaritoService.creditLoadError();
    } else if (profileComplete && requests.hasValue) {
      dolaritoReaction = dolaritoService.dashboard(
        profileComplete: true,
        requests: requests.value ?? const [],
      );
      final latest = [...?requests.value]
        ..sort(
          (a, b) => (b.fechaSolicitud ?? DateTime(0)).compareTo(
            a.fechaSolicitud ?? DateTime(0),
          ),
        );
      if (latest.isNotEmpty &&
          dolaritoState.scopeKey == 'credit:${latest.first.solicitudId}' &&
          dolaritoState.eventId > 0) {
        dolaritoReaction = dolaritoState.toReaction();
      }
    } else if (profileComplete) {
      dolaritoReaction = dolaritoService.profileComplete();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
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
            padding: const EdgeInsets.only(bottom: 22),
            children: [
              const SizedBox(height: 7),
              const CooperativeLogoMarquee(height: 62, logoSize: 126, gap: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profile.when(
                      data: (data) => _DashboardGreeting(
                        name: data.firstName?.trim().isNotEmpty == true
                            ? data.firstName!.trim()
                            : 'cliente',
                      ),
                      loading: () => const _DashboardGreeting(name: 'cliente'),
                      error: (_, _) =>
                          const _DashboardGreeting(name: 'cliente'),
                    ),
                    const SizedBox(height: 7),
                    onboarding.when(
                      data: (status) => ProfileStatusRow(
                        complete: status.formularioCompleto,
                        onComplete: () => context.push('/onboarding'),
                      ),
                      loading: () => const Row(
                        children: [
                          SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Verificando perfil...',
                            style: TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                      error: (error, _) => Text(
                        error is AppException
                            ? error.message
                            : 'No pudimos comprobar tu perfil.',
                        style: const TextStyle(color: _muted, fontSize: 11),
                      ),
                    ),
                    if (dolaritoReaction != null) ...[
                      const SizedBox(height: 12),
                      DolaritoWidget(
                        mood: dolaritoReaction.mood,
                        message: dolaritoReaction.message,
                        compact: true,
                        imageSize: 58,
                        actionLabel: dolaritoReaction.actionLabel,
                        onAction: switch (dolaritoReaction.action) {
                          DolaritoAction.completeProfile => () => context.push(
                            '/onboarding',
                          ),
                          DolaritoAction.viewRequests => () => context.go(
                            '/requests',
                          ),
                          DolaritoAction.retry => () {
                            ref.invalidate(dashboardOnboardingStatusProvider);
                            ref.invalidate(dashboardCreditRequestsProvider);
                          },
                          null => null,
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    requests.when(
                      data: (items) => ActiveCreditCarousel(
                        requests: items,
                        profileComplete: profileComplete,
                        onRequestCredit: () => context.push('/request-credit'),
                        onViewDetails: (_) => context.go('/requests'),
                      ),
                      loading: () => const _CreditLoadingState(),
                      error: (error, _) => AppErrorView(
                        message: error is AppException
                            ? error.message
                            : 'No pudimos cargar tus créditos.',
                      ),
                    ),
                    const SizedBox(height: 21),
                    const QuickActionsGrid(),
                    const SizedBox(height: 22),
                    requests.when(
                      data: (items) => RecentCreditActivity(
                        requests: items,
                        onViewAll: () => context.go('/requests'),
                        onOpenRequest: (_) => context.go('/requests'),
                      ),
                      loading: () => const _ActivityLoadingState(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
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

class _DashboardGreeting extends StatelessWidget {
  const _DashboardGreeting({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final firstLetter = name.trim().isEmpty
        ? 'D'
        : name.trim()[0].toUpperCase();
    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F8F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            firstLetter,
            style: const TextStyle(
              color: Color(0xFF128E80),
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, $name! 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 18,
                  letterSpacing: -.3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Nos alegra tenerte de vuelta.',
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreditLoadingState extends StatelessWidget {
  const _CreditLoadingState();

  @override
  Widget build(BuildContext context) => Container(
    height: 215,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: const Color(0xFFE8EDF3)),
    ),
    child: const Center(
      child: AppLoader(label: 'Cargando tu último crédito...'),
    ),
  );
}

class _ActivityLoadingState extends StatelessWidget {
  const _ActivityLoadingState();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Tu actividad reciente',
        style: TextStyle(
          color: _navy,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EDF3)),
        ),
        child: const Center(child: AppLoader(label: 'Cargando actividad...')),
      ),
    ],
  );
}
