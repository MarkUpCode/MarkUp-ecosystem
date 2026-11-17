import '../../../core/notifications/push_notification_service.dart';
import '../../credit/data/models/client_credit_request.dart';
import '../../credit/data/models/credit_enums.dart';
import '../config/dolarito_messages.dart';
import '../models/dolarito_mood.dart';
import '../models/dolarito_reaction.dart';

class DolaritoService {
  const DolaritoService();

  DolaritoReaction onboardingRequired() => const DolaritoReaction(
    mood: DolaritoMood.explaining,
    message: DolaritoMessages.welcomeIncomplete,
    event: DolaritoEvent.onboardingRequired,
    priority: DolaritoPriority.critical,
    action: DolaritoAction.completeProfile,
    actionLabel: 'Completar mi perfil',
    scopeKey: 'onboarding',
  );

  DolaritoReaction profileComplete() => const DolaritoReaction(
    mood: DolaritoMood.proud,
    message: DolaritoMessages.profileComplete,
    event: DolaritoEvent.greeting,
    priority: DolaritoPriority.informative,
    scopeKey: 'dashboard',
  );

  DolaritoReaction dashboard({
    required bool profileComplete,
    required List<ClientCreditRequestSummary> requests,
    bool creditLoadFailed = false,
  }) {
    if (!profileComplete) return onboardingRequired();
    if (creditLoadFailed) return creditLoadError();
    if (requests.isEmpty) return this.profileComplete();
    final latest = [...requests]
      ..sort(
        (a, b) => (b.fechaSolicitud ?? DateTime(0)).compareTo(
          a.fechaSolicitud ?? DateTime(0),
        ),
      );
    return creditStatus(
      latest.first.estado,
      requestId: latest.first.solicitudId,
    );
  }

  DolaritoReaction profile({required bool? profileComplete}) {
    if (profileComplete == null) return profileStatusError();
    return profileComplete ? this.profileComplete() : onboardingRequired();
  }

  DolaritoReaction profileStatusError() => const DolaritoReaction(
    mood: DolaritoMood.worried,
    message: DolaritoMessages.connectionProblem,
    event: DolaritoEvent.connectionError,
    priority: DolaritoPriority.alert,
    action: DolaritoAction.retry,
    actionLabel: 'Volver a comprobar',
    dismissible: true,
    scopeKey: 'onboarding',
  );

  DolaritoReaction onboardingStep(int step) {
    if (step >= 4) {
      return const DolaritoReaction(
        mood: DolaritoMood.proud,
        message: '¡Excelente! Ya casi terminamos. Revisa los últimos datos.',
        event: DolaritoEvent.onboardingProgress,
        priority: DolaritoPriority.motivation,
        scopeKey: 'onboarding',
      );
    }
    if (step >= 2) {
      return const DolaritoReaction(
        mood: DolaritoMood.proud,
        message: '¡Excelente! Ya completaste una parte importante.',
        event: DolaritoEvent.onboardingProgress,
        priority: DolaritoPriority.motivation,
        scopeKey: 'onboarding',
      );
    }
    if (step > 0) {
      return const DolaritoReaction(
        mood: DolaritoMood.motivated,
        message: '¡Vamos por buen camino! Sigamos completando tu perfil.',
        event: DolaritoEvent.onboardingProgress,
        priority: DolaritoPriority.motivation,
        scopeKey: 'onboarding',
      );
    }
    return const DolaritoReaction(
      mood: DolaritoMood.explaining,
      message: 'Te acompaño paso a paso. Empecemos con tus datos personales.',
      event: DolaritoEvent.onboardingProgress,
      priority: DolaritoPriority.actionable,
      scopeKey: 'onboarding',
    );
  }

  DolaritoReaction onboardingError(String? detail) => DolaritoReaction(
    mood: DolaritoMood.worried,
    message: detail == null || detail.isEmpty
        ? 'Revisemos este paso juntos. Completa los campos marcados para continuar.'
        : 'Revisemos este paso juntos: $detail',
    event: DolaritoEvent.onboardingError,
    priority: DolaritoPriority.alert,
    dismissible: true,
    scopeKey: 'onboarding',
  );

  DolaritoReaction onboardingCompleted() => const DolaritoReaction(
    mood: DolaritoMood.excited,
    message: DolaritoMessages.onboardingComplete,
    event: DolaritoEvent.onboardingComplete,
    priority: DolaritoPriority.celebration,
    scopeKey: 'onboarding',
  );

