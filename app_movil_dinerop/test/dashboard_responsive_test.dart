import 'package:app_movil_dinerop/features/credit/data/models/client_credit_request.dart';
import 'package:app_movil_dinerop/features/credit/data/models/credit_enums.dart';
import 'package:app_movil_dinerop/features/dashboard/presentation/sections/dashboard_exploration_sections.dart';
import 'package:app_movil_dinerop/app/providers.dart';
import 'package:app_movil_dinerop/app/shell/app_shell.dart';
import 'package:app_movil_dinerop/features/dolarito/providers/dolarito_provider.dart';
import 'package:app_movil_dinerop/features/investment/data/models/investment_models.dart';
import 'package:app_movil_dinerop/features/investment/providers/investment_providers.dart';
import 'package:app_movil_dinerop/features/onboarding/presentation/onboarding_welcome_experience.dart';
import 'package:app_movil_dinerop/features/requests/presentation/requests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  const widths = [320.0, 360.0, 390.0, 430.0];
  final requests = [
    ClientCreditRequestSummary(
      solicitudId: 101,
      estado: CreditRequestStatus.enviada,
      monto: 2500,
      tipo: 'CREDITO',
      fechaSolicitud: DateTime(2026, 11, 14),
      cantidadSolicitudesEnviadas: 1,
    ),
    ClientCreditRequestSummary(
      solicitudId: 99,
      estado: CreditRequestStatus.solicitandoGarante,
      monto: 1800,
      tipo: 'CREDITO',
      fechaSolicitud: DateTime(2026, 10, 10),
      cantidadSolicitudesEnviadas: 1,
    ),
  ];
  InvestmentRequest investment({int id = 501, String status = 'IN_REVIEW'}) =>
      InvestmentRequest(
        id: id,
        cooperativeId: 8,
        cooperativeName: 'Cooperativa Sol',
        cooperativeLogoUrl: null,
        productName: 'Depósito a plazo',
        productDescription: null,
        amount: 1500,
        termMonths: 12,
        interestPaymentOption: null,
        annualRate: 7.5,
        rateValidUntil: null,
        calculationMethod: 'FIXED',
        estimatedInterest: 112.5,
        estimatedTotal: 1612.5,
        renewalConditions: null,
        earlyCancellationConditions: null,
        status: status,
        statusNote: null,
        events: const [],
        acceptance: null,
        createdAt: DateTime(2026, 11, 10),
        updatedAt: DateTime(2026, 11, 12),
      );

  for (final width in widths) {
    testWidgets('authenticated header and bottom navigation fit at $width px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 850);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/dashboard',
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (_, _) => const Text('Dashboard route'),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dolaritoProvider.overrideWith((ref) => DolaritoNotifier()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('DINEROP'), findsOneWidget);
      expect(find.byTooltip('Ayuda y soporte'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dashboard quick actions and credit cards fit at $width px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                ActiveCreditCarousel(
                  requests: requests,
                  profileComplete: true,
                  onRequestCredit: () {},
                  onViewDetails: (_) {},
                ),
                const SizedBox(height: 14),
                const QuickActionsGrid(),
                const SizedBox(height: 14),
                RecentCreditActivity(
                  requests: requests,
                  onViewAll: () {},
                  onOpenRequest: (_) {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Solicitar crédito'), findsOneWidget);
      expect(find.text('Realizar inversión'), findsOneWidget);
      expect(find.text('Revisar buró'), findsOneWidget);
      expect(find.text('Mis solicitudes'), findsOneWidget);
      expect(find.text('Simulador'), findsOneWidget);
      expect(find.text('Mi perfil'), findsOneWidget);
      final firstX = tester
          .getTopLeft(
            find.byKey(const ValueKey('quick-action-Solicitar crédito')),
          )
          .dx;
      final secondX = tester
          .getTopLeft(
            find.byKey(const ValueKey('quick-action-Realizar inversión')),
          )
          .dx;
      final thirdX = tester
          .getTopLeft(find.byKey(const ValueKey('quick-action-Revisar buró')))
          .dx;
      final firstRowY = tester
          .getTopLeft(
            find.byKey(const ValueKey('quick-action-Solicitar crédito')),
          )
          .dy;
      final secondRowY = tester
          .getTopLeft(
            find.byKey(const ValueKey('quick-action-Mis solicitudes')),
          )
          .dy;
      expect(firstX, lessThan(secondX));
      expect(secondX, lessThan(thirdX));
      expect(secondRowY, greaterThan(firstRowY));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('credit carousel changes its page indicator when swiped', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActiveCreditCarousel(
            requests: requests,
            profileComplete: true,
            onRequestCredit: () {},
            onViewDetails: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 de 2'), findsOneWidget);
    expect(
      find.text('Estamos esperando una respuesta de la cooperativa.'),
      findsOneWidget,
    );

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 de 2'), findsOneWidget);
    expect(
      find.text(
        'La cooperativa necesita información de un garante. Te acompaño para revisar qué debes completar.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard selector shows real investments and opens selection', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int? openedCreditId;
    int? openedInvestmentId;
    var exploredInvestments = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardApplicationsSection(
            creditRequests: AsyncData<List<ClientCreditRequestSummary>>(
              requests,
            ),
            investmentRequests: AsyncData<List<InvestmentRequest>>([
              investment(),
              investment(id: 502, status: 'INFORMATION_REQUIRED'),
            ]),
            profileComplete: true,
            onRequestCredit: () {},
            onCreditDetails: (request) => openedCreditId = request.solicitudId,
            onInvestmentDetails: (request) => openedInvestmentId = request.id,
            onRequestInvestment: () => exploredInvestments = true,
            onRetryCredits: () {},
            onRetryInvestments: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mis créditos'), findsOneWidget);
    await tester.tap(find.text('Ver detalles  →').first);
    expect(openedCreditId, 101);

    await tester.tap(find.text('Inversiones'));
    await tester.pumpAndSettle();
    expect(find.text('Mis inversiones'), findsOneWidget);
    expect(find.text('Cooperativa Sol'), findsWidgets);
    expect(find.text('En revisión'), findsOneWidget);
    expect(
      find.text(
        'La cooperativa está revisando tu solicitud. Te avisaremos cuando responda.',
      ),
      findsOneWidget,
    );

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('Requiere información'), findsOneWidget);
    expect(
      find.text(
        'La cooperativa necesita información adicional. Revisa el mensaje de tu solicitud para ver qué debes hacer.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Ver detalles  →').last);
    expect(openedInvestmentId, 502);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardApplicationsSection(
            creditRequests: AsyncData<List<ClientCreditRequestSummary>>(
              requests,
            ),
            investmentRequests: const AsyncData<List<InvestmentRequest>>([]),
            profileComplete: true,
            onRequestCredit: () {},
            onRequestInvestment: () => exploredInvestments = true,
            onCreditDetails: (_) {},
            onInvestmentDetails: (_) {},
            onRetryCredits: () {},
            onRetryInvestments: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inversiones'));
    await tester.pumpAndSettle();
    expect(
      find.text('Todavía no tienes inversiones solicitadas.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Explorar inversiones'));
    expect(exploredInvestments, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onboarding spotlight closes back to the orange reminder', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: _SpotlightTestHarness()));
    await tester.pumpAndSettle();
    expect(find.text('¡No dejes tus solicitudes en pausa!'), findsNWidgets(2));
    expect(find.byTooltip('Cerrar'), findsOneWidget);
    final normalCardSize = tester.getSize(
      find.byKey(const ValueKey('profile-card-normal')),
    );
    final spotlightCardSize = tester.getSize(
      find.byKey(const ValueKey('profile-card-spotlight')),
    );
    expect(spotlightCardSize, normalCardSize);
    expect(
      find.text(
        'Completa tu perfil para que las cooperativas revisen tus solicitudes y te compartan novedades en DINEROP.',
      ),
      findsNWidgets(2),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('onboarding-spotlight-scrim'))),
      const Size(320, 850),
    );
    expect(find.text('Dashboard stays visible'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();
    expect(find.text('¡No dejes tus solicitudes en pausa!'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 7));
    await tester.pump(const Duration(milliseconds: 180));
    final shake = tester.widget<Transform>(
      find
          .ancestor(
            of: find.text('¡No dejes tus solicitudes en pausa!').last,
            matching: find.byType(Transform),
          )
          .first,
    );
    expect(shake.transform.storage[12], isNot(closeTo(0, .1)));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('investment detail route opens the requested investment id', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          requestsProvider.overrideWith((ref) async => requests),
          investmentRequestsProvider.overrideWith(
            (ref) async => [investment(id: 502)],
          ),
          dolaritoProvider.overrideWith((ref) => DolaritoNotifier()),
        ],
        child: const MaterialApp(home: RequestsPage(initialInvestmentId: 502)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Detalle de inversión'), findsOneWidget);
    expect(find.text('Cooperativa Sol'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'credit progress shows four stages and maps real request statuses',
    (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveCreditCarousel(
              requests: [requests.first],
              profileComplete: true,
              onRequestCredit: () {},
              onViewDetails: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final stage in ['Perfil', 'Solicitud', 'Evaluación', 'Resultado']) {
        expect(find.text(stage), findsOneWidget);
      }

      const statusCases = [
        (CreditRequestStatus.creada, 'Creada'),
        (CreditRequestStatus.enviada, 'En evaluación'),
        (CreditRequestStatus.solicitandoGarante, 'Garante requerido'),
        (CreditRequestStatus.preAprobada, 'Preaprobada'),
        (CreditRequestStatus.aceptada, 'Aceptada'),
        (CreditRequestStatus.rechazada, 'Rechazada'),
        (CreditRequestStatus.unknown, 'En proceso'),
      ];

      for (final (status, label) in statusCases) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecentCreditActivity(
                requests: [
                  ClientCreditRequestSummary(
                    solicitudId: 1,
                    estado: status,
                    monto: 1000,
                    tipo: 'CREDITO',
                    fechaSolicitud: DateTime(2026, 11, 1),
                    cantidadSolicitudesEnviadas: 1,
                  ),
                ],
                onViewAll: () {},
                onOpenRequest: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('accepted and rejected credits show the result stage', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final (status, label) in [
      (CreditRequestStatus.aceptada, 'Aceptada'),
      (CreditRequestStatus.rechazada, 'Rechazada'),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActiveCreditCarousel(
              requests: [
                ClientCreditRequestSummary(
                  solicitudId: 101,
                  estado: status,
                  monto: 2500,
                  tipo: 'CREDITO',
                  fechaSolicitud: DateTime(2026, 11, 14),
                  cantidadSolicitudesEnviadas: 1,
                ),
              ],
              profileComplete: false,
              onRequestCredit: () {},
              onViewDetails: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(label), findsOneWidget);
      final resultLabel = tester.widget<Text>(find.text('Resultado'));
      expect(resultLabel.style?.fontWeight, FontWeight.w900);
      if (status == CreditRequestStatus.aceptada) {
        expect(
          find.byKey(const ValueKey('accepted-credit-confetti')),
          findsOneWidget,
        );
        expect(
          find.text(
            '¡Buenas noticias! Tu solicitud fue aceptada. Revisa los requisitos y los siguientes pasos.',
          ),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'navigation shell exposes five destinations and keeps products pending',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/dashboard',
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (_, _) => const Text('Dashboard route'),
              ),
              GoRoute(
                path: '/requests',
                builder: (_, _) => const Text('Requests route'),
              ),
              GoRoute(
                path: '/cooperatives',
                builder: (_, _) => const Text('Cooperatives route'),
              ),
              GoRoute(
                path: '/profile',
                builder: (_, _) => const Text('Profile route'),
              ),
              GoRoute(
                path: '/notifications',
                builder: (_, _) => const Text('Notifications route'),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dolaritoProvider.overrideWith((ref) => DolaritoNotifier()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Productos'), findsOneWidget);
      expect(find.text('Solicitudes'), findsOneWidget);
      expect(find.text('Coop.'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.byTooltip('Notificaciones'), findsOneWidget);

      await tester.tap(find.text('Productos'));
      await tester.pumpAndSettle();
      expect(
        find.text('La sección Productos estará disponible próximamente.'),
        findsOneWidget,
      );
      expect(find.text('Dashboard route'), findsOneWidget);
    },
  );
}

class _SpotlightTestHarness extends StatefulWidget {
  const _SpotlightTestHarness();

  @override
  State<_SpotlightTestHarness> createState() => _SpotlightTestHarnessState();
}

class _SpotlightTestHarnessState extends State<_SpotlightTestHarness> {
  bool _showSpotlight = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text('Dashboard stays visible'),
          OnboardingWelcomeExperience(
            isFirstWelcome: true,
            showSpotlight: _showSpotlight,
            onDismiss: () => setState(() => _showSpotlight = false),
            onCompleteProfile: () {},
          ),
        ],
      ),
    ),
  );
}
