import 'package:app_movil_dinerop/features/credit/data/models/client_credit_request.dart';
import 'package:app_movil_dinerop/features/credit/data/models/credit_enums.dart';
import 'package:app_movil_dinerop/features/dashboard/presentation/sections/dashboard_exploration_sections.dart';
import 'package:app_movil_dinerop/app/shell/app_shell.dart';
import 'package:app_movil_dinerop/features/dolarito/providers/dolarito_provider.dart';
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
                const ProfileStatusRow(complete: false),
                const SizedBox(height: 14),
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

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 de 2'), findsOneWidget);
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
            '¡Felicidades! Tu crédito fue aceptado. Revisa los requisitos para retirarlo.',
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
