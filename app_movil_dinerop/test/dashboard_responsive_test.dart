import 'package:app_movil_dinerop/features/dashboard/presentation/sections/dashboard_exploration_sections.dart';
import 'package:app_movil_dinerop/features/notifications/presentation/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const widths = [320.0, 360.0, 430.0];

  for (final width in widths) {
    testWidgets('dashboard sections fit a $width px viewport', (tester) async {
      tester.view.physicalSize = Size(width, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                ProductShowcaseSection(),
                FinanceToolsSection(),
                CreditHealthCard(),
                FinancialEducationSection(),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('notification page fits a $width px viewport', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: NotificationsPage()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
