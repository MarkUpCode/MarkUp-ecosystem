import 'package:flutter_test/flutter_test.dart';
import 'package:app_movil_dinerop/core/notifications/push_notification_service.dart';
import 'package:app_movil_dinerop/features/credit/data/models/credit_enums.dart';
import 'package:app_movil_dinerop/features/dolarito/models/dolarito_mood.dart';
import 'package:app_movil_dinerop/features/dolarito/models/dolarito_reaction.dart';
import 'package:app_movil_dinerop/features/dolarito/providers/dolarito_provider.dart';
import 'package:app_movil_dinerop/features/dolarito/services/dolarito_service.dart';

void main() {
  const service = DolaritoService();

  group('DolaritoService', () {
    test('onboarding incomplete is a critical guided state', () {
      final reaction = service.onboardingRequired();

      expect(reaction.priority, DolaritoPriority.critical);
      expect(reaction.action, DolaritoAction.completeProfile);
      expect(reaction.message, contains('completemos tu perfil'));
    });

    test('pre-approved credit is not described as fully accepted', () {
      final reaction = service.creditStatus(
        CreditRequestStatus.preAprobada,
        requestId: 41,
      );

      expect(reaction.mood, DolaritoMood.excited);
      expect(reaction.message, contains('preaprobada'));
      expect(reaction.event, DolaritoEvent.creditPreApproved);
    });

    test('unknown status does not claim a decision', () {
      final reaction = service.creditStatus(
        CreditRequestStatus.unknown,
        requestId: 42,
      );

      expect(reaction.mood, DolaritoMood.thinking);
      expect(reaction.event, DolaritoEvent.informationPending);
      expect(reaction.message, contains('no puedo identificar'));
    });

    test('accepted notification is scoped to its request', () {
      final reaction = service.notification(
        const PushNotificationEvent(
          type: 'CREDIT_ACCEPTED',
          title: null,
          body: null,
          opened: true,
          solicitudId: 73,
        ),
      );

      expect(reaction.scopeKey, 'credit:73');
      expect(reaction.event, DolaritoEvent.creditAccepted);
      expect(reaction.action, DolaritoAction.viewRequests);
    });
  });

  test('higher priority state is not replaced by an ordinary greeting', () {
    final notifier = DolaritoNotifier();
    notifier.show(service.onboardingRequired());
    notifier.show(service.profileComplete());

    expect(notifier.state.event, DolaritoEvent.onboardingRequired);
    notifier.dispose();
  });
}