  DolaritoReaction creditStatus(CreditRequestStatus status, {int? requestId}) {
    final scope = requestId == null ? 'credit' : 'credit:$requestId';
    switch (status) {
      case CreditRequestStatus.creada:
        return DolaritoReaction(
          mood: DolaritoMood.motivated,
          message:
              'Tu solicitud está creada. Revisa los detalles para conocer el siguiente paso.',
          event: DolaritoEvent.creditCreated,
          priority: DolaritoPriority.informative,
          scopeKey: scope,
        );
      case CreditRequestStatus.enviada:
        return DolaritoReaction(
          mood: DolaritoMood.waiting,
          message: DolaritoMessages.creditPending,
          event: DolaritoEvent.creditPending,
          priority: DolaritoPriority.informative,
          scopeKey: scope,
        );
      case CreditRequestStatus.solicitandoGarante:
        return DolaritoReaction(
          mood: DolaritoMood.explaining,
          message: DolaritoMessages.guaranteeRequired,
          event: DolaritoEvent.guaranteeRequired,
          priority: DolaritoPriority.actionable,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver solicitud',
          scopeKey: scope,
        );
      case CreditRequestStatus.preAprobada:
        return DolaritoReaction(
          mood: DolaritoMood.excited,
          message: DolaritoMessages.creditPreApproved,
          event: DolaritoEvent.creditPreApproved,
          priority: DolaritoPriority.celebration,
          scopeKey: scope,
        );
      case CreditRequestStatus.aceptada:
        return DolaritoReaction(
          mood: DolaritoMood.excited,
          message: DolaritoMessages.creditAccepted,
          event: DolaritoEvent.creditAccepted,
          priority: DolaritoPriority.celebration,
          scopeKey: scope,
        );
      case CreditRequestStatus.rechazada:
        return DolaritoReaction(
          mood: DolaritoMood.sad,
          message: DolaritoMessages.creditRejected,
          event: DolaritoEvent.creditRejected,
          priority: DolaritoPriority.actionable,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver detalles',
          dismissible: true,
          scopeKey: scope,
        );
      case CreditRequestStatus.unknown:
        return DolaritoReaction(
          mood: DolaritoMood.thinking,
          message:
              'Aún no puedo identificar el estado de esta solicitud. Consulta sus detalles para confirmarlo.',
          event: DolaritoEvent.informationPending,
          priority: DolaritoPriority.informative,
          scopeKey: scope,
        );
    }
  }

  DolaritoReaction creditLoadError({int? requestId}) => DolaritoReaction(
    mood: DolaritoMood.worried,
    message:
        'No pude actualizar el estado de esta solicitud. Inténtalo de nuevo más tarde.',
    event: DolaritoEvent.connectionError,
    priority: DolaritoPriority.alert,
    dismissible: true,
    scopeKey: requestId == null ? 'credit' : 'credit:$requestId',
  );

  DolaritoReaction beforeCreditRequest() => const DolaritoReaction(
    mood: DolaritoMood.motivated,
    message:
        'Cuando tu perfil esté completo, te acompaño a revisar las opciones de crédito.',
    event: DolaritoEvent.creditCreated,
    priority: DolaritoPriority.informative,
    scopeKey: 'credit-form',
  );

