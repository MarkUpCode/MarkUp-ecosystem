enum OnboardingFormStatus { pending, requested, complete, unknown }

class OnboardingStatusResponse {
  const OnboardingStatusResponse({required this.formularioCompleto, required this.estadoFormulario});

  final bool formularioCompleto;
  final OnboardingFormStatus estadoFormulario;

  factory OnboardingStatusResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusResponse(
      formularioCompleto: json['formularioCompleto'] == true,
      estadoFormulario: _statusFromString(json['estadoFormulario']?.toString()),
    );
  }

  static OnboardingFormStatus _statusFromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'PENDIENTE':
        return OnboardingFormStatus.pending;
      case 'SOLICITADO':
        return OnboardingFormStatus.requested;
      case 'COMPLETO':
        return OnboardingFormStatus.complete;
      default:
        return OnboardingFormStatus.unknown;
    }
  }
}