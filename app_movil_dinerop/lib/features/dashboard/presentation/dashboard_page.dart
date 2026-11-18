import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/widgets/cooperative_logo_marquee.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../onboarding/presentation/onboarding_welcome_experience.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../investment/providers/investment_providers.dart';
import 'sections/dashboard_exploration_sections.dart';

const _navy = Color(0xFF142B4A);
const _muted = Color(0xFF718096);
const _dashboardWelcomeMessages = [
  '¡Qué gusto tenerte de vuelta!',
  '¡Volviste! Dolarito ya te guardó sitio.',
  'Tus metas financieras preguntaban por ti.',
  '¡Qué bueno verte! Vamos paso a paso.',
  'Dolarito dice: hoy pinta bien para avanzar.',
];

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final profile = ref.watch(clientProfileProvider);
    final requests = ref.watch(dashboardCreditRequestsProvider);
    final investments = ref.watch(investmentRequestsProvider);
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);
    final welcomeDismissed = ref.watch(onboardingWelcomeDismissedProvider);
    final firstWelcome = ref.watch(onboardingWelcomeIsFirstProvider);
    final profileComplete = onboarding.valueOrNull?.formularioCompleto == true;
    final profileProgress = onboarding.valueOrNull == null
        ? null
        : (profileComplete ? 1.0 : 0.7);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(clientProfileProvider);
                ref.invalidate(dashboardCreditRequestsProvider);
                ref.invalidate(investmentRequestsProvider);
                ref.invalidate(dashboardOnboardingStatusProvider);
                await auth.refreshOnboardingState();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 22),
                children: [
                  const SizedBox(height: 7),
                  const CooperativeLogoMarquee(
                    height: 62,
                    logoSize: 126,
                    gap: 10,
                  ),
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
                            profileProgress: profileProgress,
                          ),
                          loading: () => _DashboardGreeting(
                            name: 'cliente',
                            profileProgress: profileProgress,
                          ),
                          error: (_, _) => _DashboardGreeting(
                            name: 'cliente',
                            profileProgress: profileProgress,
                          ),
                        ),
                        const SizedBox(height: 7),
                        if (onboarding.valueOrNull?.formularioCompleto ==
                            false) ...[
                          const SizedBox(height: 13),
                          OnboardingWelcomeExperience(
                            isFirstWelcome: firstWelcome,
                            showSpotlight: !welcomeDismissed,
                            onDismiss: () =>
                                ref
                                        .read(
                                          onboardingWelcomeDismissedProvider
                                              .notifier,
                                        )
                                        .state =
                                    true,
                            onCompleteProfile: () {
                              ref
                                      .read(
                                        onboardingWelcomeDismissedProvider
                                            .notifier,
                                      )
                                      .state =
                                  true;
                              context.push('/onboarding');
                            },
                          ),
                        ],
                        const SizedBox(height: 20),
                        DashboardApplicationsSection(
                          creditRequests: requests,
                          investmentRequests: investments,
                          profileComplete: profileComplete,
                          onRequestCredit: () =>
                              context.push('/request-credit'),
                          onRequestInvestment: () =>
                              context.push('/simulate-investment'),
                          onCreditDetails: (request) => context.push(
                            '/requests',
                            extra: {'creditId': request.solicitudId},
                          ),
                          onInvestmentDetails: (request) => context.push(
                            '/requests',
                            extra: {'investmentId': request.id},
                          ),
                          onRetryCredits: () =>
                              ref.invalidate(dashboardCreditRequestsProvider),
                          onRetryInvestments: () =>
                              ref.invalidate(investmentRequestsProvider),
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
        ),
      ],
    );
  }
}

class _DashboardGreeting extends StatelessWidget {
  const _DashboardGreeting({required this.name, required this.profileProgress});

  final String name;
  final double? profileProgress;

  @override
  Widget build(BuildContext context) {
    final welcomeMessage =
        _dashboardWelcomeMessages[DateTime.now().day %
            _dashboardWelcomeMessages.length];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/dolarito/dolarito_greeting.png',
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, $name!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 17,
                  letterSpacing: -.3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 11,
                    color: Color(0xFF16A995),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      welcomeMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: profileProgress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFE5ECEF),
                        valueColor: AlwaysStoppedAnimation(
                          profileProgress == 1
                              ? const Color(0xFF16845B)
                              : const Color(0xFF16A995),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  if (profileProgress == 1)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Color(0xFF16845B),
                    ),
                  if (profileProgress == 1) const SizedBox(width: 3),
                  Text(
                    profileProgress == null
                        ? '…'
                        : '${(profileProgress! * 100).round()}%',
                    style: TextStyle(
                      color: profileProgress == 1
                          ? const Color(0xFF16845B)
                          : _navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
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