  DolaritoReaction investmentWelcome() => const DolaritoReaction(
    mood: DolaritoMood.excited,
    message:
        '¡Vamos a descubrir cuánto podría crecer tu dinero! Comparamos las tasas vigentes sin compartir tus datos personales.',
    event: DolaritoEvent.investmentWelcome,
    priority: DolaritoPriority.motivation,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentThinking() => const DolaritoReaction(
    mood: DolaritoMood.thinking,
    message:
        'Cuéntame cuánto quieres invertir y por cuánto tiempo. Buscaré únicamente opciones vigentes que coincidan.',
    event: DolaritoEvent.investmentThinking,
    priority: DolaritoPriority.motivation,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentOffersFound(int count) => DolaritoReaction(
    mood: DolaritoMood.excited,
    message: count == 1
        ? 'Encontré una alternativa compatible. Revisa la tasa y sus condiciones antes de decidir.'
        : 'Encontré $count alternativas compatibles. Compara la tasa, la estimación y las condiciones antes de decidir.',
    event: DolaritoEvent.investmentOffersFound,
    priority: DolaritoPriority.informative,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentNoOffers() => const DolaritoReaction(
    mood: DolaritoMood.thinking,
    message:
        'No encontré ofertas vigentes para ese monto y plazo. Probemos otro monto o plazo.',
    event: DolaritoEvent.investmentNoOffers,
    priority: DolaritoPriority.informative,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentOfferSelected() => const DolaritoReaction(
    mood: DolaritoMood.proud,
    message:
        'Revisa el resumen. Solo compartiré tus datos con la cooperativa que elijas y cuando nos des permiso.',
    event: DolaritoEvent.investmentOfferSelected,
    priority: DolaritoPriority.actionable,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentRequestSent() => const DolaritoReaction(
    mood: DolaritoMood.waiting,
    message:
        'Tu solicitud fue enviada. La cooperativa debe confirmar las condiciones; aún no es una inversión formalizada.',
    event: DolaritoEvent.investmentRequestSent,
    priority: DolaritoPriority.informative,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentConnectionError() => const DolaritoReaction(
    mood: DolaritoMood.worried,
    message:
        'No pude consultar el servicio de inversiones. Inténtalo de nuevo cuando recuperes la conexión.',
    event: DolaritoEvent.connectionError,
    priority: DolaritoPriority.alert,
    dismissible: true,
    scopeKey: 'investment',
  );

  DolaritoReaction investmentRequestStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return investmentRequestSent();
      case 'IN_REVIEW':
        return const DolaritoReaction(
          mood: DolaritoMood.thinking,
          message:
              'La cooperativa está revisando tu solicitud. Te avisaremos cuando responda.',
          event: DolaritoEvent.investmentRequestStatus,
          priority: DolaritoPriority.informative,
          scopeKey: 'investment',
        );
      case 'INFORMATION_REQUIRED':
        return const DolaritoReaction(
          mood: DolaritoMood.worried,
          message:
              'La cooperativa necesita información adicional. Revisa el mensaje de tu solicitud para ver qué debes hacer.',
          event: DolaritoEvent.investmentRequestStatus,
          priority: DolaritoPriority.actionable,
          scopeKey: 'investment',
        );
      case 'CONDITIONS_CONFIRMED':
        return const DolaritoReaction(
          mood: DolaritoMood.excited,
          message:
              'La cooperativa confirmó las condiciones. Contacta directamente con ella para formalizar; DINEROP no recibe ni custodia tu dinero.',
          event: DolaritoEvent.investmentRequestStatus,
          priority: DolaritoPriority.celebration,
          scopeKey: 'investment',
        );
      case 'DECLINED':
        return const DolaritoReaction(
          mood: DolaritoMood.sad,
          message:
              'La cooperativa no pudo continuar con esta solicitud. Revisa su mensaje y compara otras opciones vigentes.',
          event: DolaritoEvent.investmentRequestStatus,
          priority: DolaritoPriority.actionable,
          scopeKey: 'investment',
        );
      default:
        return const DolaritoReaction(
          mood: DolaritoMood.thinking,
          message:
              'Consulta los detalles para confirmar el estado de esta solicitud.',
          event: DolaritoEvent.investmentRequestStatus,
          priority: DolaritoPriority.informative,
          scopeKey: 'investment',
        );
    }
  }

  DolaritoReaction notification(PushNotificationEvent event) {
    final scope = event.solicitudId == null
        ? 'notification'
        : 'credit:${event.solicitudId}';
    switch (event.type.toUpperCase()) {
      case 'CREDIT_ACCEPTED':
        return DolaritoReaction(
          mood: DolaritoMood.excited,
          message:
              '¡Buenas noticias! La cooperativa aceptó esta solicitud. Revisa los requisitos y los siguientes pasos.',
          event: DolaritoEvent.creditAccepted,
          priority: DolaritoPriority.celebration,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver solicitud',
          scopeKey: scope,
        );
      case 'CREDIT_REJECTED':
        return DolaritoReaction(
          mood: DolaritoMood.sad,
          message:
              'La cooperativa respondió. Revisa los detalles de esta solicitud y sus alternativas.',
          event: DolaritoEvent.creditRejected,
          priority: DolaritoPriority.actionable,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver detalles',
          scopeKey: scope,
        );
      case 'GUARANTEE_REQUIRED':
        return DolaritoReaction(
          mood: DolaritoMood.explaining,
          message: DolaritoMessages.guaranteeRequired,
          event: DolaritoEvent.guaranteeRequired,
          priority: DolaritoPriority.critical,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver solicitud',
          scopeKey: scope,
        );
      case 'GUARANTEE_CORRECTION':
      case 'GUARANTEE_REJECTED':
        return DolaritoReaction(
          mood: DolaritoMood.worried,
          message:
              'La información del garante necesita atención. Revisa los motivos y los pasos indicados.',
          event: DolaritoEvent.informationPending,
          priority: DolaritoPriority.alert,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Revisar solicitud',
          scopeKey: scope,
        );
      default:
        return DolaritoReaction(
          mood: DolaritoMood.thinking,
          message:
              'Tienes una notificación nueva. Revisa tus solicitudes para consultar el estado confirmado.',
          event: DolaritoEvent.pushUpdate,
          priority: DolaritoPriority.informative,
          action: DolaritoAction.viewRequests,
          actionLabel: 'Ver solicitudes',
          scopeKey: scope,
        );
    }
  }
}
