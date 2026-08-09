enum CreditRequestType { credito, inversion, unknown }
enum CreditType { microcredito, consumo, unknown }
enum CreditRequestStatus { creada, enviada, preAprobada, solicitandoGarante, rechazada, aceptada, unknown }
enum CreditDecision { preAprobar, rechazar }

CreditRequestType creditRequestTypeFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'CREDITO':
      return CreditRequestType.credito;
    case 'INVERSION':
      return CreditRequestType.inversion;
    default:
      return CreditRequestType.unknown;
  }
}

CreditType creditTypeFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'MICROCREDITO':
      return CreditType.microcredito;
    case 'CONSUMO':
      return CreditType.consumo;
    default:
      return CreditType.unknown;
  }
}

CreditRequestStatus creditRequestStatusFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'CREADA':
      return CreditRequestStatus.creada;
    case 'ENVIADA':
      return CreditRequestStatus.enviada;
    case 'PRE_APROBADA':
      return CreditRequestStatus.preAprobada;
    case 'SOLICITANDO_GARANTE':
      return CreditRequestStatus.solicitandoGarante;
    case 'RECHAZADA':
      return CreditRequestStatus.rechazada;
    case 'ACEPTADA':
      return CreditRequestStatus.aceptada;
    default:
      return CreditRequestStatus.unknown;
  }
}

String creditDecisionToApiValue(CreditDecision decision) {
  switch (decision) {
    case CreditDecision.preAprobar:
      return 'PRE_APROBAR';
    case CreditDecision.rechazar:
      return 'RECHAZAR';
  }
}